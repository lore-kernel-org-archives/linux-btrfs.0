Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:50269 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932207Ab2HQPaj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Aug 2012 11:30:39 -0400
Message-ID: <502E6386.700@oracle.com>
Date: Fri, 17 Aug 2012 23:30:14 +0800
From: Liu Bo <bo.li.liu@oracle.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: =?ISO-8859-1?Q?Llu=EDs_Batlle_i_Rossell?= <viric@viric.name>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>, andrei.popa@i-neo.ro
Subject: Re:
References: <20120815101229.GH25996@vicerveza.homeunix.net> <502DA230.6010202@oracle.com> <20120817145940.GI17430@twin.jikos.cz>
In-Reply-To: <20120817145940.GI17430@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/17/2012 10:59 PM, David Sterba wrote:
> On Fri, Aug 17, 2012 at 09:45:20AM +0800, Liu Bo wrote:
>> On 08/15/2012 06:12 PM, Lluís Batlle i Rossell wrote:
>>> some time ago we discussed on #btrfs that the nocow attribute for files wasn't
>>> working (around 3.3 or 3.4 kernels). That was evident by files fragmenting even
>>> with the attribute set.
>>>
>>> Chris mentioned to find a fix quickly for that, and posted some lines of change
>>> into irc. But recently someone mentioned that 3.6-rc looks like still not
>>> respecting nocow for files.
>>>
>>> Is there really a fix upstream for that? Do nocow attribute on files work for
>>> anyone already?
>>>
>>
>> Dave had post a patch to fix it but only enabling NOCOW with zero sized file.
>>
>> FYI, the patch is http://article.gmane.org/gmane.comp.file-systems.btrfs/17351
>>
>> With the patch, you don't need to mount with nodatacow any more :)
>>
>> And why it is only for only zero sized file:
>> http://permalink.gmane.org/gmane.comp.file-systems.btrfs/18046
> 
> the original patch http://permalink.gmane.org/gmane.comp.file-systems.btrfs/18031
> did two things, the reasoning why it is not allowed to set nodatasum in
> general applies only to the second hunk but this
> 
> @@ -139,7 +139,7 @@ void btrfs_inherit_iflags(struct inode *inode, struct inode *dir)
>  	}
> 
>  	if (flags & BTRFS_INODE_NODATACOW)
> -		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
> +		BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW | BTRFS_INODE_NODATASUM;
> 
>  	btrfs_update_iflags(inode);
>  }
> ---
> 
> is sufficient to create nocow files via a directory with NOCOW attribute
> set, and all new files will inherit it (they are automatically
> zero-sized so it's safe). This usecase is similar to setting the
> COMPRESS attribute on a directory and all new files will inherit the
> flag.
> 
> If Andrei wants to resend just this particular hunk, I'm giving it my ACK.
> 

IMO the following is better, just make use of the original check.  If you agree with this,
I'll send it as a patch :)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 6e8f416..d4e58df 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -4721,8 +4721,10 @@ static struct inode *btrfs_new_inode(struct btrfs_trans_handle *trans,
 		if (btrfs_test_opt(root, NODATASUM))
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
 		if (btrfs_test_opt(root, NODATACOW) ||
-		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW))
+		    (BTRFS_I(dir)->flags & BTRFS_INODE_NODATACOW)) {
 			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATACOW;
+			BTRFS_I(inode)->flags |= BTRFS_INODE_NODATASUM;
+		}
 	}
 
 	insert_inode_hash(inode);


> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

