Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34317 "EHLO
	mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbbJTN76 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 09:59:58 -0400
Received: by iow1 with SMTP id 1so22729230iow.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Oct 2015 06:59:57 -0700 (PDT)
Subject: Re: Expected behavior of bad sectors on one drive in a RAID1
To: Russell Coker <russell@coker.com.au>
References: <CA+X5Wn6Wu3RfX6rM6fpp9b4ZQQNm5WCbSOzxyOnE=+jDb0xDoA@mail.gmail.com>
 <201510201545.50705.russell@coker.com.au> <56263B0B.4050502@gmail.com>
 <201510210015.54337.russell@coker.com.au>
Cc: james harvey <jamespharvey20@gmail.com>, linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562648B5.2020401@gmail.com>
Date: Tue, 20 Oct 2015 09:59:17 -0400
MIME-Version: 1.0
In-Reply-To: <201510210015.54337.russell@coker.com.au>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040200070107050606000103"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040200070107050606000103
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-20 09:15, Russell Coker wrote:
> On Wed, 21 Oct 2015 12:00:59 AM Austin S Hemmelgarn wrote:
>>> https://www.gnu.org/software/ddrescue/
>>>
>>> At this stage I would use ddrescue or something similar to copy data =
from
>>> the failing disk to a fresh disk, then do a BTRFS scrub to regenerate=

>>> the missing data.
>>>
>>> I wouldn't remove the disk entirely because then you lose badly if yo=
u
>>> get another failure.  I wouldn't use a BTRFS replace because you alre=
ady
>>> have the system apart and I expect ddrescue could copy the data faste=
r.
>>> Also as the drive has been causing system failures (I'm guessing a
>>> problem with the power connector) you REALLY don't want BTRFS to corr=
upt
>>> data on the other disks.  If you have a system with the failing disk =
and
>>> a new disk attached then there's no risk of further contamination.
>>
>> BIG DISCLAIMER: For the filesystem to be safely mountable it is
>> ABSOLUTELY NECESSARY to remove the old disk after doing a block level
>
> You are correct, my message wasn't clear.
>
> What I meant to say is that doing a "btrfs device remove" or "btrfs rep=
lace"
> is generally a bad idea in such a situation.  "btrfs replace" is pretty=
 good
> if you are replacing a disk with a larger one or replacing a disk that =
has
> only minor errors (a disk that just gets a few bad sectors is unlikely =
to get
> many more in a hurry).
I kind of figured that was what you meant, I just wanted to make it as=20
clear as possible, because this is something that has bitten me in the=20
past.  It's worth noting though that there is an option for 'btrfs=20
replace' to avoid reading from the device being replaced if at all=20
possible.  I've used that option myself a couple of times when=20
re-provisioning my systems, and it works well (although I used it to=20
just control what disks were getting IO sent to them, not because any of =

the were bad).
>
>> copy of it.  By all means, keep the disk around, but do not keep it
>> visible to the kernel after doing a block level copy of it.  Also, you=

>> will probably have to run 'btrfs device scan' after copying the disk a=
nd
>> removing it for the filesystem to work right.  This is an inherent
>> result of how BTRFS's multi-device functionality works, and also appli=
es
>> to doing stuff like LVM snapshots of BTRFS filesystems.
>
> Good advice.  I recommend just rebooting the system.  I think that if a=
nyone
> who has the background knowledge to do such things without rebooting wi=
ll
> probably just do it without needing to ask us for advice.
Normally I would agree, but given the boot issues that were mentioned=20
WRT the system in question, it may be safer to just use 'btrfs dev scan' =

without rebooting (unless of course the system doesn't properly support=20
SATA hot-plug/hot-remove).
>
>>>> Question 2 - Before having ran the scrub, booting off the raid with
>>>> bad sectors, would btrfs "on the fly" recognize it was getting bad
>>>> sector data with the checksum being off, and checking the other
>>>> drives?  Or, is it expected that I could get a bad sector read in a
>>>> critical piece of operating system and/or kernel, which could be
>>>> causing my lockup issues?
>>>
>>> Unless you have disabled CoW then BTRFS will not return bad data.
>>
>> It is worth clarifying also that:
>> a. While BTRFS will not return bad data in this case, it also won't
>> automatically repair the corruption.
>
> Really?  If so I think that's a bug in BTRFS.  When mounted rw I think =
that
> every time corruption is discovered it should be automatically fixed.
That's debatable.  While it is safer to try and do this with BTRFS than=20
say with MD-RAID, it's still not something many seasoned system=20
administrators would want happening behind their back.  It's worth=20
noting that ZFS does not automatically fix errors, it just reports them=20
and works around them, and many distributed storage options (like Ceph=20
for example) behave like this also.  All that the checksum mismatch=20
really tells you is that at some point, the data got corrupted, it could =

be that the copy on the disk is bad, but it could also be caused by bad=20
RAM, a bad storage controller, a loose cable, or even a bad power supply.=

