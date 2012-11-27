Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserver1.prnet.org ([195.46.254.69]:63422 "EHLO
	extserver1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755851Ab2K0Qxh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Nov 2012 11:53:37 -0500
Message-ID: <50B4F009.40201@prnet.org>
Date: Tue, 27 Nov 2012 17:53:29 +0100
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs@vger.kernel.org
Subject: Re: extended attributes wiredness
References: <50AFB620.6040707@prnet.org> <2925363.jTFvA7mLni@vfr> <50AFE5FC.7040304@prnet.org> <20121124033910.GA5680@gmail.com> <50B27C4A.7040702@prnet.org> <20121126025439.GA5923@liubo> <50B3003E.2010104@prnet.org> <20121127074625.GA31592@liubo.cn.oracle.com>
In-Reply-To: <20121127074625.GA31592@liubo.cn.oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I tried to create an ext4 filesystem on a loop device and do a cp -a of
/var/lib/nfs/sm to the ext4 filesystem. Here the problem does not exist.
Perhaps ext4 has another behaviour in the sense that it doesn't store
empty attributes or doesn't return empty attributes.

I am using Gentoo and will try to do a new install on a loop device to
figure out which userspace program creates files this way.

Thanks in advance,
David Arendt

On 11/27/12 08:46, Liu Bo wrote:
> Hi,  
>  
> (cc btrfs Mailing list to notify others.)
>
> Thanks for the helpful test.img.
>
> Well...after deeper debug, I'm sure that it's not a btrfs bug,
> at least not a btrfs acl/xattr bug. 
>  
> The debug tree shows 
>  
> item 10 key (257 INODE_ITEM 0) itemoff 3387 itemsize 160 
>         inode generation 6 transid 6 size 102 block group 0 mode 40755 links 1 
> item 11 key (257 INODE_REF 256) itemoff 3372 itemsize 15 
>         inode ref index 2 namelen 5 name: test1 
> item 12 key (257 XATTR_ITEM 367492571) itemoff 3318 itemsize 54 
>         location key (0 UNKNOWN.0 0) type 8 
>         namelen 24 datalen 0 name: system.posix_acl_default 
>                   ^^^^^^^^^^^ 
> item 13 key (257 XATTR_ITEM 2038346239) itemoff 3237 itemsize 81 
>         location key (0 UNKNOWN.0 0) type 8 
>         namelen 23 datalen 28 name: system.posix_acl_access 
>         data ^B 
>  
> ========== 
>
> so extended attribute "system.posix_acl_default" here has not data, which'll
> make filesystems(not just btrfs) return -ENODATA. 
>  
> I guess some userspace applications may make it like that. 
>  
> thanks, 
> liubo
>
> On Mon, Nov 26, 2012 at 06:38:06AM +0100, David Arendt wrote:
>> Hi,
>>
>> I don't know if your xattr patch was meant to fix this issue, but I have
>> just tested kernel 3.7-rc7 with your patch applied on another directory
>> having the problem and I still have the weird behaviour.
>>
>> Thanks in advance,
>> David Arendt

