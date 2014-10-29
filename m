Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:52115 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S932994AbaJ2QTw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Oct 2014 12:19:52 -0400
Content-Type: text/plain; charset=iso-8859-1
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: Unable to fixup (regular) error in RAID1 fs
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <ebfd8c4b1c8011693ffd3865f75aa052@miceliux.com>
Date: Wed, 29 Oct 2014 10:19:45 -0600
Cc: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
Message-Id: <ADF01B62-FA34-4355-8E54-DEB454C8AB0F@colorremedies.com>
References: <a3d3305c6149a1aa5e2b3f29d76fff93@miceliux.com> <pan$926c2$2d969c3e$ebb0bb58$d02b674@cox.net> <ebfd8c4b1c8011693ffd3865f75aa052@miceliux.com>
To: Juan Orti <juan.orti@miceliux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 29, 2014, at 2:08 AM, Juan Orti <juan.orti@miceliux.com> wrote:

> El 2014-10-29 04:02, Duncan escribió:
>> Juan Orti posted on Tue, 28 Oct 2014 16:54:19 +0100 as excerpted:
>>> [ 3713.086292] BTRFS: unable to fixup (regular) error at logical
>>> 483011874816 on dev /dev/sdb2
>>> [ 3713.092577] BTRFS: checksum error at logical 483011948544 on dev
>>> /dev/sdb2, sector 628793528, root 2500, inode 1436631, offset
>>> 4059963392, length 4096, links 1 (path:
>>> juan/.local/share/gnome-boxes/images/boxes-unknown)
>>> [ 3713.092584] BTRFS: bdev /dev/sdb2 errs: wr 0, rd 0, flush 0, corrupt
>>> 38, gen 0
>>> [ 3713.093035] BTRFS: unable to fixup (regular) error at logical
>>> 483011948544 on dev /dev/sdb2
>>> Why can't it fix the errors? a bad device? smartctl says the disk is ok.
>>> I'm currently running a full scrub to see if it finds more errors. What
>>> should I do?
>> Btrfs raid1, and I see you have it for both data and metadata.
>> During normal operation, when btrfs comes across a block that doesn't
>> match its checksum, it will look to see if there's another copy (which
>> there is with raid1, which has exactly two copies) of that block and will
>> try to use it instead if so.  If the second copy matches the checksum,
>> all is fine and btrfs will in fact attempt to rewrite the bad copy using
>> the good copy, as well as returning the good copy to whatever was
>> reading it.
>> Those corruption errors seem to indicate that it can't find a good
>> copy to update the bad copy with -- both copies ended up bad.  Either
>> that or it found the good copy and returned it to whatever was reading,
>> but couldn't rewrite the bad copy, for some reason.
>> I'm not sure which of those interpretations is correct, but given
>> that you didn't see anything else bad happening, no apps returning
>> errors due to read error, etc, I'd guess the second.  Because
>> otherwise whatever was doing the read should have returned an
>> error.
> 
> When this error happened, I was editing some text files with vi, and it was painfully slow, it took 30 seconds to open a 20 lines file, so something weird was going on. Anyway, no visible user space error could be seen.

Anything in dmesg prior to the previously reported errors?

Either with syslog messages or journalctl, filter by btrfs and see what you get for the past couple of days. And then also find out what ata port the two drives are on and filter by those; usually in the form ataX.00. You could also search for "exception Emask" and see if anything comes up. This would account for either controller or drive hardware error messages.


Chris Murphy

