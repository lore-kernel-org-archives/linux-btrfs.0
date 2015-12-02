Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:33578 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753431AbbLBOcJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Dec 2015 09:32:09 -0500
Received: by igcmv3 with SMTP id mv3so118675528igc.0
        for <linux-btrfs@vger.kernel.org>; Wed, 02 Dec 2015 06:32:08 -0800 (PST)
Subject: Re: utils version and convert crash
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CA+WRLO_k=jn1=dNPY8Cv-dFkM=Q2ge0tfX3HXVW9v9eGPhnS=Q@mail.gmail.com>
 <pan$29351$45c9e04c$34064b25$8daa651c@cox.net>
 <CA+WRLO_hx3u0wPy_GfguKmmXY4crxrRFx9TvuoLYh-Su0ju8ww@mail.gmail.com>
 <565E0356.9030006@gmail.com>
 <CA+WRLO-VSOH1QUHTXFGzCSUKW=mRoufmUpYG8xRB4N80+rHmjg@mail.gmail.com>
 <CA+WRLO_1bLpve50YkuGD4wDxyO_e=4u9xev8y4XxZT9L01KxDQ@mail.gmail.com>
 <pan$c5c73$162474d7$f06e12fa$496fb5f@cox.net> <565EE329.3050902@gmail.com>
 <pan$85c2b$46f55be$d534ced$bd1aab07@cox.net>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <565F00E0.6040204@gmail.com>
Date: Wed, 2 Dec 2015 09:32:00 -0500
MIME-Version: 1.0
In-Reply-To: <pan$85c2b$46f55be$d534ced$bd1aab07@cox.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020404070701080705030502"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020404070701080705030502
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-12-02 08:45, Duncan wrote:
> Austin S Hemmelgarn posted on Wed, 02 Dec 2015 07:25:13 -0500 as
> excerpted:
>
>> On 2015-12-02 05:01, Duncan wrote:
>
> [on unverified errors returned by scrub]
>>>
>>> Unverified errors are, I believe[1], errors where a metadata block
>>> holding checksums itself has an error, so the blocks its checksums in=

>>> turn covered are not checksum-verified.
>>>
>>> What that means in practice is that once the first metadata block err=
or
>>> has been corrected in a first scrub run, a second scrub run can now
>>> check the blocks that were recorded as unverified errors in the first=

>>> run, potentially finding and hopefully fixing additional errors[.]
>
>>> ---
>>> [1] I'm not a dev and am not absolutely sure of the technical accurac=
y
>>> of this description, but from an admin's viewpoint it seems to be
>>> correct at least in practice, based on the fact that further scrubs a=
s
>>> long as there were unverified errors often did find additional errors=
,
>>> while once the unverified count dropped to zero and the last read
>>> errors were corrected, further scrubs turned up no further errors.
>>>
>> AFAICT from reading the code, that is a correct assessment.  It would =
be
>> kind of nice though if there was some way to tell scrub to recheck up =
to
>> X many times if there are unverified errors...
>
> Yes.  For me as explained it wasn't that big a deal as another scrub wa=
s
> another minute or less, but definitely on terabyte-scale filesystems on=

> spinning rust, where scrubs take hours, having scrub be able to
> automatically track just the corrected errors along with their
> unverifieds, and rescan just those, should only take a matter of a few
> minutes more, while a full rescan of /everything/ would take the same
> number of hours yet again... and again if there's a third scan required=
,
> etc.
>
> I'd say just make it automatic on corrected metadata errors as I can't
> think of a reason people wouldn't want it, given the time it would save=

> over rerunning a full scrub over and over again, but making it an optio=
n
> would be fine with me too.
>
I was thinking an option to do a full re-scrub, but having an automatic=20
reparse of the metadata in a fixed metadata block would be a lot more=20
efficient that what I was thinking :)


--------------ms020404070701080705030502
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMjAyMTQzMjAwWjBPBgkq
hkiG9w0BCQQxQgRA4a6DBebzNTSHGjpVA6UO1RCykvxYnJGIsSn0eK4cb93ap5A1nh/465bI
62gG3DcMIeabgzqrfRDLGUzqVSCSFTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgCUS5CJ7es5KCSdzLZpLZhR/IMW5+I/VlnfVuHHCJ3UebZno7P4
3TXytiAz7F7kriencnNlNKxIUEqfJkZDA5P9PRZ2NyUt7Vfrrh6OmcbOVm3vQdAiE27QM1Bd
ouZGdtkriUZ96+/+eCSOephUb/TivUKw1pVK8MZhwYFe2wX6CDJOGvaAE1SnjVZ4KN6p97Ms
v5ekIgsV6AxCxCAADQlFd6iPAFjZ+WGTDzTUXNQo2Turw2gfcymQJ0NATZnKy+Z6JAOTUkZT
uVs9jy/92O1uh0S5Prz+z+8Wpa0bc7xCZcB8jgGoFK7p96MEod/BEGQvEx70idn8ZjDCBes8
6egzoiC17X8uO5OIL4oMAdC9NHh1cf5iZ9zhjOG1jO0AQusM0h2iFDf5BeujMvr7K8J8nrCt
mW/I07yxhIa3jrxgJ36C4AzRLR8b6nMGQ1TbobMf8ri1FUiOfybrKeFLxUPaY1pA8dLB0mtk
8/cRuOzote8FsC5BlXnP04bO08XDEVPLhA57xOOMllAFd1bLPxx+lrHmzHlrVzhHD7munPqT
yX+uB71jniibCEnh8yCOtPtPoqKuynVM3qJpZTHWMu0bK1XrZO7P/7e0kp5fQjKcYSLoJCts
vAfmJ9cuQKqTF+Dn2xjmVqBjBF3as3LpLs4RLXAU0lQScGR0aB5HsjQPqgAAAAAAAA==
--------------ms020404070701080705030502--
