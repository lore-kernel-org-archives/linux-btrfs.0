Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:57231 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab3GRPVc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 18 Jul 2013 11:21:32 -0400
Date: Thu, 18 Jul 2013 16:21:28 +0100
From: Hugo Mills <hugo@carfax.org.uk>
To: Sandy McArthur <sandymac@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: bug: corrupt filesystem, cannot delete tmp files created just
 before crash.
Message-ID: <20130718152128.GB20517@carfax.org.uk>
References: <pan$8addd$a853ed60$657c1f02$89661ea8@cox.net>
 <CAPs0Bijykq=HQAz3fnmh053a7iqsC93cbKGjXc9dP4-Z-V3Tiw@mail.gmail.com>
 <CAPs0BihLvfdo2inUyM574tA-DQ2TH2SyvdUaGnuFu=V=SU+Kwg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="hQiwHBbRI9kgIhsi"
In-Reply-To: <CAPs0BihLvfdo2inUyM574tA-DQ2TH2SyvdUaGnuFu=V=SU+Kwg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--hQiwHBbRI9kgIhsi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 18, 2013 at 11:11:03AM -0400, Sandy McArthur wrote:
> Should I interpret the different used amounts (902.01GB vs 902.03GB)
> on my recovered RAID1 filesystem as that not all data is actually
> mirrored and so I should run a balance? The devices in the filesystem
> below are the same make/model drives.
> 
> # btrfs fi show
> Label: 'mcmedia'  uuid: 92b3345e-2589-423c-a228-d569bf94ab58
> Total devices 2 FS bytes used 905.33GB
> devid    2 size 2.73TB used 902.01GB path /dev/sdc1
> devid    1 size 2.73TB used 902.03GB path /dev/sdb1
> 
> Btrfs v0.20-rc1-358-g194aa4a
> 
> # btrfs fi df /mnt/media/
> Data, RAID1: total=894.00GB, used=892.99GB
> Data: total=12.01GB, used=11.56GB

              ^^^^^^^ This is unmirrored data.

# btrfs balance start -dconvert=raid1,soft /mountpoint

is the incantation you need: convert your data to RAID-1, and ignore
anything which has already been converted.

   Hugo.

