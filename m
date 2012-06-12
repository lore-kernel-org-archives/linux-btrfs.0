Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:36386 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753549Ab2FLW6x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 18:58:53 -0400
Date: Wed, 13 Jun 2012 00:58:45 +0200
From: David Sterba <dave@jikos.cz>
To: Santosh Hosamani <Santosh_Hosamani@mindtree.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Bug in btrfs-debug-tree for two  or more devices.
Message-ID: <20120612225845.GK32402@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 12, 2012 at 06:53:00AM +0000, Santosh Hosamani wrote:
> 
> Hi btrfs folks,
>                 I am working on btrfs filesystem on how it manages the free space. And found out btrfs maintain a ctree which manages the physical location of the chunks and stripes of the filesystem.
> Btrfs-debug-tree also gives the information on the chunk tree
> 
> I created btrfs on single device and two device.I have attached the output of both on running btrfs-debug-tree.
> For single device sum of all the length in the chunks will add upto the total used bytes which is expected behavior.
> 
> But for two devices sum of all lengths in the chunks does not add to the total bytes .Am I missing something .
> Also I notice that for the second device the superblock location 0x10000 is not considered as used .
> 
> I would be really grateful if you folks can answer my query.
> 
> I hav run these tests on SLES11-sp2-x86
> Kernel 3.0.13.0.27-default

Your observation about non-excluded superblock is correct and this is a
known bug fixed in following maintenance update of SLES.

If you're using a distribution kernel, please file a bug at the distro
bug tracker (http://bugzilla.novell.com).

The SLES kernel receives regular backports of btrfs fixes and features
from upstream, but keeps the version at 3.0.x which confuses the
upstream community ready to point you to the latest kernel released.


thanks,
david
