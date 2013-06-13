Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:55019 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751483Ab3FMOTt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Jun 2013 10:19:49 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 6D1407C0446
	for <linux-btrfs@vger.kernel.org>; Thu, 13 Jun 2013 08:19:48 -0600 (MDT)
Date: Thu, 13 Jun 2013 10:19:46 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Frederik Himpe <fhimpe@vub.ac.be>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel bug at fs/btrfs/inode.c:906
Message-ID: <20130613141946.GE658@localhost.localdomain>
References: <kp9nbo$tdh$1@ger.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <kp9nbo$tdh$1@ger.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 12, 2013 at 05:51:20AM -0600, Frederik Himpe wrote:
> I just encoutered this btrfs bug. When this happened, I was  compiling
> stuff in a qemu/kvm virtual machine running as guest on this host, so this
> might be related. The guest hard disk image is a qcow2 file which has the
> NO_COW attribute set.
> 
> After this happened, I was unable to unlock my X session, and running reboot
> in a console did not have any effect, so I had to do a hard reset.
> 
> Let me know if you need more info.

Could you pull down my btrfs-progs, run make and then do

./btrfsck /dev/whatever

and see if it says anything?  Please file a bugzilla at bugzilla.kernel.org with
the compoenent set to btrfs so I can make sure I don't lose track of this?
Thanks,

Josef
