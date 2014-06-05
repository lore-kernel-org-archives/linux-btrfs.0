Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54458 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592AbaFEO4d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Jun 2014 10:56:33 -0400
Date: Thu, 5 Jun 2014 07:56:32 -0700
From: Marc MERLIN <marc@merlins.org>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Using BTRFS on SSD now ?
Message-ID: <20140605145632.GD14713@merlins.org>
References: <2215647.hErg5R77lo@zafu>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <2215647.hErg5R77lo@zafu>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 05, 2014 at 03:30:26PM +0200, Swâmi Petaramesh wrote:
> Hi,
> 
> I just received a new laptop with a Micron 256GB SSD, and I plan to install 
> Fedora 20 onto it.
> 
> I'm considering either BTRFS or ext4 (over LUKS-encrypted LVM) for this 
> machine, but I'm afraid BTRFS might generate too much writes and shorten the 
> SSD lifespan... Or am I mistaken ?

Yeah,
1) a lot of us use btrfs on SSDs
2) SSD write lifetime is more than you think

However SSDs, especially at least earlier models of the one you got, still
randomly die, and take your data with them. It's not because of number of
writes, but bad firmware and/or a single chip that dies and isn't redundant on
some drives.
 
> Is there any pro/cons currently, on a 3.14 kernel, about using BTRFS along 
> with an SSD ?

It's not foolproof, but works well enough for many. Have backups, but
because of your SSD, you should definitely have backups anyway.

> Is there specific advice about leaf size, use of compression, snapshots, 
> (auto-)defrag etc, that might be relevant especially for SSDs ?

compression: lzo, not zlib (zlib will slow down your SSD)
snapshots:
http://marc.merlins.org/perso/btrfs/2014-03.html#Btrfs-Tips_-How-To-Setup-Netapp-Style-Snapshots
auto-defrag: not really (read the archives)
other options: leave default
add -o discard to mount options

Do not use LVM, it's totally unnecessary and will slow you down. Dmcrypt is
ok, however add discard to cryptsetup options too:
root2		 /dev/sda2		/pwd		luks,discard

legolas:~# grep discard /proc/cmdline 
root=/dev/mapper/cryptroot ro rootflags=subvol=root cryptopts=source=/dev/sda4,keyscript=/sbin/cryptgetpw,discard

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/  
