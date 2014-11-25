Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:57086 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaKYTpd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 14:45:33 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1XtM3H-000856-20
	for linux-btrfs@vger.kernel.org; Tue, 25 Nov 2014 20:45:31 +0100
Received: from 55e9f25a.rev.dansknet.dk ([85.233.242.90])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 20:45:31 +0100
Received: from spam by 55e9f25a.rev.dansknet.dk with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 20:45:31 +0100
To: linux-btrfs@vger.kernel.org
From: Bardur Arantsson <spam@scientician.net>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Date: Tue, 25 Nov 2014 20:45:18 +0100
Message-ID: <m52m8e$fvf$1@ger.gmane.org>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141125164717.GK26471@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20141125164717.GK26471@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-11-25 17:47, David Sterba wrote:
> On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
>> On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
>>> This brings a strong-but-slow checksum algorithm, sha256.
>>>
>>> Actually btrfs used sha256 at the early time, but then moved to 
>>> crc32c for
>>> performance purposes.
>>>
>>> As crc32c is sort of weak due to its hash collision issue, we need a 
>>> stronger
>>> algorithm as an alternative.
>>>
>>> Users can choose sha256 from mkfs.btrfs via
>>>
>>> $ mkfs.btrfs -C 256 /device
>>
>> Agree with others about -C 256...-C sha256 is only three letters more ;)
>>
>> What's the target for this mode?  Are we trying to find evil people 
>> scribbling on the drive, or are we trying to find bad hardware?
> 
> We could provide an interface for external applications that would make
> use of the strong checksums. Eg. external dedup, integrity db. The
> benefit here is that the checksum is always up to date, so there's no
> need to compute the checksums again. At the obvious cost.

Yes, pleease!

Regards,