>
>> b. In the unlikely event that both copies are bad, trying to read the
>> data will return an IO error.
>> c. It is theoretically possible (although statistically impossible) th=
at
>> the block could become corrupted, but the checksum could still be
>> correct (CRC32c is good at detecting small errors, but it's not hard t=
o
>> generate a hash collision for any arbitrary value, so if a large porti=
on
>> of the block goes bad, then it can theoretically still have a valid
>> checksum).
>
> It would be interesting to see some research into how CRC32 fits with t=
he more
> common disk errors.  For a disk to return bad data and claim it to be g=
ood the
> data must either be a misplaced write or read (which is almost certain =
to be
> caught by BTRFS as the metadata won't match), or a random sector that m=
atches
> the disk's CRC.  Is generating a hash collision for a CRC32 inside a CR=
C
> protected block much more difficult?
In general, most disk errors will be just a few flipped bits.  For a=20
single bit flip in a data stream, a CRC is 100% guaranteed to change,=20
the same goes for any odd number of bit flips in the data stream.  For=20
an even number of bit flips however, the chance that there will be a=20
collision is proportionate to the size of the CRC, and for 32-bits it's=20
a statistical impossibility that there will be a collision due to two=20
bits flipping without there being some malicious intent involved.  Once=20
you get to larger numbers of bit flips and bigger blocks of data, it=20
becomes more likely.  The chances of a collision with a 4k block with=20
any random set of bit flips is astronomically small, and it's only=20
marginally larger with 16k blocks (which are the default right now for=20
BTRFS).
>
>>>> Question 3 - Probably doesn't matter, but how can I see which files
>>>> (or metadata to files) the 40 current bad sectors are in?  (On extX,=

>>>> I'd use tune2fs and debugfs to be able to see this information.)
>>>
>>> Read all the files in the system and syslog will report it.  But real=
ly
>>> don't do that until after you have copied the disk.
>>
>> It may also be possible to use some of the debug tools from BTRFS to d=
o
>> this without hitting the disks so hard, but it will likely take a lot
>> more effort.
>
> I don't think that you can do that without hitting the disks hard.
Ah, you're right, I forgot that there's no way on most hard disks to get =

the LBA's of the reallocated sectors, which would be required to use the =

debug tools to get the files.
>
> That said last time I checked (last time an executive of a hard drive
> manufacturer was willing to talk to me) drives were apparently designed=
 to
> perform any sequence of operations for their warranty period.  So for a=
 disk
> that is believed to be good this shouldn't be a problem.  For a disk th=
at is
> known to be dying it would be a really bad idea to do anything other th=
an copy
> the data off at maximum speed.
Well yes, but the less stress you put on something, the longer it's=20
likely to last.  And if you actually care about the data, you should=20
have backups (or some other way of trivially reproducing it)



--------------ms040200070107050606000103
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDIwMTM1OTE3WjBPBgkq
hkiG9w0BCQQxQgRA5jd5LrRWcZ2vfubO8VWjZPLjppKypXlzFA54JXIMvNIgRhUMvBw6PnDb
lfQFHBNejqFP8bA0ESxNkNZbFCPp0jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAoLqEBCWCZf98O5bU8Qb/i50dlhW/tqftCAC4s/rCR0u70mvnq
nlznKtQ5FGdgTYGBzPBrC8q5IkrqP9lckfS4iWsOa1CaXPucSAqdyPuwEDEhrpO7jnrTjiKV
LNFsBVFQtXC2xZa2tu6fPTpESHe66fIEGrInmh7X7Mc5QTS0JVmfFW/buiKjJI5ScBbRaIYB
g3joN39s53LUbwfQbDJ2XoXDrqtW5pSNqUiVFg0aYzXKmn7OlRkNr9kfL0keacOMz5Mv6r/G
82mBC4CSKsz1JakNCnkKoYdPBMxqhBi2eYw6RHXKxYXdecdnTUfG1jNYa3GR4/70oIMIJE49
AbAl73I8M0FtXi18v0K90IfkgBKnbcqEsvu/Zmt/jwcxNwKe3gegHvtnjSqMyCm28qr8zkfQ
0ZSQ35krr4us8Jsi/r2r6zyrYnP6SXDo0iSuOhzUkl4OV80LvX/tWUG6mcA2/LJwax0pBHvN
2zhu4A8Y2XZmnWLidGcmNuJlYvCUF9StPKmsk1kL+7zlOsmfLy21TSlC5Nf/BfBc/sqM0D/L
iYETPBXRXbnctf5hudu6IK+VuITE4uk4YTcCqinw3DlbHPjsTaR0YeW/Z+V0g2LKFMSx5QxE
1mb6CQY5cCr1J+DKaVhCPwdqINf1qplKcHFSvob3/53yOB2Gt5v3IYbtygAAAAAAAA==
--------------ms040200070107050606000103--
