From: Arnd Hannemann <arnd@arndnet.de>
Subject: [PATCH] Fix URL of btrfs-progs git repository in docs
Date: Wed, 16 Nov 2011 17:35:37 +0100
Message-ID: <1321461337-9812-1-git-send-email-arnd@arndnet.de>
Cc: chris.mason@oracle.com, Arnd Hannemann <arnd@arndnet.de>
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

	The location of the btrfs-progs repository has been changed.
	This patch updates the documentation accordingly.

Signed-off-by: Arnd Hannemann <arnd@arndnet.de>
---
 Documentation/filesystems/btrfs.txt |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/btrfs.txt b/Documentation/filesystems/btrfs.txt
index 64087c3..7671352 100644
--- a/Documentation/filesystems/btrfs.txt
+++ b/Documentation/filesystems/btrfs.txt
@@ -63,8 +63,8 @@ IRC network.
 Userspace tools for creating and manipulating Btrfs file systems are
 available from the git repository at the following location:
 
- http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs-unstable.git
- git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs-unstable.git
+ http://git.kernel.org/?p=linux/kernel/git/mason/btrfs-progs.git
+ git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git
 
 These include the following tools:
 
-- 
1.7.5.4

