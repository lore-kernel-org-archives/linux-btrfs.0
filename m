Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:42000 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbaC3Euf (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Mar 2014 00:50:35 -0400
Date: Sat, 29 Mar 2014 21:50:30 -0700
From: Marc MERLIN <marc@merlins.org>
To: "sepero111@gmx.com" <sepero111@gmx.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Especially broken btrfs
Message-ID: <20140330045030.GA22552@merlins.org>
References: <532BB037.90401@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <532BB037.90401@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 20, 2014 at 11:21:27PM -0400, sepero111@gmx.com wrote:
> Hello all. I submit bugs to different foss projects regularly, but I
> don't really have a bug report this time. I have a broken filesystem
> to report. And I have no idea how to reproduce it.
> 
> I am including a link to the filesystem itself, because it appears
> to be unrepairable and unrestorable. I have no personal information
> on the disk image. The filesystem is almost 512MB uncompressed. I
> was using it on an old usb drive with 512MB size limitation. I only
> used (abused?) it about 2 days before this corruption.
> 
> My goal was to use the usb as a bootable rescue system. I decided to
> try Btrfs instead of Ext4, because it supports filesystem
> compression.
> 
> BTRFS IMAGE LINK (please pardon my file hosting service)
> http://www.mediafire.com/download/gdaydt3mz8uwtmm/sdb1.btrfs.xz
 
It looks like you got no answer, and I'm not a dev so I can't help you
either.

The btrfs devs are pretty busy and can't always get back to everyone.
Hopefully they'll be able to look at this, but sorry if not.

Marc
 
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

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
