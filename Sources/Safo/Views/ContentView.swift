import SwiftUI

struct ContentView: View {
    var body: some View {
        MarkdownContentView(content: Self.testMarkdown)
    }
}

// MARK: - Test fixture

extension ContentView {
    static let testMarkdown = """
    # Heading 1

    ## Heading 2

    ### Heading 3

    #### Heading 4

    ##### Heading 5

    ###### Heading 6

    ---

    This is a regular paragraph with **bold text**, *italic text*, and ~~strikethrough text~~. \
    Here is some `inline code` and a [link to Significa](https://significa.co).

    > This is a blockquote. It should have a left border and secondary text color. \
    > It can span multiple lines and contain **bold** and *italic* text.

    ## Lists

    Unordered list:

    - First item
    - Second item
      - Nested item A
      - Nested item B
    - Third item

    Ordered list:

    1. First step
    2. Second step
       1. Sub-step one
       2. Sub-step two
    3. Third step

    Task list:

    - [x] Completed task
    - [ ] Incomplete task
    - [x] Another completed task

    ## Code

    Inline code: `let x = 42`

    Swift code block:

    ```swift
    import SwiftUI

    struct ContentView: View {
        @State private var count = 0

        var body: some View {
            VStack(spacing: 16) {
                Text("Count: \\(count)")
                    .font(.title)

                Button("Increment") {
                    count += 1
                }
            }
            .padding()
        }
    }
    ```

    TypeScript code block:

    ```typescript
    interface User {
        id: string;
        name: string;
        email: string;
    }

    async function fetchUser(id: string): Promise<User> {
        const response = await fetch(`/api/users/${id}`);
        return response.json();
    }
    ```

    Code block without language:

    ```
    plain text code block
    no syntax highlighting
    just monospace font
    ```

    ## Table

    | Feature | Status | Notes |
    |---------|--------|-------|
    | Markdown rendering | Done | Using MarkdownUI |
    | Syntax highlighting | Done | Using Splash |
    | Dark mode | Done | System adaptive |
    | File watching | Pending | Phase 2 |

    ---

    End of test fixture.
    """
}
