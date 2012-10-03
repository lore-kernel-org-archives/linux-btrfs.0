Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:54546 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932747Ab2JCADH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 2 Oct 2012 20:03:07 -0400
Date: Tue, 2 Oct 2012 20:03:04 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V4 0/7 ] Btrfs-progs: enhance btrfs subvol list only to
 show read-only snapshots
Message-ID: <20121003000304.GH3214@shiny>
References: <50584E6D.8000602@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <50584E6D.8000602@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 18, 2012 at 04:35:25AM -0600, Miao Xie wrote:
> We want 'btrfs subvolume list' only to list readonly subvolumes, this patch set
> introduces a new option 'r' to implement it.
> 
> You can use the command like that:
> 
> 	btrfs subvolume list -r <mnt>
> 
> Changelog v3 -> v4:
> - modify the check method which is used to check if btrfs_root_item contains otime and uuid
>   or not.
> - add filter set and comparer set which are used to manage the filters and comparers specified
>   by the users.
> - re-base the read-only subvolume list function.
> 
> Changelog v2 -> v3:
> - re-implement list_subvols()
> - re-implement this read-only subvolume list function based on the new list_subvols()
> 
> Changelog v1 -> v2:
> - address the comments from Goffredo Baroncelli
>   i,   change the changelog of the patches and make them more elaborate.
>   ii,  move the function declarations to a new head file.
>   iii, add the introduction of the new option 'r' into the man page
> 
> We can pull the patches from the URL
> 
> 	git://github.com/miaoxie/btrfs-progs.git master
> 
> This patchset is against the patches of Liu Bo, Anand Jain and mine which were sent by several
> days ago. And we also can pull those patches from the above URL.

These are all really useful additions!  How do you plan on using the
table option? (just curious).

I've got it pulled in here and it is working properly on my send/receive
backup volume (with lots of snapshots).

-chris
