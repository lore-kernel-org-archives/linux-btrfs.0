Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:33108 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751095AbbJSL44 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Oct 2015 07:56:56 -0400
Received: by igbkq10 with SMTP id kq10so52737232igb.0
        for <linux-btrfs@vger.kernel.org>; Mon, 19 Oct 2015 04:56:56 -0700 (PDT)
Subject: Re: btrfs autodefrag?
To: Erkki Seppala <flux-btrfs@inside.org>, linux-btrfs@vger.kernel.org
References: <56227910.7000208@gmail.com>
 <CAGfcS_kBeqT6bQKJNegjkcFNcEyqNF2ETg_KY64Y-7-2mc+9-g@mail.gmail.com>
 <20151018144015.GV25907@carfax.org.uk> <m49zizfbcsb.fsf@coffee.modeemi.fi>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5624DA83.40200@gmail.com>
Date: Mon, 19 Oct 2015 07:56:51 -0400
MIME-Version: 1.0
In-Reply-To: <m49zizfbcsb.fsf@coffee.modeemi.fi>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms070305010006040405090706"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070305010006040405090706
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-19 02:19, Erkki Seppala wrote:
> Hugo Mills <hugo@carfax.org.uk> writes:
>>     It has to be disabled because if you enable it, there's a race
>> condition: since you're overwriting existing data (rather than CoWing
>> it), you can't update the checksums atomically. So, in the interests
>> of consistency, checksums are disabled.
>
> I suppose this has been suggested before, but couldn't it store both th=
e
> new and the old checksums and be satisfied if either of them match?
Actually, I don't think that's been suggested before, read on however=20
for an explanation of why we don't do that.
>
> The user is probably not happy that a partial write is going to be
> difficult to read from the device due to a checksum error, but there is=

> no promise of recently-overwritten data state with traditional
> filesystems either in case of sudden powerdown, assuming there is no
> data journaling..
And that is exactly the case with how things are now, when something is=20
marked NOCOW, it has essentially zero guarantee of data consistency=20
after a crash.  As things are now though, there is a guarantee that you=20
can still read the file, but using checksums like you suggest would=20
result in it being unreadable most of the time, because it's=20
statistically unlikely that we wrote the _whole_ block (IOW, we can't=20
guarantee without COW that the data was completely written) because:
a. While some disks do atomically write single sectors, most don't, and=20
if the power dies during the disk writing a single sector, there is no=20
certainty exactly what that sector will read back as.
b. Assuming that item a is not an issue, one block in BTRFS is usually=20
multiple sectors on disk, and a majority of disks have volatile write=20
caches, thus it is not unlikely that the power will die during the=20
process of writing the block.
c. In the event that both items a and b are not an issue (for example,=20
you have a storage controller with a non-volatile write cache, have=20
write caching turned off on the disks, and it's a smart enough storage=20
controller that it only removes writes from the cache after they=20
return), then there is still the small but distinct possibility that the =

crash will cause either corruption in the write cache, or some other=20
hardware related issue.



--------------ms070305010006040405090706
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDE5MTE1NjUxWjBPBgkq
hkiG9w0BCQQxQgRAlYoALCmpwACjSJ00cCCnXqeMQefFKgnxdyNAPl2HudE7s6UKj/w5lQX+
EdeqWNEkr2f0vsLVmRISJVJoBDhFpjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAHGLWhh4uI6NU4n/Zr5fW+smFYxmcC7BFzd3lDTqNj4ZNLu5w0
uwFGQmPOERuyxwdGlfsWmlyzUZPpSdXR7nM2ZRpqPpLk7eNVGwXQlcFdjlyQ3qr1kx6uUauo
8bZuyn6JcPnWZcXLgToI9LAgmSRYtkncO6AgRBOBFuuorif/3eOdO8nlFboLVxiaQZZAmZuZ
+4rxQnDX9Y4fd7pciZK5O9NL1ZrIkpixLMGZW1sk7VRsLZOeNkrmd8pMHvabxBvmp+6EbdUN
vc7d0QHmBehJ/Mg8fWW8fah0OwoVcEjBeSZk9lUV3TX4qLgeiKQBH/pPeEzMUU9CXl08XkEM
cZ6P9Se+R2Rnw8Ci/C5mwQsQveoBysrLqPgjqBEtBMdF/SiiIkC0Te+QKeHjHpI/ymUGQE0j
7zsEInrgzUKswEEKLrQ6265AyWfKibiHmC55Rr2c79s3JHhTOekEvlJJKxpmq5eMp1HF2QCI
eJgf0U3XPsSMG8O3yMFgunrMk2PoKMVyvWwHAlf5CJBMXC7cvdT7aZ2HKQMNMLu33X5v0EE5
36t6KmDZrOomFUFLQ6rfPskHPRzxuFdNEjPDrfV9Tuj6a9EYw5BW3XYpFaLXx2pH2kpWxfYi
E0Nfl94GZZBUd4rWMU2Qi4B2DFZ/eVvRmowd0Zhn2JoS1vxaRnh5tPCkywAAAAAAAA==
--------------ms070305010006040405090706--
