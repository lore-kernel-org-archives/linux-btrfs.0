Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:54900 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751674AbbKYP0f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Nov 2015 10:26:35 -0500
From: Martin Steigerwald <martin@lichtvoll.de>
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>,
        Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Subject: Re: shall distros run btrfsck on boot?
Date: Wed, 25 Nov 2015 16:26:33 +0100
Message-ID: <1946208.UO3P0Uc3S9@merkaba>
In-Reply-To: <5655AA62.2070901@gmail.com>
References: <1448337754.14125.33.camel@scientia.net> <5654E427.6060708@redhat.com> <5655AA62.2070901@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Mittwoch, 25. November 2015, 07:32:34 CET schrieb Austin S Hemmelgarn:
> On 2015-11-24 17:26, Eric Sandeen wrote:
> > On 11/24/15 2:38 PM, Austin S Hemmelgarn wrote:
> >> if the system was
> >> shut down cleanly, you're fine barring software bugs, but if it
> >> crashed, you should be running a check on the FS.
> > 
> > Um, no...
> > 
> > The *entire point* of having a journaling filesystem is that after a
> > crash or power loss, a journal replay on next mount will bring the
> > metadata into a consistent state.
> 
> OK, first, that was in reference to BTRFS, not ext4, and BTRFS is a COW
> filesystem, not a journaling one, which is an important distinction as
> mentioned by Hugo in his reply.  Second, there are two reasons that you
> should be running a check even of a journaled filesystem when the system
> crashes (this also applies to COW filesystems, and anything else that
> relies on atomicity of write operations for consistency):
> 
> 1. Disks don't atomically write anything bigger than a sector, and may
> not even atomically write the sector itself.  This means that it's
> possible to get a partial write to the journal, which in turn has
> significant potential to put the metadata in an inconsistent state when
> the journal gets replayed (IIRC, ext4 has a journal_checksum mount
> option that is supposed to mitigate this possibility).  This sounds like
> something that shouldn't happen all that often, but on a busy
> filesystem, the probability is exactly proportionate to the size of the
> journal relative to the size of the FS.
> 
> 2. If the system crashed, all code running on it immediately before the
> crash is instantly suspect, and you have no way to know for certain that
> something didn't cause random garbage to be written to the disk.  On top
> of this, hardware is potentially suspect, and when your hardware is
> misbehaving, then all bets as to consistency are immediately off.

In the case of shaky hardware a fsck run can report bogus data, i.e. problems 
where they are none or vice versa. If I suspect defect memory or controller I 
would check the device on different hardware only. Especially on attempts to 
repair any possible issues.


-- 
Martin
