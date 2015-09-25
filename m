Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from frost.carfax.org.uk ([85.119.82.111]:53585 "EHLO
	frost.carfax.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751362AbbIYWnw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 18:43:52 -0400
Date: Fri, 25 Sep 2015 22:43:49 +0000
From: Hugo Mills <hugo@carfax.org.uk>
To: Marcel Bischoff <marcel@herrbischoff.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Too many missing devices, writeable mount is not allowed
Message-ID: <20150925224349.GA30451@carfax.org.uk>
References: <20150925214544.GB4639@herrbischoff.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HcAYCG3uE/tztfnV"
In-Reply-To: <20150925214544.GB4639@herrbischoff.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


--HcAYCG3uE/tztfnV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Sep 25, 2015 at 11:45:44PM +0200, Marcel Bischoff wrote:
> Hello all,
> 
> I have kind of a serious problem with one of my disks.
> 
> The controller of one of my external drives died (WD Studio). The
> disk is alright though. I cracked open the case, got the drive out
> and connected it via a SATA-USB interface.
> 
> Now, mounting the filesystem is not possible. Here's the message:
> 
> $ btrfs fi show
> warning devid 3 not found already
> Label: none  uuid: bd6090df-5179-490e-a5f8-8fbad433657f
>        Total devices 3 FS bytes used 3.02TiB
>        devid    1 size 596.17GiB used 532.03GiB path /dev/sdd
>        devid    2 size 931.51GiB used 867.03GiB path /dev/sde
>        *** Some devices missing
> 
> Yes, I did bundle up three drives with very different sizes with the
> --single option on creating the file system.

   OK, that's entirely possible. Not a problem in itself.

   Now, asuming that the missing device is actually unrecoverable:

   Since you've said it's single, you've lost some large fraction of
the file data on your filesystem, so this isn't going to end well in
any case. I hope you have good backups.

   Was the metadata on the filesystem also single? If so, then I have
no hesitation in declaring this filesystem completely dead. If it was
RAID-1 (or RAID-5 or RAID-6), then the metadata should still be OK,
and you should be able to mount the FS with -o degraded. That will
give you a working (read-only) filesystem where some of the data will
return EIO where the data is missing. ddrescue should help you to
recover partial files for those cases where partial recovery is
acceptable.

   But it might be recoverable, because...

> I have already asked for help on StackExchange but replies have been
> few. Now I thought people on this list, close to btrfs development
> may be able and willing to help. This would be so much appreciated.
> 
> Here's the issue with lots of information and a record of what I/we
> have tried up until now: http://unix.stackexchange.com/questions/231174/btrfs-too-many-missing-devices-writeable-mount-is-not-allowed

   I think Vincent Yu there has the right idea -- there's no
superblock showing up on the device in the place that's expected.
However, your update 3 shows that there is a superblock offset by 1
MiB (1114176-65600 = 1048576 = 1024*1024). So the recovery approach
here would be to construct a block device using an offset of 1 MiB
into /dev/sdc. dmsetup shoudld be able to do this, I think.

   It's been a long time since I used dmsetup in anger, but something
like this may work:

# dmsetup load /dev/sdc --table "256 <N> linear /dev/mapper/sdc_offset 0"

where <N> is the number of sectors of /dev/sdc, less the 256 at the
start. I recommend reading the man page in detail and double-checking
that what I've got there is actually what's needed.

   That will (I think) give you a device /dev/mapper/sdc_offset, which
should then show up in btfs fi show, and allow you to keep using the
FS.

   Hugo.

-- 
Hugo Mills             | If you see something, say nothing and drink to
hugo@... carfax.org.uk | forget
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                 Welcome to Night Vale

--HcAYCG3uE/tztfnV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJWBc4lAAoJEFheFHXiqx3ki60QAIJrTXZn/82EEHnwoADcC1Bu
JMTsKjLZBNZVcgxValpHws804GJt7pBe6Z01bDSrXSe/HAuKpxwvFIhQPjIH6QpY
+03L7FZMIJ3zvoDZPEfUflGd2PDH/QTFEGUXCPFuB28IHUl19+Dny+zxy4qA+nci
DxhHqjZWOIEtr7vjN+nw6ZwR3F4QZPdPz2T512oHSSUBR2t+5+0N4sR4E5I8DBqa
5ngy+trT7qA+Law9hik5KM5mK5cBTBR6m//zhM5ZzfrlImp9H0aaSBpXY+kOEevZ
2lLJUNIFAGrFcV5o8aiqjG/DwRuxBqn9rWHQ8tGoTdXTxREjHodIcMRg5riaT/J7
l8+rWUoG8voxGfspBD5jfrfiy1KO/ZsFmV/wvL4n+vc4vsTL6cBVPvPxK7FTBUcM
XRkdsa4Dge0W5UGKoH1DzCHlep7NgJnciY7zXdsE40Z/Ee7Kisx2y9d9q958HU7H
fEUkIB9VIi9SMLTC1nIVpUlWwSHlycqLe0PG0ZnWYECzfNpoFYvpxF1KRgNY8fyu
ozcHwYCC3pKsyX5YsPRsGVNt27GS8Yr3JjlmevXsxf7hWT0ks6Kbu76dakp+yfLg
m5sfXx6yXKXWtm5L/8Nu6pGOi+h+NBtVxFMIoVCqcWLtwS2ItaNeuEFtAfWfoOMX
dJ6IYvyPNOZBg/fgg25X
=9U7H
-----END PGP SIGNATURE-----

--HcAYCG3uE/tztfnV--
