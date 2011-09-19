From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
Date: Mon, 19 Sep 2011 15:30:02 -0400
Message-ID: <1316460509-sup-1132@shiny>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com> <1316357705-sup-2667@shiny> <20110919175203.GK7761@one.firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Cc: Jeff liu <jeff.liu@oracle.com>,
	Marco Stornelli <marco.stornelli@gmail.com>,
	Andi Kleen <ak@linux.intel.com>,
	Andreas Dilger <adilger@dilger.ca>,
	Christoph Hellwig <hch@infradead.org>,
	"viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: Andi Kleen <andi@firstfloor.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-reply-to: <20110919175203.GK7761@one.firstfloor.org>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Andi Kleen's message of 2011-09-19 13:52:03 -0400:
> > Thanks everyone, I've put Jeff's last version of this in my queue.
> 
> Can you post the version you merged? The previous ones all had issues.

https://github.com/chrismason/linux/commit/48802c8ae2a9d618ec734a61283d645ad527e06c

This was the last one sent, I thought it combined all the fixes.


commit 48802c8ae2a9d618ec734a61283d645ad527e06c
Author: Jeff Liu <jeff.liu@oracle.com>
Date:   Sun Sep 18 10:34:02 2011 -0400

    BTRFS: Fix lseek return value for error
    
    The recent reworking of btrfs' lseek lead to incorrect
    values being returned.  This adds checks for seeking
    beyond EOF in SEEK_HOLE and makes sure the error
    values come back correct.
    
    Andi Kleen also sent in similar patches.
    
    Signed-off-by: Jie Liu <jeff.liu@oracle.com>
    Reported-by: Andi Kleen <ak@linux.intel.com>
    Signed-off-by: Chris Mason <chris.mason@oracle.com>

diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
index 3c3abff..a381cd2 100644
--- a/fs/btrfs/file.c
+++ b/fs/btrfs/file.c
@@ -1817,6 +1817,11 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 		goto out;
 	case SEEK_DATA:
 	case SEEK_HOLE:
+		if (offset >= i_size_read(inode)) {
+			mutex_unlock(&inode->i_mutex);
+			return -ENXIO;
+		}
+
 		ret = find_desired_extent(inode, &offset, origin);
 		if (ret) {
 			mutex_unlock(&inode->i_mutex);
@@ -1825,11 +1830,11 @@ static loff_t btrfs_file_llseek(struct file *file, loff_t offset, int origin)
 	}
 
 	if (offset < 0 && !(file->f_mode & FMODE_UNSIGNED_OFFSET)) {
-		ret = -EINVAL;
+		offset = -EINVAL;
 		goto out;
 	}
 	if (offset > inode->i_sb->s_maxbytes) {
-		ret = -EINVAL;
+		offset = -EINVAL;
 		goto out;
 	}
 
