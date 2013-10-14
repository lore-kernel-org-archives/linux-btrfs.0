Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:60454 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932227Ab3JNUYA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 16:24:00 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:55388 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VVogJ-0048Ku-QM
	for linux-btrfs@vger.kernel.org; Mon, 14 Oct 2013 14:23:59 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: boot on btrfs, GRUB usage of subvolume set-default breaks boot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <58D806F1-00EB-4B38-982E-0BB4716827CD@colorremedies.com>
Date: Mon, 14 Oct 2013 14:23:58 -0600
Message-Id: <F7E0EEDE-7B2D-43F5-820F-A6B80401F6B8@colorremedies.com>
References: <58D806F1-00EB-4B38-982E-0BB4716827CD@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 14, 2013, at 1:21 PM, Chris Murphy <lists@colorremedies.com> wrote:

> When /boot is on btrfs, and the default subvolume is changed, it makes the system unbootable. The basic configuration is subvolumes: boot, root, home, on one btrfs volume single device. The installer doesn't change the default subvolume, it remains ID 5.
> 
> If I change the default subvolume and reboot, I get a grub rescue prompt. This means core.img in the MBR gap was found, but /boot/grub/i386-pc/normal.mod could not be found. What's interesting is, at the grub rescue prompt, 'set' returns:
> 
> prefix=(hd0,msdos1)/boot/grub2
> root=hd0,msdos1
> 
> This appears to be a full path name, so it should always start from top level regardless of the set-default subvolume, correct? Yet it's behaving relative to the default subvolume. If I use 'ls (hd0,msdos1)' I'm returned the contents of the subvolume I've set as default, which explains why bootability is broken.

Looks like what I'm experiencing is unintended. If a developer or someone more knowledgable than me can respond to the questions on grub-devel@ it would be very helpful so this can get fixed.

http://lists.gnu.org/archive/html/grub-devel/2013-10/msg00038.html


Chris Murphy