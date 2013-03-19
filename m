Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab3CSJT7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Mar 2013 05:19:59 -0400
Date: Tue, 19 Mar 2013 10:19:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Gareth Pye <gareth@cerberos.id.au>
Cc: Chris Mason <chris.mason@fusionio.com>, Kyle <lists@lolwut.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Impossible or Possible to Securely Erase File on Btrfs?
Message-ID: <20130319091956.GR7229@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <514759B5.5000507@lolwut.org>
 <20130318191815.15073.49770@localhost.localdomain>
 <CA+WRLO_09TLuoJ4QEzudrNxksJUYsktTRqgYX3=GR2O3989oCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+WRLO_09TLuoJ4QEzudrNxksJUYsktTRqgYX3=GR2O3989oCw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 19, 2013 at 09:48:56AM +1100, Gareth Pye wrote:
> Would it make sense for btrfs to support a write zeros to empty space
> erase? I know it would be slow as it would have to write to all the
> free space in the file system but it would be useful.
> 
> It's probably pretty far down the priority list for development though I expect.

I have prototyped this some time ago

http://repo.or.cz/w/linux-2.6/btrfs-unstable.git/commit/55ec5c00022be8f2bbed06b99b5f4be5832a5451

It reuses the trim code that already traverses the free space but calls
blkdev_issue_zeroout instead. The overwrite pattern could be extended to
random data, some posion patterns (like leaf that has 0 items and could
be recognized in the code to catch misdirected writes; similarly for
tree node blocks), or the secure discard.

(I haven't resolved what to do if there's a mixture of HDDs and SSDs,
rewriting the free space has different impact on the underlying
devices.)

The existing FITRIM ioctl structure fstrim_range does not contain any
spare bytes so either we need to go with own ioctl or propose FITRIM_V2.

david
