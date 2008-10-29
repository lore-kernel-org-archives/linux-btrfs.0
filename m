From: Stephen Hemminger <shemminger@vyatta.com>
Subject: Re: Raid1 with failing drive
Date: Wed, 29 Oct 2008 13:06:02 -0700
Message-ID: <20081029130602.01840b96@extreme>
References: <20081028164851.70f9d92e@extreme>
	<1225307907.6448.284.camel@think.oraclecorp.com>
	<4908C13C.7070607@gentoo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Joe Peterson <lavajoe@gentoo.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4908C13C.7070607@gentoo.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 29 Oct 2008 14:02:04 -0600
Joe Peterson <lavajoe@gentoo.org> wrote:

> Chris Mason wrote:
> > On Tue, 2008-10-28 at 16:48 -0700, Stephen Hemminger wrote:
> >> I have a system with a pair of small/fast but unreliable scsi drives.
> >> I tried setting up a raid1 configuration and using it for builds.
> >> Using 2.6.26.7 and btrfs 0.16.   When using ext3 (no raid) on same partition,
> >> the driver would recalibrate and log something an keep going. But with
> >> btrfs it doesn't recover and takes drive offline. 
> >>
> > 
> > Btrfs doesn't really take drives offline.  In the future we'll notice
> > that a drive is returning all errors, but for now we'll probably just
> > keep beating on it.
> 
> It can also detect when a bad checksum is returned or the drive returns an i/o
> error, right?  Would the "all-zero" test be a heuristic in case neither of those
> happened (but I cannot imagine why the zeros would get by the checksum check)?
> 
> > The IO error handling code in btrfs currently expects it'll be able to
> > find at least one good mirror.  You're probably hitting some bad
> > conditions as it fails to clean up.
> 
> What happens (or rather, will happen) on a regular/non-mirrored btrfs?  Would it
> then return an i/o error to the user and/or mark a block as bad?  In ZFS, the
> state of the volume changes, noting an issue (also happens on a scrub), and the
> user can check this.  What I don't like about ZFS is that the user can clear the
> condition, and then it appears OK again until another scrub.
> 
> 					-Joe

I think my problem was that the meta data was mirrored but not the actual data.
This lead to total meltdown when data got an error.
