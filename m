Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:35399 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751729Ab2FLRl0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 13:41:26 -0400
Message-ID: <4FD77F45.3060000@libero.it>
Date: Tue, 12 Jun 2012 19:41:25 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: kreijack@inwind.it
CC: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Liu Bo <liubo2009@cn.fujitsu.com>, "Ted Ts'o" <tytso@mit.edu>
Subject: Re: Btrfs and data nocow per inode basis
References: <4FD442F1.7040008@inwind.it>
In-Reply-To: <4FD442F1.7040008@inwind.it>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2012 08:47 AM, Goffredo Baroncelli wrote:
> Hi all,
> 
> which is the supposed corrected way to set the file flag FS_NOCOW_FL ? I
> know that exists the associated ioctl FS_IOC_SETFLAGS; which I didn't
> found is an user-space tool to use to set the flags.
> 
> I am missing something ?

After a bit of googling I found a Liu Bo patches which add the ability
to set the NOCOW flags to a btrfs file.[1]

However it seems that it was not present in the current (v1.42.3)
e2fsprogs suite.

There is any reason which stopped the adoption of this patch ?
Does make sense to add the chattr/lsattr capability to the btrfs tool (I
am thinking about new commands like "btrfs filesystem chattr"/"btrfs
filesystem lsattr") ?

G.Baroncelli

[1] http://patchwork.ozlabs.org/patch/91697/


> 
> Thanks in advance
> G.Baroncelli
> 
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> .
> 