> System, RAID1: total=8.00MB, used=132.00KB
> System: total=4.00MB, used=0.00
> Metadata, RAID1: total=2.00GB, used=1.13GB
> Metadata: total=8.00MB, used=0.00
> 
> On Thu, Jul 18, 2013 at 10:19 AM, Sandy McArthur <sandymac@gmail.com> wrote:
> > I was able to recover the filesystem using the btrfsck from git (Btrfs
> > v0.20-rc1-358-g194aa4a) .
> >
> > I encourage btrfsck to output a line similar to "Errors found. Run
> > again with --repair to attempt repairs." when errors are found.
> >
> > From using other fsck tools, I expected repairs to be attempted unless
> > I specified for no changes to be attempted. This would have saved me
> > time and the emotional grief of my perceiving that my problems were
> > persisting a btrfsck.
> >
> >
> > On Wed, Jul 17, 2013 at 7:38 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> >> Sandy McArthur posted on Wed, 17 Jul 2013 10:06:05 -0400 as excerpted:
> >>
> >>> have a btrfs filesystem that is corrupt so that I cannot remove a few
> >>> files. Attempting to delete these temp files from before a crash leaves
> >>> the filesystem read-only and sends a trace to the syslog. Assistance
> >>> correcting this issue is most appreciated.
> >>>
> >>> I have two disks /dev/sd{b,c}1 to make up this filesystem.
> >>> I've updated to the latest btrfs-tools and kernel packages available.
> >>> The crash happened with kernel 3.8.13-gentoo.
> >>>
> >>> # btrfs version Btrfs v0.20-rc1
> >>> # [uname -r] 3.10.1-gentoo
> >>
> >> Hi fellow gentooer. =:^)  I'm just a user too so won't attempt a
> >> technical answer.  However...
> >>
> >> I see you've tried the latest packages for both kernel and btrfs-tools.
> >> That's good as otherwise that's one of the the first suggestion you'd
> >> get.  However you don't mention the btrfs wiki, nor do you mention trying
> >> what it suggests in such cases, so I'll assume you're not familiar with
> >> it.  (Additionally, being a wiki and btrfs still being under development,
> >> it's worth checking back every couple months or so, and possibly using
> >> the wiki history function to see what has changed on your pages of
> >> interest since your last visit.)
> >>
> >> Main page (for bookmarking):
> >>
> >> https://btrfs.wiki.kernel.org/index.php/Main_Page
> >>
> >> Of course right at the top there it mentions (in bold) that btrfs is
> >> under heavy development and to run the latest, which you're basically
> >> doing, altho you apparently haven't tried the latest kernel rc or the
> >> btrfs-tools git build (which being a gentooer, I know are available, but
> >> masked by default).  If the following suggestion doesn't help, you might
> >> try them, as fixes really are going in all the time.
> >>
> >> Meanwhile, I recommend reading up on the documentation section of the
> >> wiki.  In particular, altho with the corruption it may not help in your
> >> case, pay attention to the no-space sections of the FAQ and Problem FAQ
> >> pages.  Even more in particular, when there's space problems it
> >> recommends attempting to clobber/truncate a file in place, the idea being
> >> to free up space without having to allocate additional metadata space to
> >> do it.  Again, with corruption it may not help, but it's worth a try.
> >>
> >> echo > /path/to/file
> >>
> >> Of course, even more with a development filesystem than ordinarily, you
> >> should have good backups, so you shouldn't need to worry too much about
> >> finding clobber candidates since you can recover most files from backup
> >> in any case.
> >>
> >> If the echo/clobber doesn't work, try again after mounting with the
> >> nodatacow option.  But read the wiki for the details.
> >>
> >> There's also mount options such as recovery (and skip-balance if you have
> >> an aborted balance it'd otherwise be trying to restart), that you can
> >> try.  Of course if you have the space to do so, it might be worth dd-ing
> >> the filesystem elsewhere as a backup image, in case you screw things up
> >> worse while experimenting.
> >>
> >> Meanwhile, based on my interested-admin most definitely NOT kernel-dev
> >> technical level following of this list at least, there /have/ been recent
> >> no-space, extents maintenance and other cleanups in the really-latest
> >> code (3.11-rc1+ kernel and live-git btrfs-tools, and there may be further
> >> patches posted to the list that haven't actually been committed yet),
> >> that may well help in your case.  I'm not technically qualified to match
> >> backtraces against commits/patches and identify a solid match, but it's
> >> definitely worth a try.
> >>
> >> Finally, as background once you're out of the tight spot, since you're
> >> running a multi-device filesystem, you're likely to find the discussion
> >> of that on the multiple devices, sysadmin guide, and use cases pages
> >> useful.  FWIW, here I'm running most of my btrfs filesystems in dual-
> >> device raid1 (both data/metadata) mode, to take advantage of the
> >> checksumming and extra copy to lookup in case of checksum error, that
> >> btrfs offers, in addition to the device-loss scenario that raid1 helps
> >> protect against.
> >>

-- 
=== Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
  PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
    --- Reintarnation:  Coming back from the dead as a hillbilly. ---    

--hQiwHBbRI9kgIhsi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUBUegH+FheFHXiqx3kAQLasA/+Jv1fMsROXJ12PR55qM+BSRun2bR/khyz
jh5pqvd+EmqWsUX9bm0jR4o/uIWFywBrA8mZxcQXOUiu2J7qFNzL2sY3x6jvbarR
0wfqh4tGhsR1wpRr612to6BdAf8zN/aQOxSI05/tmP2HHvHB986i66aLl3W5Rt6y
aMX/Mg870rRIlPm+mvijBm14++ZcS7I+bB2NktRRBaRUajAkefMU6u/q4cigQLMa
01ymZtKhPoeU4pVvkJoDkKXyrTmnGUi/FY7BjAGE7lzo6e9x27p+jTuqvlHS7MAF
YA7wG9LBq/XALTVfTgqP6/vbIVmAHlwk0MsYbWPjoDiW4ARqEkEn9R4tM6NwQ8MS
sFPKjgCf01uTAPsJcGQRVyw6wqG4MHxYPiKVlNKdIqS2d8dakXYAL5GqB70atscK
PwgAx5cL+Gun22OSbkn3eG+VafIl/BymSght6plK8MlSN1Ma3IOqxt6UKmgCWuz6
EMmxtMc4CcihrEPuPLmd9xoQoFGMJcB/k5Bwa8WyHCbG2KM5eJeHBKNyFlngLpBI
wNVfoh2nedQzIAnWucp4hHrBo2/2PVay0MJg//ggkkFIm388xWfDWb94iksDDjJ0
bwB5W0JTXlF36KXjZcOrt6XHxV42+xcPtfM5PSZF/gGMcUSDf/j4IjYiPLzQ2fnP
OW6K1UKVcSQ=
=uxsS
-----END PGP SIGNATURE-----

--hQiwHBbRI9kgIhsi--
