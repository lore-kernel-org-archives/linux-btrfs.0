Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f173.google.com ([209.85.213.173]:38900 "EHLO
	mail-ig0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750891AbbJ2UBt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 16:01:49 -0400
Received: by igbdj2 with SMTP id dj2so38672546igb.1
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 13:01:49 -0700 (PDT)
Subject: Re: Bad fs performance, IO freezes
To: "cheater00 ." <cheater00@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
 <562F7C7B.6060408@gmail.com>
 <CA+9GZUg3LxLqdqUATHVyLMsDYkH1FfvawtGZgKAv46qNsuZ-xQ@mail.gmail.com>
 <CA+9GZUioamT+urUtZRvyv-hkurDpqH8A_f-L9ge9nUsq_tL=8w@mail.gmail.com>
 <CA+9GZUhXfVyJd9CKb2RSms4g6YQUue+z7N54+=SKUmzrwqg4xw@mail.gmail.com>
 <CA+9GZUhtS9Y-711VSaS1-ie92x9FtZFHw5WZ5__+YgbGneU9kA@mail.gmail.com>
 <562F97B5.8000108@gmail.com>
 <CA+9GZUhKmH9x_D6r=P8p=E4H38t+jcUQd1bFeVeE_uj1GyTA8A@mail.gmail.com>
 <56322679.8050001@gmail.com>
 <CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
Cc: Liu Bo <bo.li.liu@oracle.com>, Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56327B01.7010002@gmail.com>
Date: Thu, 29 Oct 2015 16:01:05 -0400
MIME-Version: 1.0
In-Reply-To: <CA+9GZUgf3RxzuY2zjqggDsObBO9se1NMiSxFvM9VX3cLC7AfvQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050303050408040402030305"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050303050408040402030305
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-29 11:49, cheater00 . wrote:
> Hi Austin,
> seek times are fine, but this literally freezes my computer for a
> split second. I've had to re-type this email twice because the freezes
> meant letters I typed would not arrive on the screen.
> USB disks are so common they should not be having issues.
That's debatable.  USB is commonly used because it's almost impossible=20
to find a system that doesn't have it, not because it's reliable.  The=20
original intent was for it to be used for stuff like mice and keyboards, =

so it was designed with low-latency and fair scheduling in mind, both of =

which really hurt performance of bulk data storage devices.
> I have 4.3.0-040300rc7-generic #201510260712 which is just three days o=
ld.
That should be perfectly recent enough, although FWIW, the official=20
version of 4.3 should be out this Sunday.
>
> Please advise. Isn't it better to *not* use a vm to debug this?
That depends.  For something like this, it could go either way.  I just=20
use a VM because that's what I always use, because it's nice not=20
crashing your system when trying to debug a kernel panic.
> BTW, if we are talking about slow speed making things worse, I could
> try downgrading the cable to usb2.
> Is there a standard virtualbox VM that I could use?
In general, it's pretty easy to set something like Ubuntu up in=20
VirtualBox, the install is essentially identical to regular hardware=20
aside from the initial setup of the VM itself.  The documentation for=20
VirtualBox is really good, if you've never used virtualization before,=20
it's definitely worth reading.
> I'll download Gentoo in the meantime. I have never used it. I'm
> getting the "minimal installation cd" from 29th september.
> http://distfiles.gentoo.org/releases/x86/autobuilds/20150929/install-x8=
6-minimal-20150929.iso
I meant by no means that you needed to use Gentoo, I only mentioned it=20
because it's what I use (which in turn is because that's what I use on=20
just about everything except stuff like the Raspberry Pi or the=20
BeagleBoard).  If you just want to debug this and then be done with it,=20
I would actually advise against using Gentoo, it takes a lot of effort=20
to get a system up and running with it, and it's very involved to=20
maintain compared to Ubuntu.  On the other hand though, if you are=20
willing to learn to use it, it's one of the most highly customizable=20
Linux distros out there, and can have noticeably better performance than =

more generic distros (FWIW, it's also one of the last big distros that=20
doesn't force systemd on it's users by default).


--------------ms050303050408040402030305
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI5MjAwMTA1WjBPBgkq
hkiG9w0BCQQxQgRAHM7ECLhoEHGMi7ARf4ByY79A+yx3YxQ9gY6u4NUdrNtzwwdMaQSwoGXO
eMGjT7AxddPi6I6UQw2gAKWeXwaLSDBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgB04jysWnJU5ziHNImh+Q7ZmMpk6NQFHmaVWMlq0O7IIMwJYrOf
OEsZJTRWMh3GMywex4TW+aiGyIvYVM64sszRonrxXrCNdI8OCFR4Pktu1ZGmv4QZhM+ii/nL
ZwgnO7LluMbFNbpSjFzQ6P91jk+A5nd+gHNlSS/VezS/V3OnRnlFCCpGuS3vVKh1BqI8BUs7
Y7+8W9S9PRGIQE2WGFffk0Ds8HKFw4FwNy+Bk7xMVe6dGelAFDKOem4CxWJbjz+3uVGh9+CZ
VyoMQiFlB3GVbOhVlEivSSs1GjL4ElUIEDQwBNxfzDF2I57Yaar8vvhSbfiDd5e64cbS8/wO
tedjpp7oWbOGQcgV85fSucPjTeARilN5jSkGxxb/pmM6vxDBzZsricJBQIPy9pEk/j6yDc3B
zzM8TJ0vlvqRO3lqNq4ogLDvRgWZGC44IrcfcAKJCsFxw5C01cvQg8EOBvok75bsHoF0YLGh
sNymlWo04Z8z9l89jj7V6zwok0RIfL0Sxiomw9UhJwf8OrNderRhy8hJX7seyRMVtx4kotN/
Ts7lUSkdtPC+3p/Yy8W33JoH0or8t+9SR4eM1eey2KoAY6R3oDFUspwpb9AzyDcJVamF+74T
ZVvemmEDySHrFLxQnIQB1mZBw0tgRmqiyTLxvvWbZZnoD8xyzPu/zeNb3gAAAAAAAA==
--------------ms050303050408040402030305--
