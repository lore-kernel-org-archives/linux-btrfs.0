Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:55381 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000AbaFEQ0r (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 12:26:47 -0400
Date: Thu, 5 Jun 2014 09:26:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Using BTRFS on SSD now ?
Message-ID: <20140605162646.GF14713@merlins.org>
References: <2215647.hErg5R77lo@zafu> <1693566.Q9bXme5jtu@xev> <1493894.GW2nr4reAA@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <1493894.GW2nr4reAA@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 05:14:29PM +0200, Swâmi Petaramesh wrote:
> > your laptop is your main desktop system it should get less disk use than a
> > typical workstation.
> 
> My laptop (+ docking station) is going to be my daily main machine...
 
My laptop is my workstation, it's running almost 24/7 on SSD with btrfs.
The main thing is having a good SSD (right now Samsung 840 EVO 1TB for me).

See:
http://marc.merlins.org/perso/linux/post_2012-08-15_The-tale-of-SSDs_-Crucial-C300-early-Death_-Samsung-830-extreme-random-IO-slowness_-and-settling-with-OCZ-Vertex-4.html

> > I don't believe that LVM offers any benefit if you use BTRFS.
> 
> BTRFS cannot handle swap. A full disk encryption needs the swap to be 
> encrypted as well. The only solution for getting both the swap and filesystems 
> encrypted using the same key is to put both of them on an LVM itself luks-
> encrypted using dm-crypt.

Not at all.
Again, you really want to avoid the LVM layer. It will only make things
slower.
This is my drive with encrypted swap
Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        2048     1050623      524288   83  Linux
/dev/sda2         1050624    42993663    20971520   83  Linux
/dev/sda3       105908224   139462655    16777216   82  Linux swap / Solaris
/dev/sda4       139462656  1953525167   907031256   83  Linux

See
https://btrfs.wiki.kernel.org/index.php/SysadminGuide#btrfs_on_top_of_dmcrypt
and solutions like
https://github.com/gebi/keyctl_keyscript

> All my machines have been made this way for *years*, so I know it works damn 
> well ;-)

I've used LVM for years too, it makes things slower and less reliable.
 
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
