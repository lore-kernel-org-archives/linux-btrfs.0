From: Maciej Piechotka <uzytkownik2@gmail.com>
Subject: Unmountable btrfs - part II
Date: Sat, 6 Aug 2011 17:53:33 +0000
Message-ID: <CAMcAH6iyZSE+04USi91xZQ9g_yhPRwO5TX8QQsN_B3cVg-0Msg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

After applying changes from Alexandre's patch I got following error:

Device 1 (/dev/picard-main/home) opened in fd 4
couldn't open because of unsupported option features (8).
btrfsck: disk-io.c:723: open_ctree_fd: Assertion `!(1)' failed.
zsh: abort      ./btrfsck /dev/picard-main/home

If I ask to ignore the unsupported features I get:

btrfsck: root-tree.c:46: btrfs_find_last_root: Assertion
`!(path->slots[0] == 0)' failed.

I would be grateful for any help.

Best regards
