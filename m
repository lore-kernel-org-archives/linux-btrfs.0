From: Sage Weil <sage@newdream.net>
Subject: Re: cp --reflink with Btrfs
Date: Wed, 16 Dec 2009 09:55:43 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0912160943280.2801@cobra.newdream.net>
References: <hg1cge$74i$1@ger.gmane.org> <20091214162323.GA2165@localhost.localdomain>
 <hg96k6$q17$1@ger.gmane.org> <4b287dd5.5744f10a.3536.2011@mx.google.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-btrfs@vger.kernel.org
To: Li Dongyang <jerry87905@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4b287dd5.5744f10a.3536.2011@mx.google.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 16 Dec 2009, Li Dongyang wrote:

> Have a look at line 998, ioctl.c, inside btrfs_ioctl_clone(),
> the src->i_size(the size of the testfile created by touch) is just 0, and this 
> will cause btrfs_ioctl_clone just return -EINVAL.
> I'm not sure if it makes sense to clone a file which actually doesn't have any 
> data extents.

Probably not, but it seems more consistent to return success instead than 
-EINVAL.  Requiring the caller to check and special case empty files isn't 
very friendly...

sage

---
Subject: [PATCH] Btrfs: return success when cloning 0 byte range at eof

We currently return -EINVAL when cloning a zero byte range at EOF (most 
commonly when cloning a 0 byte file).  Return success instead, even though 
this is a no-op.

Signed-off-by: Sage Weil <sage@newdream.net>
---
 fs/btrfs/ioctl.c |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index cdbb054..1a964a4 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -994,8 +994,11 @@ static noinline long btrfs_ioctl_clone(struct file *file, unsigned long srcfd,
 	}
 
 	/* determine range to clone */
+	ret = 0;
+	if (off == src->i_size && len == 0)
+		goto out_unlock;
 	ret = -EINVAL;
-	if (off >= src->i_size || off + len > src->i_size)
+	if (off > src->i_size || off + len > src->i_size)
 		goto out_unlock;
 	if (len == 0)
 		olen = len = src->i_size - off;
-- 
1.6.5

