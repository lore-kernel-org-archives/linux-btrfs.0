Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv2.trombetti.net ([65.254.53.252]:2948 "EHLO server"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752958AbaCaRMG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 13:12:06 -0400
Received: from localhost (localhost [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: SASL)
	by server (Postfix) with ESMTPSA id 81BAF31307
	for <linux-btrfs@vger.kernel.org>; Mon, 31 Mar 2014 13:08:40 -0400 (EDT)
Message-ID: <5339A026.2070907@shiftmail.org>
Date: Mon, 31 Mar 2014 19:04:38 +0200
From: Bob Marley <bobmarley@shiftmail.org>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Especially broken btrfs
References: <532BB037.90401@gmx.com>
In-Reply-To: <532BB037.90401@gmx.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, I hadn't noticed this post,
I think I know the reason this time : you have used USB you bad guy!
I think USB does not support flush / barrier , which is mandatory for 
BTRFS to work correctly in case of power loss.
For most filesystems actually, but the damages suffered by COW 
filesystems such as btrfs are much more severe than for static 
filesystems such as ext4 .

Please check if when you connect the USB drive you see in dmesg 
something like:

|[  .... . .....] sd ...:0:0:0: [sdf] Write cache: ....., read cache: ....., doesn't support DPO or FUA
|

Regards
BM


On 21/03/2014 04:21, sepero111@gmx.com wrote:
> Hello all. I submit bugs to different foss projects regularly, but I 
> don't really have a bug report this time. I have a broken filesystem 
> to report. And I have no idea how to reproduce it.
>
> I am including a link to the filesystem itself, because it appears to 
> be unrepairable and unrestorable. I have no personal information on 
> the disk image. The filesystem is almost 512MB uncompressed. I was 
> using it on an old usb drive with 512MB size limitation. I only used 
> (abused?) it about 2 days before this corruption.
>
> My goal was to use the usb as a bootable rescue system. I decided to 
> try Btrfs instead of Ext4, because it supports filesystem compression.
>
> BTRFS IMAGE LINK (please pardon my file hosting service)
> http://www.mediafire.com/download/gdaydt3mz8uwtmm/sdb1.btrfs.xz
>
>
> These are some things that may have helped to cause the corruption.
>
> +Created btrfs with -M flag
> +Installed Debian testing/unstable
> +When mounting, I always used at least these options: 
> ssd_spread,noatime,compression=zlib,autodefrag
> +Occasionally force powering off computer.
> +While booted into usb system, I was constantly running out of space 
> while trying to install new packages.
>
> It is my hope that this image might be used to improve the btrfs 
> restore and btrfsck tools. Please let me know if I can provide any 
> further information. Big thanks to everyone helping to further 
> development of Btrfs.
>
> Sepero
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

