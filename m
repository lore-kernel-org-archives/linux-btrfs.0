Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:39529 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932250Ab3JNU3b (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 14 Oct 2013 16:29:31 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id A2F237C0697
	for <linux-btrfs@vger.kernel.org>; Mon, 14 Oct 2013 14:29:30 -0600 (MDT)
Date: Mon, 14 Oct 2013 16:29:28 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Chris Murphy <lists@colorremedies.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: boot on btrfs, GRUB usage of subvolume set-default breaks boot
Message-ID: <20131014202928.GB14323@localhost.localdomain>
References: <58D806F1-00EB-4B38-982E-0BB4716827CD@colorremedies.com>
 <F7E0EEDE-7B2D-43F5-820F-A6B80401F6B8@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <F7E0EEDE-7B2D-43F5-820F-A6B80401F6B8@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 14, 2013 at 02:23:58PM -0600, Chris Murphy wrote:
> 
> On Oct 14, 2013, at 1:21 PM, Chris Murphy <lists@colorremedies.com> wrote:
> 
> > When /boot is on btrfs, and the default subvolume is changed, it makes the system unbootable. The basic configuration is subvolumes: boot, root, home, on one btrfs volume single device. The installer doesn't change the default subvolume, it remains ID 5.
> > 
> > If I change the default subvolume and reboot, I get a grub rescue prompt. This means core.img in the MBR gap was found, but /boot/grub/i386-pc/normal.mod could not be found. What's interesting is, at the grub rescue prompt, 'set' returns:
> > 
> > prefix=(hd0,msdos1)/boot/grub2
> > root=hd0,msdos1
> > 
> > This appears to be a full path name, so it should always start from top level regardless of the set-default subvolume, correct? Yet it's behaving relative to the default subvolume. If I use 'ls (hd0,msdos1)' I'm returned the contents of the subvolume I've set as default, which explains why bootability is broken.
> 
> Looks like what I'm experiencing is unintended. If a developer or someone more knowledgable than me can respond to the questions on grub-devel@ it would be very helpful so this can get fixed.
> 
> http://lists.gnu.org/archive/html/grub-devel/2013-10/msg00038.html
> 

All grub has to do is read the "default" dir item in the tree_root and then get
the location out of that dir item and then use that root as the default root.
The kernel does it's own path walk to that root just for dentry sake, but I
imagine grub doesn't have to do that, they can just say "ok this is our root"
and carry on.  Thanks,

Josef
