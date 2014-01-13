Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:44850 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754295AbaAMQqP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 13 Jan 2014 11:46:15 -0500
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: RAID 1 with no data on it when accidentally switched HDD
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <pan$137$6980616b$bce212bf$29519e1a@cox.net>
Date: Mon, 13 Jan 2014 09:46:08 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <BD7CFF7E-E75E-40D8-92B5-902C2F523A28@colorremedies.com>
References: <b93a253364541dd18356eaefb64d3168@www.jitmail.de> <EF449A1E-2C53-43BB-883E-98EE848E60CB@colorremedies.com> <pan$137$6980616b$bce212bf$29519e1a@cox.net>
To: Duncan <1i5t5.duncan@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 13, 2014, at 1:18 AM, Duncan <1i5t5.duncan@cox.net> wrote:
> 
> I use GPT partitioning (instead of MBR) for better fault tolerance and 
> flexibility here, too,

Off topic but related to above, you might find it vaguely interesting/annoying in that the current kernel behavior actually makes GPT less reliable than MBR because it face plants if it finds a problem with the primary GPT, rather than use the backup:
https://bugzilla.kernel.org/show_bug.cgi?id=63591


> and it has partition names/labels which can be 
> used in fstab, too.  I use the same label and partlabel scheme, with the 
> filesystem label generally reflecting the partlabel(s) it's created on, 
> however, so it doesn't really matter which I use, except that PARTLABEL= 
> is longer in fstab, so I use the shorter LABEL=, instead.

While considering how to make Btrfs snapshots bootable in a sane manner over on grub-devel@, I'm finding that fstab is almost entirely obsolete and we need a more dynamic approach. Any rootfs snapshot contains a wrong fstab. So it's almost like we need a revamped format that enables some entries to be static and others to be 2nd guessed/dynamically altered, so that the right subvolumes are mounted rather than prior ones.

Chris Murphy

