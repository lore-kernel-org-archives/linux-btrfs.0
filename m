Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:55933 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751154AbaA3R5k convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Jan 2014 12:57:40 -0500
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: lost with degraded RAID1
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
Date: Thu, 30 Jan 2014 10:57:41 -0700
Cc: linux-btrfs@vger.kernel.org
Message-Id: <7D962F82-BAB8-48E5-8B4D-3CDBFD10D9C5@colorremedies.com>
References: <CABgvyo-rw8To-=8_Kt+j8gXiJyX43oWPrWxhAGWqhpE83oCCAw@mail.gmail.com> <CABgvyo_Tn-u7Lfo4NPeWyiiSFj2ZFG9MM2z3CAD9f3hjfLM44g@mail.gmail.com>
To: =?iso-8859-1?Q?Johan_Kr=F6ckel?= <johan.kroeckel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jan 30, 2014, at 4:53 AM, Johan Kröckel <johan.kroeckel@gmail.com> wrote:
> 
> [As I said, to the best of my (non-dev btrfs user and list regular)
> knowledge, mount -o degraded,rw should work.]
> 
> No, it doesnt.
> Syslog says: "Jan 30 12:44:02 fortknox kernel: [756677.795661] Btrfs:
> too many missing devices, writeable mount is not allowed"

Is this encrypted Btrfs volume used for rootfs? Or is it only for data?  If it's only for data, then make sure the volume (all subvolumes) are umounted, then mount with this:

-o degraded,recovery,skip_balance

Do you still get too many missing devices message?

Vaguely related questions (for everyone) are:

- If this is rootfs, by default grub options mount ro. So when we use rootflags=degraded,recovery that's effectively -o ro,degraded,recovery. Upon fstab being read, rootfs is remounted rw. Does the previous ro,degraded,recovery repair get written to the volume upon fstab remount rw?

This is somewhat important to understand, and whether the grub default of ro mount, and the remount rw switch at fstab time is sufficiently detecting and repairing Btrfs problems (with and without rootflags=recovery).

- Is an online conversion from profile X to profile Y expected to work when the volume is mounted degraded? If it's not expected to work, or isn't a good idea, then maybe balance needs to be disabled on degraded mounts?

Chris Murphy

