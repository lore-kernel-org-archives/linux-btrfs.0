Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:42050 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751392AbcB1Gt3 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 28 Feb 2016 01:49:29 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1aZvAV-0003m8-7l
	for linux-btrfs@vger.kernel.org; Sun, 28 Feb 2016 07:49:27 +0100
Received: from ip98-167-165-199.ph.ph.cox.net ([98.167.165.199])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 07:49:27 +0100
Received: from 1i5t5.duncan by ip98-167-165-199.ph.ph.cox.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sun, 28 Feb 2016 07:49:27 +0100
To: linux-btrfs@vger.kernel.org
From: Duncan <1i5t5.duncan@cox.net>
Subject: Re: btrfs check --repair is clean, but mount fails
Date: Sun, 28 Feb 2016 06:49:21 +0000 (UTC)
Message-ID: <pan$5fdff$39b005f1$778b3960$a3d0b01e@cox.net>
References: <20160227023938.GB5286@merlins.org>
	<20160227024533.GB11954@localhost.localdomain>
	<20160227030304.GC5286@merlins.org> <56D229F8.5080002@oracle.com>
	<20160228005614.GP19699@merlins.org> <56D25104.9020107@oracle.com>
	<20160228030930.GS19699@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN posted on Sat, 27 Feb 2016 19:09:30 -0800 as excerpted:

[line in fstab]
> LABEL=btrfs_space      /var/local/space btrfs subvol=varlocalspace,defaults,compress=lzo,skip_balance,noatime,noexec 0 0

Nothing to do with your issue at hand, but some potentially useful info, FWIW...

The "defaults" mount option in fstab is just that, the defaults, and
doesn't really apply as an option because they /are/ the defaults.  The
only reason for "defaults" as an explicit option to exist is to hold the
options field in the case of no non-default option being there to hold it,
so once there's _any_ non-default option added, "defaults" can be removed,
as the non-default option is now holding the field and the defaults apply
anyway unless overruled by some other option.

Additionally, with any reasonably modern util-linux, the last two fields,
dump and fsck-passno, both default to 0 if not present, so don't need to
be explicitly included if zero, unless of course you want to as a matter of
style, possibly for consistency with other fstab entries where the fields are
needed, perhaps because fsck-passno isn't zero and you need the dump field
of zero as a field-holder to have the non-zero fsck-passno in the correct
field.

Of course neither the two trailing zero fields nor the defaults mount
option do any harm, and you may simply be including them as a matter of
style.  But because the options field in particular can be rather long, as
yours certainly is, knowing that you can skip "defaults" as a mount option
can be quite a useful hint, if you weren't aware of it before.

So FWIW, YMMV, etc, but I thought it might be worth mentioning, for other
readers for whom it might be new and useful info, even if it's "the way
you like it, ****it!" for you. =:^)

FWIW the fstab (5) manpage is the official documentation for it, but it
says effectively what I said above. =:^)

-- 
Duncan - List replies preferred.   No HTML msgs.
"Every nonfree program has a lord, a master --
and if you use the program, he is your master."  Richard Stallman

