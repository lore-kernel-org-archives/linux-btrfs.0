Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from james.kirk.hungrycats.org ([174.142.39.145]:34334 "EHLO
	james.kirk.hungrycats.org" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751596AbaKUE6D (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Nov 2014 23:58:03 -0500
Date: Thu, 20 Nov 2014 23:58:01 -0500
From: Zygo Blaxell <zblaxell@furryterror.org>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
Message-ID: <20141121045801.GS17395@hungrycats.org>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
 <546AF572.2020101@swiftspirit.co.za>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FNX2SHge3qdlDajY"
In-Reply-To: <546AF572.2020101@swiftspirit.co.za>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--FNX2SHge3qdlDajY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 18, 2014 at 09:29:54AM +0200, Brendan Hide wrote:
> Hey, guys
>=20
> See further below extracted output from a daily scrub showing csum
> errors on sdb, part of a raid1 btrfs. Looking back, it has been
> getting errors like this for a few days now.
>=20
> The disk is patently unreliable but smartctl's output implies there
> are no issues. Is this somehow standard faire for S.M.A.R.T. output?
>=20
> Here are (I think) the important bits of the smartctl output for
> $(smartctl -a /dev/sdb) (the full results are attached):
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE UPDATED
> WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail
> Always       -       0
>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail
> Always       -       1
>   7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail
> Always       -       440801014
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age
> Always       -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age
> Always       -       0
> 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age
> Offline      -       0
> 202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age
> Always       -       0

You have one reallocated sector, so the drive has lost some data at some
time in the last 49000(!) hours.  Normally reallocations happen during
writes so the data that was "lost" was data you were in the process of
overwriting anyway; however, the reallocated sector count could also be
a sign of deteriorating drive integrity.

In /var/lib/smartmontools there might be a csv file with logged error
attribute data that you could use to figure out whether that reallocation
was recent.

I also notice you are not running regular SMART self-tests (e.g.
by smartctl -t long) and the last (and first, and only!) self-test the
drive ran was ~12000 hours ago.  That means most of your SMART data is
about 18 months old.  The drive won't know about sectors that went bad
in the last year and a half unless the host happens to stumble across
them during a read.

The drive is over five years old in operating hours alone.  It is probably
so fragile now that it will break if you try to move it.


>=20
>=20
> -------- Original Message --------
> Subject: 	Cron <root@watricky> /usr/local/sbin/btrfs-scrub-all
> Date: 	Tue, 18 Nov 2014 04:19:12 +0200
> From: 	(Cron Daemon) <root@watricky>
> To: 	brendan@watricky
>=20
>=20
>=20
> WARNING: errors detected during scrubbing, corrected.
> [snip]
> scrub device /dev/sdb2 (id 2) done
> 	scrub started at Tue Nov 18 03:22:58 2014 and finished after 2682 seconds
> 	total bytes scrubbed: 189.49GiB with 5420 errors
> 	error details: read=3D5 csum=3D5415
> 	corrected errors: 5420, uncorrectable errors: 0, unverified errors: 164

That seems a little off.  If there were 5 read errors, I'd expect the drive=
 to
have errors in the SMART error log.

Checksum errors could just as easily be a btrfs bug or a RAM/CPU problem.
There have been a number of fixes to csums in btrfs pulled into the kernel
recently, and I've retired two five-year-old computers this summer due
to RAM/CPU failures.

> [snip]
>=20

> smartctl 6.3 2014-07-26 r3976 [x86_64-linux-3.17.2-1-ARCH] (local build)
> Copyright (C) 2002-14, Bruce Allen, Christian Franke, www.smartmontools.o=
rg
>=20
> =3D=3D=3D START OF INFORMATION SECTION =3D=3D=3D
> Model Family:     Seagate Barracuda 7200.10
> Device Model:     ST3250410AS
> Serial Number:    6RYF5NP7
> Firmware Version: 4.AAA
> User Capacity:    250,059,350,016 bytes [250 GB]
> Sector Size:      512 bytes logical/physical
> Device is:        In smartctl database [for details use: -P show]
> ATA Version is:   ATA/ATAPI-7 (minor revision not indicated)
> Local Time is:    Tue Nov 18 09:16:03 2014 SAST
> SMART support is: Available - device has SMART capability.
> SMART support is: Enabled
>=20
> =3D=3D=3D START OF READ SMART DATA SECTION =3D=3D=3D
> SMART overall-health self-assessment test result: PASSED
> See vendor-specific Attribute list for marginal Attributes.
>=20
> General SMART Values:
> Offline data collection status:  (0x82)	Offline data collection activity
> 					was completed without error.
> 					Auto Offline Data Collection: Enabled.
> Self-test execution status:      (   0)	The previous self-test routine co=
mpleted
> 					without error or no self-test has ever=20
> 					been run.
> Total time to complete Offline=20
> data collection: 		(  430) seconds.
> Offline data collection
> capabilities: 			 (0x5b) SMART execute Offline immediate.
> 					Auto Offline data collection on/off support.
> 					Suspend Offline collection upon new
> 					command.
> 					Offline surface scan supported.
> 					Self-test supported.
> 					No Conveyance Self-test supported.
> 					Selective Self-test supported.
> SMART capabilities:            (0x0003)	Saves SMART data before entering
> 					power-saving mode.
> 					Supports SMART auto save timer.
> Error logging capability:        (0x01)	Error logging supported.
> 					General Purpose Logging supported.
> Short self-test routine=20
> recommended polling time: 	 (   1) minutes.
> Extended self-test routine
> recommended polling time: 	 (  64) minutes.
> SCT capabilities: 	       (0x0001)	SCT Status supported.
>=20
> SMART Attributes Data Structure revision number: 10
> Vendor Specific SMART Attributes with Thresholds:
> ID# ATTRIBUTE_NAME          FLAG     VALUE WORST THRESH TYPE      UPDATED=
  WHEN_FAILED RAW_VALUE
>   1 Raw_Read_Error_Rate     0x000f   100   253   006    Pre-fail  Always =
      -       0
>   3 Spin_Up_Time            0x0003   099   097   000    Pre-fail  Always =
      -       0
>   4 Start_Stop_Count        0x0032   100   100   020    Old_age   Always =
      -       68
>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always =
      -       1
>   7 Seek_Error_Rate         0x000f   086   060   030    Pre-fail  Always =
      -       440801057
>   9 Power_On_Hours          0x0032   044   044   000    Old_age   Always =
      -       49106
>  10 Spin_Retry_Count        0x0013   100   100   097    Pre-fail  Always =
      -       0
>  12 Power_Cycle_Count       0x0032   100   100   020    Old_age   Always =
      -       89
> 187 Reported_Uncorrect      0x0032   100   100   000    Old_age   Always =
      -       0
> 189 High_Fly_Writes         0x003a   098   098   000    Old_age   Always =
      -       2
> 190 Airflow_Temperature_Cel 0x0022   060   030   045    Old_age   Always =
  In_the_past 40 (Min/Max 23/70 #25)
> 194 Temperature_Celsius     0x0022   040   070   000    Old_age   Always =
      -       40 (0 23 0 0 0)
> 195 Hardware_ECC_Recovered  0x001a   069   055   000    Old_age   Always =
      -       126632051
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always =
      -       0
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age   Offline=
      -       0
> 199 UDMA_CRC_Error_Count    0x003e   200   200   000    Old_age   Always =
      -       0
> 200 Multi_Zone_Error_Rate   0x0000   100   253   000    Old_age   Offline=
      -       0
> 202 Data_Address_Mark_Errs  0x0032   100   253   000    Old_age   Always =
      -       0
>=20
> SMART Error Log Version: 1
> No Errors Logged
>=20
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining  LifeTime(hour=
s)  LBA_of_first_error
> # 1  Extended offline    Completed without error       00%     37598     =
    -
>=20
> SMART Selective self-test log data structure revision number 1
>  SPAN  MIN_LBA  MAX_LBA  CURRENT_TEST_STATUS
>     1        0        0  Not_testing
>     2        0        0  Not_testing
>     3        0        0  Not_testing
>     4        0        0  Not_testing
>     5        0        0  Not_testing
> Selective self-test flags (0x0):
>   After scanning selected spans, do NOT read-scan remainder of disk.
> If Selective self-test is pending on power-up, resume after 0 minute dela=
y.
>=20


--FNX2SHge3qdlDajY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlRuxlkACgkQgfmLGlazG5wyXACfW8mo/nN+GkphJcYe2qilZs8R
HmoAn1MI5d4vfXmSfy+BYlCsN13spN8L
=XhCi
-----END PGP SIGNATURE-----

--FNX2SHge3qdlDajY--
