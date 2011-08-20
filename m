From: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] BTRFS: Free inode mutex on lseek error
Date: Sat, 20 Aug 2011 14:53:17 +0200
Message-ID: <20110820125317.GJ25996@one.firstfloor.org>
References: <1313798858-10938-1-git-send-email-andi@firstfloor.org> <4E4FA3B9.6000203@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Andi Kleen <andi@firstfloor.org>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
	chris.mason@oracle.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E4FA3B9.6000203@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Aug 20, 2011 at 08:08:25AM -0400, Josef Bacik wrote:
> On 08/19/2011 08:07 PM, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > Introduced with b26751575a9aa55fd6dbf3febde3ff06dfadc44f
> > 
> 
> This has already been fixed by
> 
> 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

It's not. That patch returns the wrong return value.

-Andi

---

>From 3c3bb2aa661c2b3405c53ac72e23fc663aea794f Mon Sep 17 00:00:00 2001
From: Andi Kleen <ak@linux.intel.com>
Date: Sat, 20 Aug 2011 05:49:47 -0700
Subject: [PATCH] BTRFS: Fix lseek return value for error

Introduced by 9a4327ca1f45f82edad7dc0a4e52ce9316e0950c

Signed-off-by: Andi Kleen <ak@linux.intel.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..c6e493f 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1814,19 +1814,17 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	case SEEK_DATA:
 	case SEEK_HOLE:
 		ret = find_desired_extent(inode, &offset, origin);
-		if (ret) {
-			mutex_unlock(&inode->i_mutex);
-			return ret;
-		}
+		if (ret)
+			goto error;
 	}
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
 		ret = -EINVAL;
-		goto out;
+		goto error;
 	}
 	if (offset > inode->i_sb->s_maxbytes) {
 		ret = -EINVAL;
-		goto out;
+		goto error;
 	}
 
 	/* Special lock needed here? */
@@ -1837,6 +1835,9 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 out:
 	mutex_unlock(&inode->i_mutex);
 	return offset;
+error:
+	mutex_unlock(&inode->i_mutex);
+	return ret;
 }
 
 const struct file_operations btrfs_file_operations = {
