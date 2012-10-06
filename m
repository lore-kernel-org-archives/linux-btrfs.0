Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54152 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753119Ab2JFJk2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 6 Oct 2012 05:40:28 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: btrfs send/receive review by vfs folks
Date: Sat, 6 Oct 2012 11:40:26 +0200
Cc: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>,
        Jan Schmidt <list.btrfs@jan-o-sch.net>,
        Alexander Block <ablock84@googlemail.com>
References: <CAB9VWqAcwCTDi=pV03CpuXaG0kCE6bT1+NbJJJUdzuwVdR-e-Q@mail.gmail.com> <50602781.9010009@jan-o-sch.net> <CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com> (sfid-20121004_215441_555726_00843E2C)
In-Reply-To: <CAHf9xvY1TSNa-zY82whUrK6DtnFYiNx1BEF6R1kGQj1HU+wbxA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201210061140.26936.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag, 4. Oktober 2012 schrieb Alex Lyakas:
> Hi Jan,
> as I promised, here is some code for you to look at.
> 
> First I will describe the approach in general.
> 
> # Get rid of the pipe. Instead, user-space passes a buffer and kernel
> fills the specified user-space buffer with commands.
> # When the buffer is full, kernel stops generating commands and
> returns a checkpoint to the user-space.

Can it just fill a second buffer while userspace command handles the first?

> # User-space does whatever it wants with the returned buffer, and then
> calls the kernel again, with a buffer and a checkpoint that was
> returned by the kernel from previous SEND ioctl().
> # Kernel re-arms itself to the specified checkpoint, and fills the
> specified buffer with commands, attaches a new checkpoint and so on.
> # Eventually kernel signals to the user that there are no more
> commands.

Thanks,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
