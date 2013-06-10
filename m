Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18944 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751051Ab3FJWkA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Jun 2013 18:40:00 -0400
Date: Mon, 10 Jun 2013 15:39:58 -0700
From: Zach Brown <zab@redhat.com>
To: Chris Mason <chris.mason@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130610223958.GL24721@lenny.home.zabbo.net>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130604231653.4088.91500@localhost.localdomain>
 <20130604232657.GE24721@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130604232657.GE24721@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 04, 2013 at 04:26:57PM -0700, Zach Brown wrote:
> On Tue, Jun 04, 2013 at 07:16:53PM -0400, Chris Mason wrote:
> > Quoting Zach Brown (2013-06-04 18:17:54)
> > > Hi gang,
> > > 
> > > I finally sat down to fix that readdir hang that has been in the back
> > > of my mind for a while.  I *hope* that the fix is pretty simple: just
> > > don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> > > indicator that we shouldn't return entries.  Does this look reasonable?
> > 
> > I like it, and it doesn't look too far away from how others are abusing
> > f_version.  Have you tried with NFS?  I don't think it'll hurt, but NFS
> > loves to surprise me.
> 
> Mm, no, I hadn't.  I'll give it a go tomorrow.  What could go wrong? :)

Or a week later.  Pretty close!

I couldn't get NFS to break.  Clients see new entries created directly
in the exported btrfs and on either of noac and actime=1 client mounts.
For whatever that's worth.

But I did find that I'd broken the case of trying to re-enable readdir
results by seeking past the last entry (which happens to be the current
f_pos now that we're using f_version).

Here's the incremental fix against what Josef has in -next.  I'm cool
with either squashing or just committing it.

- z

Subject: [PATCH] btrfs: reset f_version when seeking to pos

Commit 63e3dfe ("btrfs: fix readdir hang with offsets past INT_MAX")
switched to using f_version to stop readdir results instead of setting a
large f_pos.

It inadvertantly changed behaviour in the case where an app specifically
seeks to one past the last valid dent->d_off it has seen.  Previously
f_pos would have changed from the fake f_pos to this new f_pos which
would let readdir return new entries.

But now that it's using f_version it might not have seen new entries.
generic_file_llseek() won't clear f_version if the desirned pos happens
to be the current f_pos.

So we add a little wrapper to notice this case and clear f_version so
that entries can be seen in this case.

Signed-off-by: Zach Brown <zab@redhat.com>
---
 fs/btrfs/inode.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 1059c90..590c274 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4997,6 +4997,23 @@ unsigned char btrfs_filetype_table[] = {
  * which prevents readdir results until seek resets f_pos and f_version.
  */
 #define BTRFS_READDIR_EOF ~0ULL
+static loff_t btrfs_dir_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *inode = file->f_mapping->host;
+	loff_t ret;
+
+	/*
+	 * f_version isn't reset if a seek is attempted to the current pos.  A
+	 * caller can be trying to see more entries by seeking past the last
+	 * entry to the current pos after creating a new entry.
+	 */
+	mutex_lock(&inode->i_mutex);
+	ret = generic_file_llseek(file, offset, whence);
+	if (ret == offset && file->f_version == BTRFS_READDIR_EOF)
+		file->f_version = 0;
+	mutex_unlock(&inode->i_mutex);
+	return ret;
+}
 
 static int btrfs_real_readdir(struct file *filp, void *dirent,
 			      filldir_t filldir)
@@ -8642,7 +8659,7 @@ static const struct inode_operations btrfs_dir_ro_inode_operations = {
 };
 
 static const struct file_operations btrfs_dir_file_operations = {
-	.llseek		= generic_file_llseek,
+	.llseek		= btrfs_dir_llseek,
 	.read		= generic_read_dir,
 	.readdir	= btrfs_real_readdir,
 	.unlocked_ioctl	= btrfs_ioctl,
-- 
1.7.11.7

