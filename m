Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58881 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157Ab3FQUEr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Jun 2013 16:04:47 -0400
Date: Mon, 17 Jun 2013 13:04:45 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Mason <clmason@fusionio.com>, Josef Bacik <josef@redhat.com>,
        Gabriel de Perthuis <g2p.code@gmail.com>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 0/4] btrfs: offline dedupe v2
Message-ID: <20130617200445.GI29353@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <1370982698-757-1-git-send-email-mfasheh@suse.de> <20130612181037.GD658@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130612181037.GD658@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 12, 2013 at 02:10:37PM -0400, Josef Bacik wrote:
> On Tue, Jun 11, 2013 at 02:31:34PM -0600, Mark Fasheh wrote:
> > Hi,
> > 
> > The following series of patches implements in btrfs an ioctl to do
> > offline deduplication of file extents.
> 
> Ok I'm relatively happy with this set, I just want to have an xfstest on deck to
> test it with.  Once I have an xfstest to run to verify its sanity I'll pull it
> in.  Thanks,

Awesome thanks Josef. Is it ok to include this patch as well, it implements
the semantics that Gabriel and I talked about. The patch is also on top of
the same git tree I have referenced in the original e-mails.

Btw, let me know if you want/need help writing an xfs test for this.
	--Mark

--
Mark Fasheh


From: Mark Fasheh <mfasheh@suse.de>

btrfs-extent-same: allow root to always dedupe

This will allow end users to run dedupe against their readonly snapshots - a
common method for making backups of btrfs subvolumes. Since it is impossible
for root to get a rw file descriptor on such a snapshot, this enables dedupe
from a privileged account to proceed with read access. Non root accounts
still have the same access restrictions - they cannot dedupe without write
access to the file.

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
---
 fs/btrfs/ioctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 9351b69..68931b9 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -2629,13 +2629,11 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 	u64 bs = BTRFS_I(src)->root->fs_info->sb->s_blocksize;
 	char *src_buffer = NULL;
 	char *dst_buffer = NULL;
+	bool is_admin = capable(CAP_SYS_ADMIN);
 
 	if (!(file->f_mode & FMODE_READ))
 		return -EINVAL;
 
-	if (btrfs_root_readonly(BTRFS_I(src)->root))
-		return -EROFS;
-
 	ret = mnt_want_write_file(file);
 	if (ret)
 		return ret;
@@ -2722,7 +2720,7 @@ static long btrfs_ioctl_file_extent_same(struct file *file,
 			continue;
 		}
 
-		if (!(dst_file->f_mode & FMODE_WRITE)) {
+		if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
 			info->status = -EINVAL;
 			goto next;
 		}
-- 
1.8.1.4

