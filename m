Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:59354 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753586Ab2FLQt7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jun 2012 12:49:59 -0400
Message-ID: <4FD77336.6050800@gmx.net>
Date: Tue, 12 Jun 2012 18:49:58 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Santosh Hosamani <Santosh_Hosamani@mindtree.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Bug in btrfs-debug-tree for two  or more devices.
References: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
In-Reply-To: <24763ECA27C26742BD79B0D67389CD0E071B3067@MTW02MBX05.mindtree.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/12/2012 08:53 AM, Santosh Hosamani wrote:
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

It's definitely not a bug in debug-tree, but just a problem in
interpreting the result. Could you please paste the output of
btrfs-debug-tree -d? This way it is easier to see what's
bothering you :)

> 
> I hav run these tests on SLES11-sp2-x86
> Kernel 3.0.13.0.27-default
> 
> If you want any further clarification I would be wiiling to help you guys on this.
> 
> Thanks,
> Santosh Hosamani
> 
> 
> 
> ________________________________
> 
> http://www.mindtree.com/email/disclaimer.html

