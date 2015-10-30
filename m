Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:58530 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758942AbbJ3LZn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 07:25:43 -0400
Date: Fri, 30 Oct 2015 11:25:41 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Duncan <1i5t5.duncan@cox.net>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
Message-ID: <20151030112541.GA21103@carfax.org.uk>
References: <562DC606.3070602@lukas-pirl.de>
 <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
 <5632930D.4040000@lukas-pirl.de>
 <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ReaqsoxgOBHFXBhH"
In-Reply-To: <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--ReaqsoxgOBHFXBhH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Oct 30, 2015 at 10:58:47AM +0000, Duncan wrote:
> Lukas Pirl posted on Fri, 30 Oct 2015 10:43:41 +1300 as excerpted:
> 
> > If there is one subvolume that contains all other (read only) snapshots
> > and there is insufficient storage to copy them all separately:
> > Is there an elegant way to preserve those when moving the data across
> > disks?

   If they're read-only snapshots already, then yes:

sent=
for sub in *; do
   btrfs send $sent $sub | btrfs receive /where/ever
   sent="$sent -c$sub"
done

   That will preserve the shared extents between the subvols on the
receiving FS.

   If they're not read-only, then snapshotting each one again as RO
before sending would be the approach, but if your FS is itself RO,
that's not going to be possible, and you need to look at Duncan's
email.

   Hugo.

> AFAIK, no elegant way without a writable mount.
> 
> Tho I'm not sure, btrfs send, to a btrfs elsewhere using receive, may 
> work, since you did specify read-only snapshots, which is what send 
> normally works with in ordered to avoid changes to the snapshot while 
> it's sending it.  My own use-case doesn't involve either snapshots or 
> send/receive, however, so I'm not sure if send can work with a read-only 
> filesystem or not, but I think its normal method of operation is to 
> create those read-only snapshots itself, which of course would require a 
> writable filesystem, so I'm guessing it won't work unless you can 
> convince it to use the read-only mounts as-is.
> 
> The less elegant way would involve manual deduplication.  Copy one 
> snapshot, then another, and dedup what hasn't changed between the two, 
> then add a third and dedup again. ...  Depending on the level of dedup 
> (file vs block level) and the level of change in your filesystem, this 
> should ultimately take about the same level of space as a full backup 
> plus a series of incrementals.
> 
> 
> Meanwhile, this does reinforce the point that snapshots don't replace 
> full backups, that being the reason I don't use them here, since if the 
> filesystem goes bad, it'll very likely take all the snapshots with it.
> 
> Snapshots do tend to be pretty convenient, arguably /too/ convenient and 
> near-zero-cost to make, as people then tend to just do scheduled 
> snapshots, without thinking about their overhead and maintenance costs on 
> the filesystem, until they already have problems.  I'm not sure if you 
> are a regular list reader and have thus seen my normal spiel on btrfs 
> snapshot scaling and recommended limits to avoid problems or not, so if 
> not, here's a slightly condensed version...
> 
> Btrfs has scaling issues that appear when trying to manage too many 
> snapshots.  These tend to appear first in tools like balance and check, 
> where time to process a filesystem goes up dramatically as the number of 
> snapshots increases, to the point where it can become entirely 
> impractical to manage at all somewhere near the 100k snapshots range, and 
> is already dramatically affecting runtime at 10k snapshots.
> 
> As a result, I recommend keeping per-subvol snapshots to 250-ish, which 
> will allow snapshotting four subvolumes while still keeping total 
> filesystem snapshots to 1000, or eight subvolumes at a filesystem total 
> of 2000 snapshots, levels where the scaling issues should remain well 
> within control.  And 250-ish snapshots per subvolume is actually very 
> reasonable even with half-hour scheduled snapshotting, provided a 
> reasonable scheduled snapshot thinning program is also implemented, 
> cutting say to hourly after six hours, six-hourly after a day, 12 hourly 
> after 2 days, daily after a week, and weekly after four weeks to a 
> quarter (13 weeks).  Out beyond a quarter or two, certainly within a 
> year, longer term backups to other media should be done, and snapshots 
> beyond that can be removed entirely, freeing up the space the old 
> snapshots kept locked down and helping to keep the btrfs healthy and 
> functioning well within its practical scalability limits.
> 
> Because a balance that takes a month to complete because it's dealing 
> with a few hundred k snapshots is in practice (for most people) not 
> worthwhile to do at all, and also in practice, a year or even six months 
> out, are you really going to care about the precise half-hour snapshot, 
> or is the next daily or weekly snapshot going to be just as good, and a 
> whole lot easier to find among a couple hundred snapshots than hundreds 
> of thousands?
> 
> If you have far too many snapshots, perhaps this sort of thinning 
> strategy will as well allow you to copy and dedup only key snapshots, say 
> weekly plus daily for the last week, doing the backup thing manually, as 
> well, modifying the thinning strategy accordingly if necessary to get it 
> to fit.  Tho using the copy and dedup strategy above will still require 
> at least double the full space of a single copy, plus the space necessary 
> for each deduped snapshot copy you keep, since the dedup occurs after the 
> copy.
> 

-- 
Hugo Mills             | Beware geeks bearing GIFs
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |

--ReaqsoxgOBHFXBhH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWM1O1AAoJEFheFHXiqx3krtcQAKo8CeDcW57WeTeRiktPhTE8
Dv7A7dS/3+Ha7ACT1DMOxJvlLWVSii0aYVNc1bf3ALwncH08X4IAUpxsuUfKTkpY
THSd8lOK1xRY0oOWLNDDCyc+o/3bN2pVqmMg+5rlSjBs3i3rmHxGOQL6fGYH5uWa
JJcXZ9LxUad1JQ4ExgjoH3LgH4mdpY85ZKLqvrhbTjSwqBIEQrGDoaXm34GHNrM+
GqkMQDtCYNPb2/UUHPukK+vuFWr45M3Q60XnWZRMRRzMkPyp64W2pYrdvHHtGK3g
3xxf223d6TlKzoDGWAT1hkevhGV/Jg7cP35RFOGTaJpsAg3Z/x73ElCCoNaRdxT+
e1x5loSoLLfi5z1fePUtHfT8MabCCSr5F8TqWbRsGvPFSK5Xkl8kJ8QFr16SBkD6
XYnbIdoRdbvksOJ+4/BXV4+y//eDXd3cOSdjedSZiDJ4HzRS/iRlCW/yh4IUvrs8
osK59q2B4/gzBylJsqaxDQIVZWHN3+5Z80PsbCIDgrYGYqpxWFsAAVU0ZpgSZC8U
6TFeBQyUXA2IPGsVjh9Jh4d+gZp5g8xRwCsRqjoAm6ud564IO4msQ6ekVVs+f4c5
FYBLDDmtDXmcO4G3Ev6HriBJNylWpmXxmjil5q0GYgJEhJ453j6jv+vlXAEf4Pxi
A4si3Aqxsaz32pyhHs77
=90qq
-----END PGP SIGNATURE-----

--ReaqsoxgOBHFXBhH--
