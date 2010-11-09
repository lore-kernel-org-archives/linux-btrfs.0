From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Option "user_xattr"
Date: Tue, 09 Nov 2010 10:16:55 -0500
Message-ID: <1289315792-sup-5713@think>
References: <B$YEgZRD1uB@helmut.hullen.de>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Helmut Hullen <hullen@t-online.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <B$YEgZRD1uB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Helmut Hullen's message of 2010-11-09 10:11:00 -0500:
> Hallo, linux-btrfs,
> 
> does btrfs accept the (ext2/ext3) option "user_xattr"? Samba needs  
> something in that way, but
> 
>         mount -o user_xattrr <btrfs-partition> <mountpoint>
> 
We have this on by default in btrfs.  There is no requirement to add
additional mount options.

-chris
