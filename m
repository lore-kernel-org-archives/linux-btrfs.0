From: Jeff Liu <jeff.liu@oracle.com>
Subject: Re: Fix btrfs_file_llseek() to return -EINVAL directly
Date: Tue, 30 Aug 2011 11:59:05 +0800
Message-ID: <4E5C6009.6020908@oracle.com>
References: <4E5B6055.1080807@oracle.com>
Reply-To: jeff.liu@oracle.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: chris.mason@oracle.com, tm@tao.ma
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E5B6055.1080807@oracle.com>
List-ID: <linux-btrfs.vger.kernel.org>

Sorry, I forgot unlocking inode before returning -EINVAL in the previous 
patch, thanks Tao pointing this out!

 From 1825149c67cbfe7cbafcee4156e1f301dade7b0b Mon Sep 17 00:00:00 2001
From: Jie Liu <jeff.liu@oracle.com>
Date: Tue, 30 Aug 2011 11:51:00 +0800
Subject: [PATCH 1/1] Return -EINVAL ranther than offset if offset < 0 or 
offset >
  inode->i_sb->s_maxbytes.

Reported-by: Tao Ma <tm@tao.ma>
Signed-off-by: Jie Liu <jeff.liu@oracle.com>
---
  fs/btrfs/file.c |    9 +++++++--
  1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index e7872e4..082ae91 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1813,6 +1813,11 @@ static loff_t btrfs_file_llseek(struct file 
*file, loff_t offset, int origin)
          goto out;
      case SEEK_DATA:
      case SEEK_HOLE:
+        if (offset >= inode->i_size) {
+            mutex_unlock(&inode->i_mutex);
+            return -ENXIO;
+        }
+
          ret = find_desired_extent(inode, &offset, origin);
          if (ret) {
              mutex_unlock(&inode->i_mutex);
@@ -1821,11 +1826,11 @@ static loff_t btrfs_file_llseek(struct file 
*file, loff_t offset, int origin)
      }

      if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-        ret = -EINVAL;
+        offset = -EINVAL;
          goto out;
      }
      if (offset > inode->i_sb->s_maxbytes) {
-        ret = -EINVAL;
+        offset = -EINVAL;
          goto out;
      }

-- 
1.7.4.1

On 08/29/2011 05:48 PM, Jeff Liu wrote:
> Hello,
>
> In btrfs_file_llseek(), if the offset<  0 or offset>
> inode->i_sb->s_maxbytes, we should return -EINVAL rather than offset.
> Also,  if the offset>= inode->i_size for SEEK_DATA or SEEK_HOLE, return
> -ENXIO is ok IMHO.
>
>
> Signed-off-by: Jie Liu<jeff.liu@oracle.com>
>
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index e7872e4..2c126d0 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -1813,6 +1813,11 @@ static loff_t btrfs_file_llseek(struct file
> *file, loff_t offset, int origin)
>            goto out;
>        case SEEK_DATA:
>        case SEEK_HOLE:
> +        if (offset>= inode->i_size) {
> +            mutex_unlock(&inode->i_mutex);
> +            return -ENXIO;
> +        }
> +
>            ret = find_desired_extent(inode,&offset, origin);
>            if (ret) {
>                mutex_unlock(&inode->i_mutex);
> @@ -1820,14 +1825,11 @@ static loff_t btrfs_file_llseek(struct file
> *file, loff_t offset, int origin)
>            }
>        }
>
> -    if (offset<  0&&  !(file->f_mode&  FMODE_UNSIGNED_OFFSET)) {
> -        ret = -EINVAL;
> -        goto out;
> -    }
> -    if (offset>  inode->i_sb->s_maxbytes) {
> -        ret = -EINVAL;
> -        goto out;
> -    }
> +    if (offset<  0&&  !(file->f_mode&  FMODE_UNSIGNED_OFFSET))
> +        return -EINVAL;
> +
> +    if (offset>  inode->i_sb->s_maxbytes)
> +        return -EINVAL;
>
>        /* Special lock needed here? */
>        if (offset != file->f_pos) {
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

