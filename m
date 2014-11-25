Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:45802 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750964AbaKYQrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 11:47:19 -0500
Date: Tue, 25 Nov 2014 17:47:17 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Mason <clm@fb.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
Message-ID: <20141125164717.GK26471@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
 <1416859665.3019.6@mail.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416859665.3019.6@mail.thefacebook.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 03:07:45PM -0500, Chris Mason wrote:
> On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> > This brings a strong-but-slow checksum algorithm, sha256.
> > 
> > Actually btrfs used sha256 at the early time, but then moved to 
> > crc32c for
> > performance purposes.
> > 
> > As crc32c is sort of weak due to its hash collision issue, we need a 
> > stronger
> > algorithm as an alternative.
> > 
> > Users can choose sha256 from mkfs.btrfs via
> > 
> > $ mkfs.btrfs -C 256 /device
> 
> Agree with others about -C 256...-C sha256 is only three letters more ;)
> 
> What's the target for this mode?  Are we trying to find evil people 
> scribbling on the drive, or are we trying to find bad hardware?

We could provide an interface for external applications that would make
use of the strong checksums. Eg. external dedup, integrity db. The
benefit here is that the checksum is always up to date, so there's no
need to compute the checksums again. At the obvious cost.
