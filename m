Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57342 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbbJOHff (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 03:35:35 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zmd4S-0003Nd-M3
	for linux-btrfs@vger.kernel.org; Thu, 15 Oct 2015 09:35:28 +0200
Received: from coffee.modeemi.fi ([130.230.72.140])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:35:28 +0200
Received: from flux-btrfs by coffee.modeemi.fi with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:35:28 +0200
To: linux-btrfs@vger.kernel.org
From: Erkki Seppala <flux-btrfs@inside.org>
Subject: Re: BTRFS raid 5/6 status
Date: Thu, 15 Oct 2015 10:35:18 +0300
Message-ID: <m494mhsd1op.fsf@coffee.modeemi.fi>
References: <CA+LE0jzBX8kN1NmQ-+8zUpxrB79oMEmpmzUGABYfeA_tX47jBA@mail.gmail.com>
	<20151015102502.5d0b4353@natsu>
	<CA+LE0jwfoa5eQf4O-zrr2VX+cOJtrDxQEGD-1fWkoXxXhc0ndA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

audio muze <audiomuze@gmail.com> writes:

> It seems to me that the simplest option at present is probably to use
> each disk separately, formatted btrfs, and backed up to other drives.
> The data to be stored on these drives is largely static - video and
> audio library.

In that case this might be applicaple to your use case:

  http://www.snapraid.it/

It's a tool to generate (and recover files based on) redundancy data
from n filesystems to m filesystems.

I haven't personally tried it, though, but it sounds like it could fit
that particular use case extraordinarily well, limiting data loss even
in the most extreme situations only to the devices actually lost.

Maybe someone can then use unionfs on top of that.. :)

-- 
  _____________________________________________________________________
     / __// /__ ____  __               http://www.modeemi.fi/~flux/\   \
    / /_ / // // /\ \/ /                                            \  /
   /_/  /_/ \___/ /_/\_\@modeemi.fi                                  \/

