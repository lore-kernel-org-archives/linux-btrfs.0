Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:33510 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758497AbbJ3PE3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 11:04:29 -0400
Received: by iodd200 with SMTP id d200so82318213iod.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 08:04:28 -0700 (PDT)
Subject: Re: corrupted RAID1: unsuccessful recovery / help needed
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <562DC606.3070602@lukas-pirl.de>
 <pan$deb9e$70dd599$c247d7fb$410817e7@cox.net>
 <5632930D.4040000@lukas-pirl.de>
 <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <563386BD.8060707@gmail.com>
Date: Fri, 30 Oct 2015 11:03:25 -0400
MIME-Version: 1.0
In-Reply-To: <pan$2c57b$16ebecd2$7cec1c09$cc5ded39@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000309040800060409090807"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000309040800060409090807
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-30 06:58, Duncan wrote:
> Lukas Pirl posted on Fri, 30 Oct 2015 10:43:41 +1300 as excerpted:
>
>> If there is one subvolume that contains all other (read only) snapshot=
s
>> and there is insufficient storage to copy them all separately:
>> Is there an elegant way to preserve those when moving the data across
>> disks?
>
> AFAIK, no elegant way without a writable mount.
>
> Tho I'm not sure, btrfs send, to a btrfs elsewhere using receive, may
> work, since you did specify read-only snapshots, which is what send
> normally works with in ordered to avoid changes to the snapshot while
> it's sending it.  My own use-case doesn't involve either snapshots or
> send/receive, however, so I'm not sure if send can work with a read-onl=
y
> filesystem or not, but I think its normal method of operation is to
> create those read-only snapshots itself, which of course would require =
a
> writable filesystem, so I'm guessing it won't work unless you can
> convince it to use the read-only mounts as-is.
Unless something has significantly changed since I last looked, send=20
only works on existing snapshots and doesn't create any directly itself, =

and as such should work fine to send snapshots from a read-only=20
filesystem.  In theory, you could use it to send all the snapshots at=20
once, although that would probably take a long time, so you'll probably=20
have to use a loop like the fragment of shell-script that Hugo suggested =

in his response.  That should result in an (almost) identical level of=20
sharing.
>
> The less elegant way would involve manual deduplication.  Copy one
> snapshot, then another, and dedup what hasn't changed between the two,
> then add a third and dedup again. ...  Depending on the level of dedup
> (file vs block level) and the level of change in your filesystem, this
> should ultimately take about the same level of space as a full backup
> plus a series of incrementals.
If you're using duperemove (which is the only maintained dedupe tool I=20
know of for BTRFS), then this will likely take a long time for any=20
reasonable amount of data, and probably take up more space on the=20
destination drive than it does on the source (while duperemove does=20
block-based deduplication, it uses large chunks by default).
>
> Meanwhile, this does reinforce the point that snapshots don't replace
> full backups, that being the reason I don't use them here, since if the=

> filesystem goes bad, it'll very likely take all the snapshots with it.
FWIW, while I don't use them directly myself as a backup, they are=20
useful when doing a backup to get a guaranteed stable version of the=20
filesystem being backed-up (this is also one of the traditional use=20
cases for LVM snapshots, although those have a lot of different issues=20
to deal with).  For local backups (I also do cloud-storage based remote=20
backups, but local is what matters in this case because it's where I=20
actually use send/receive and snapshots) I use two different methods=20
depending on the amount of storage I have:
1. If I'm relatively limited on local storage (like in my laptop where=20
the secondary internal disk is only 64G), I use a temporary snapshot to=20
generate a SquashFS image of the system, which I then store on the=20
secondary drive.
2. If I have a lot of spare space (like on my desktop where I have 4x=20
1TB HDD's and 2x 128G SSD's), I make a snapshot of the filesystem, then=20
use send/receive to transfer that to a backup filesystem on a separate=20
disk.  I then keep the original snapshot around on the filesystem so I=20
can do incremental send/receive to speed up future backups.
In both cases, I can directly boot my most recent backups if need be,=20
and in the second case, I can actually use it to trivially regenerate=20
the backed-up filesystems (by simply doing a send/receive in the=20
opposite direction).

Beyond providing a stable system-image for backups, the only valid use=20
case for snapshots in my opinion is to provide the equivalent to MS=20
Windows' 'Restore Point' feature (which I'm pretty sure is done=20
currently by RHEL and SLES if they are installed on BTRFS) and possibly=20
'File History' for people who for some reason can't use real VCS or just =

need to store the last few revision (which is itself done by stuff like=20
'snapper').



--------------ms000309040800060409090807
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDMwMTUwMzI1WjBPBgkq
hkiG9w0BCQQxQgRAzPXn4t9sf7kLugk1YUyWGhBb3rb7DUhEcWUv4Qa34h8M9c9+C189OM9S
hvyY6wwBjOre4DK2CiP1CunYreFFGzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCYH5xeiEBDgeNH+yMC8dITNtFgGqSSOavUOHAH0P4TrdZhNRnn
ClH6MlEiOXFEPTwbo9ytIkjMQqKP7HudIorgzFGCDoQ8c+Idt8E9pCez+ln1C4jauB5XJLDm
1dF9oaOsFFCrjA8a0eBvP93yRo+dT9YL1uCcEHKVMNw1y4/zzLttAS7LwKCUeHMwTjTj2F0v
qNq2c8jC2zL3nz8ZMs7b2cttiSEbXIF+6Pr1iMZUFDgDrKWK6xGrldebuFbyyOEz9NIZreTG
7RJSRQcuEGSvrh9yy3AzfFlDlEQbG4d+FL2w4R+ajf5HKnMPbLx/hOOm69ii92p1y5+gHoOj
B6cEpCo9ghDABMxP7ZTU2Jbrogdkr1sb8UYcC1Bxx6Mkh7p9PLazuBbLy9yJjMwPAmjej++S
MZTj/jjOBQFEoHQMMtEK2wWtnLAcgb4Djq03h/PgrhQmu/EO8z9cS6hqhsvlMiklb0YIJmkx
bAziR8iXsyG3FqENczt8o8sKfI/ahDebcOH4p+dYYUfbSufZexubqhR3m7PPrvp3LgzvsmvF
0wPJhOEozAvioLhlE6UptRES2DhfBGyR1cvzzWETdPNI6WldumrbGAupGhndUTX44b7tc/im
oAXMpEE+UlSCdIwzRP4GWElr+MISQLYfYidu82KgyQmvNzhyyFtZlOM94wAAAAAAAA==
--------------ms000309040800060409090807--
