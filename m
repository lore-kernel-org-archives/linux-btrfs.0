Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:39323 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750885AbaKURpK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Nov 2014 12:45:10 -0500
Date: Fri, 21 Nov 2014 12:42:30 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141121174229.GT17395@hungrycats.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
 <546AF572.2020101@swiftspirit.co.za>
 <20141121045801.GS17395@hungrycats.org>
 <546EE43C.7020900@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAmHCRPXNp23hR9r"
In-Reply-To: <546EE43C.7020900@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--NAmHCRPXNp23hR9r
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 21, 2014 at 09:05:32AM +0200, Brendan Hide wrote:
> On 2014/11/21 06:58, Zygo Blaxell wrote:
> >You have one reallocated sector, so the drive has lost some data at some
> >time in the last 49000(!) hours.  Normally reallocations happen during
> >writes so the data that was "lost" was data you were in the process of
> >overwriting anyway; however, the reallocated sector count could also be
> >a sign of deteriorating drive integrity.
> >
> >In /var/lib/smartmontools there might be a csv file with logged error
> >attribute data that you could use to figure out whether that reallocation
> >was recent.
> >
> >I also notice you are not running regular SMART self-tests (e.g.
> >by smartctl -t long) and the last (and first, and only!) self-test the
> >drive ran was ~12000 hours ago.  That means most of your SMART data is
> >about 18 months old.  The drive won't know about sectors that went bad
> >in the last year and a half unless the host happens to stumble across
> >them during a read.
> >
> >The drive is over five years old in operating hours alone.  It is probab=
ly
> >so fragile now that it will break if you try to move it.
> All interesting points. Do you schedule SMART self-tests on your own
> systems? I have smartd running. In theory it tracks changes and
> sends alerts if it figures a drive is going to fail. But, based on
> what you've indicated, that isn't good enough.

I run 'smartctl -t long' from cron overnight (or whenever the drives
are most idle).  You can also set up smartd.conf to launch the self
tests; however, the syntax for test scheduling is byzantine compared to
cron (and that's saying something!).  On multi-drive systems I schedule
a different drive for each night.

If you are also doing btrfs scrub, then stagger the scheduling so
e.g. smart runs in even weeks and btrfs scrub runs in odd weeks.

smartd is OK for monitoring test logs and email alerts.  I've had no
problems there.

> >WARNING: errors detected during scrubbing, corrected.
> >[snip]
> >scrub device /dev/sdb2 (id 2) done
> >	scrub started at Tue Nov 18 03:22:58 2014 and finished after 2682 secon=
ds
> >	total bytes scrubbed: 189.49GiB with 5420 errors
> >	error details: read=3D5 csum=3D5415
> >	corrected errors: 5420, uncorrectable errors: 0, unverified errors: 164
> >That seems a little off.  If there were 5 read errors, I'd expect the dr=
ive to
> >have errors in the SMART error log.
> >
> >Checksum errors could just as easily be a btrfs bug or a RAM/CPU problem.
> >There have been a number of fixes to csums in btrfs pulled into the kern=
el
> >recently, and I've retired two five-year-old computers this summer due
> >to RAM/CPU failures.
> The difference here is that the issue only affects the one drive.
> This leaves the probable cause at:
> - the drive itself
> - the cable/ports
>=20
> with a negligibly-possible cause at the motherboard chipset.

If it was cable, there should be UDMA CRC errors or similar in the SMART
counters, but they are zero.  You can also try swapping the cable and
seeing whether the errors move.  I've found many bad cables that way.

The drive itself could be failing in some way that prevents recording
SMART errors (e.g. because of host timeouts triggering a bus reset,
which also prevents the SMART counter update for what was going wrong at
the time).  This is unfortunately quite common, especially with drives
configured for non-RAID workloads.

>=20
> --=20
> __________
> Brendan Hide
> http://swiftspirit.co.za/
> http://www.webafrica.co.za/?AFF1E97
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--NAmHCRPXNp23hR9r
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRveXEACgkQgfmLGlazG5xGCgCfRn9F1szdU5fFG7j3MsXwBp5g
/E0AoNBYW+hdX/+IqWX8IEf5yErosMwB
=2cRO
-----END PGP SIGNATURE-----

--NAmHCRPXNp23hR9r--
