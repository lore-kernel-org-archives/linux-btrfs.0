Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:39923 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752993Ab3AXKAd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Jan 2013 05:00:33 -0500
Message-ID: <5101062E.5060604@oracle.com>
Date: Thu, 24 Jan 2013 18:00:14 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Brendan Hide <brendan@swiftspirit.co.za>
CC: linux-btrfs Mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: inconsistent output on sub list
References: <50FEEB9E.2060305@swiftspirit.co.za>
In-Reply-To: <50FEEB9E.2060305@swiftspirit.co.za>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Brendan,

  -------
  >> [root@watricky mnt]# btrfs subvolume list / -a
  >> ID 258 gen 4226 top level 384 path media/smbshare
  ::
  >> [root@watricky mnt]# btrfs subvolume list /home -a
  >> ID 258 gen 4226 top level 5 path 
<FS_TREE>/__active/media/smbshare4.snap
  -------
  This is definitely a bug. Thanks for reporting.

  I have made some fair-assumptions, and have sent out the
  patch[1] to fix this bug (ref this email thread). Could you
  kindly test it and report the result ?

[1]
[PATCH] Btrfs-progs: we need to have the string null terminated

Thanks,  Anand


On 01/23/2013 03:42 AM, Brendan Hide wrote:
> Linux watricky 3.6.11-1-ARCH #1 SMP PREEMPT Tue Dec 18 08:57:15 CET 2012
> x86_64 GNU/Linux
>
> In working on a snapshot maintenance script I've noticed some odd
> behaviour. Note the smbshare path. I've put this into its own subvolume
> as I don't plan on snapshotting it.
>
> In the first command's output, this path is printed correctly, however
> in the second output it has "4.snap" appended, similar to the names of
> the snapshots I made 22 hours ago.
>
> If this is a documented issue with a fix then no worries. But if not and
> anyone wants me to check into any further specifics, please let me know.
>
>  > [root@watricky mnt]# btrfs subvolume list / -a
>  > ID 258 gen 4226 top level 384 path media/smbshare
>  > ID 259 gen 4337 top level 384 path home
>  > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
>  > ID 392 gen 4337 top level 384 path var
>  > ID 393 gen 4267 top level 384 path usr
>  > ID 428 gen 4267 top level 5 path
> <FS_TREE>/__snapshot/__active.20130121-23h44.snap
>  > ID 429 gen 3980 top level 5 path
> <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
>  > ID 430 gen 4043 top level 5 path
> <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
>  > ID 431 gen 4267 top level 5 path
> <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
>  > [root@watricky mnt]# btrfs subvolume list /home -a
>  > ID 258 gen 4226 top level 5 path <FS_TREE>/__active/media/smbshare4.snap
>  > ID 259 gen 4337 top level 5 path <FS_TREE>/__active/home
>  > ID 384 gen 4321 top level 5 path <FS_TREE>/__active
>  > ID 392 gen 4337 top level 5 path <FS_TREE>/__active/var
>  > ID 393 gen 4267 top level 5 path <FS_TREE>/__active/usr
>  > ID 428 gen 4267 top level 5 path
> <FS_TREE>/__snapshot/__active.20130121-23h44.snap
>  > ID 429 gen 3980 top level 5 path
> <FS_TREE>/__snapshot/__active_home.20130121-23h45.snap
>  > ID 430 gen 4043 top level 5 path
> <FS_TREE>/__snapshot/__active_var.20130121-23h45.snap
>  > ID 431 gen 4267 top level 5 path
> <FS_TREE>/__snapshot/__active_usr.20130121-23h45.snap
>  > [root@watricky mnt]#
>
> Note that the only directly mounted share is __active, mounted at /.
>
