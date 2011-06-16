From: David Nicol <davidnicol@gmail.com>
Subject: Re: btrfs defra
Date: Thu, 16 Jun 2011 08:50:10 -0500
Message-ID: <BANLkTim-gxATkTSgGncJcc_WC4RHvtibWg@mail.gmail.com>
References: <1307976637.2285.15.camel@andromeda> <20110613155420.GA14384@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>, Bernhard Duebi <bernhard@due.bi>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110613155420.GA14384@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

> =C2=A0 Defrag works on individual files, and tries to find a contiguo=
us
> sequence of bytes to write the file's data to. In the process, the
> current implementation will break any CoW duplication -- either withi=
n
> single files (copies with cp --reflink=3Dalways) or files copied via
> snapshotting.


While it's obviously impossible to defrag and maintain deduplicated
partial chunks simultaneously without some kind of compromise (the
ideal form of which is just beyond the reach of this list
participant's obviousness flashlight),  how difficult is it going to
be to modify the current defrag implementation to hip the additional
references to the file to the fact that a contiguous version (of an
individual file) is now available and it's time to update their links
too, after each file with multiple reflinks/snapshots to its current
form has been copied to contiguous space?

Could Bernhard Duebi do it?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
