Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:51800 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935082AbcIXVpC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 24 Sep 2016 17:45:02 -0400
Date: Sat, 24 Sep 2016 23:44:54 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Christoph Anton Mitterer <calestyo@scientia.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Does data checksumming remain for files with No_COW file
 attribute?
Message-ID: <20160924214454.GA25183@angband.pl>
References: <767591474719974@web21o.yandex.ru>
 <20160924174012.51d44caa@natsu>
 <1474740566.7196.4.camel@scientia.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1474740566.7196.4.camel@scientia.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Sep 24, 2016 at 08:09:26PM +0200, Christoph Anton Mitterer wrote:
> On Sat, 2016-09-24 at 17:40 +0500, Roman Mamedov wrote:
> > Yes. IIRC the reasoning was that it's more difficult to track checksums
> > of data which is being overwritten in-place (as opposed to CoW).
> AFAIU it wouldn't be more difficult, since the meta-data itself is
> still subject to CoW...
> 
> There's just no guarantee in the case of a crash, that checksum and
> data match (which is IMO however a small price to pay - especially as
> the data is in that case and without CoW anyway not guaranteed to be
> valid - compared to all sorts of other silent corruptions against which
> checksums protect... not to talk about the ability to actually repair
> files in case of RAID inconsistencies.

This would require teaching btrfs that, in some cases, a csum mismatch is no
big thing and it can legitimately return junk data (like most other
filesystems) rather than complaining.  Same for scrub and btrfs check.
For now, there's a nice simple rule: bad csum is bad.

> > You can't apply chattr +C to any files of non-zero length, so by
> > definition there won't be any pre-existing checksummed extents in that
> > file.
> 
> Speaking of which,... can't one modify chattr properly so that it gives
> an error message and $? != 0 in that case?

chattr has no knowledge of btrfs whatsoever, and has no filesystem-specific
code.  It comes from e2fsprogs and from its internal naming of flags, I see
it believes everything to be ext* -- but it doesn't actually have anything
specific to ext*, either.

Thus, any other filesystem can make use of +C (FS_NOCOW_FL), and there's no
reason the "+C doesn't work on non-empty files" rule needs to hold on btrfs
in the future.


Meow!
-- 
An imaginary friend squared is a real enemy.
