Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:8038 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757393Ab3JNU5g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 16:57:36 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: boot on btrfs, GRUB usage of subvolume set-default breaks boot
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <20131014202928.GB14323@localhost.localdomain>
Date: Mon, 14 Oct 2013 14:57:33 -0600
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Message-Id: <1FA5ED88-8555-4252-ACF2-B583666F7EB8@colorremedies.com>
References: <58D806F1-00EB-4B38-982E-0BB4716827CD@colorremedies.com> <F7E0EEDE-7B2D-43F5-820F-A6B80401F6B8@colorremedies.com> <20131014202928.GB14323@localhost.localdomain>
To: Josef Bacik <jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 14, 2013, at 2:29 PM, Josef Bacik <jbacik@fusionio.com> wrote:

> On Mon, Oct 14, 2013 at 02:23:58PM -0600, Chris Murphy wrote:
>> 
>> On Oct 14, 2013, at 1:21 PM, Chris Murphy <lists@colorremedies.com> wrote:
>> 
>>> When /boot is on btrfs, and the default subvolume is changed, it makes the system unbootable. The basic configuration is subvolumes: boot, root, home, on one btrfs volume single device. The installer doesn't change the default subvolume, it remains ID 5.
>>> 
>>> If I change the default subvolume and reboot, I get a grub rescue prompt. This means core.img in the MBR gap was found, but /boot/grub/i386-pc/normal.mod could not be found. What's interesting is, at the grub rescue prompt, 'set' returns:
>>> 
>>> prefix=(hd0,msdos1)/boot/grub2
>>> root=hd0,msdos1
>>> 
>>> This appears to be a full path name, so it should always start from top level regardless of the set-default subvolume, correct? Yet it's behaving relative to the default subvolume. If I use 'ls (hd0,msdos1)' I'm returned the contents of the subvolume I've set as default, which explains why bootability is broken.
>> 
>> Looks like what I'm experiencing is unintended. If a developer or someone more knowledgable than me can respond to the questions on grub-devel@ it would be very helpful so this can get fixed.
>> 
>> http://lists.gnu.org/archive/html/grub-devel/2013-10/msg00038.html
>> 
> 
> All grub has to do is read the "default" dir item in the tree_root and then get
> the location out of that dir item and then use that root as the default root.
> The kernel does it's own path walk to that root just for dentry sake, but I
> imagine grub doesn't have to do that, they can just say "ok this is our root"
> and carry on. 

Thanks. I might be reading the inquiry on grub-devel@ wrong but it seems that's what they're doing now. The idea is that the GRUB prefix path should be immutable, regardless of the user using 'btrfs subvol set-default' to some nested subvolume, so that the system is always bootable.


Chris Murphy