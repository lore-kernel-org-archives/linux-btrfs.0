From: Chris Mason <chris.mason@oracle.com>
Subject: [GIT PULL] Btrfs fix
Date: Mon, 03 Oct 2011 14:25:12 -0400
Message-ID: <1317666169-sup-1696@shiny>
Content-Type: text/plain; charset=UTF-8
To: "Linus Torvalds" <torvalds@linux-foundation.org>,
	"Linux Btrfs" <linux-btrfs@vger.kernel.org>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi everyone,

Josef found a btrfs bug that can lead us to loop trying to fault in
pages during btrfs_file_write.  I've pushed the fix out to the btrfs git
tree.  Linus, please pull from the btrfs-3.0 branch:

git://github.com/chrismason/linux.git btrfs-3.0


Josef Bacik (1) commits (+16/-8):
    Btrfs: force a page fault if we have a shorty copy on a page boundary

Total: (1) commits (+16/-8)

 fs/btrfs/file.c |   24 ++++++++++++++++--------
 1 files changed, 16 insertions(+), 8 deletions(-)
