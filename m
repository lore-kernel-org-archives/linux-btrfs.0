Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f177.google.com ([209.85.223.177]:35678 "EHLO
	mail-io0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177AbbJ2OAr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 29 Oct 2015 10:00:47 -0400
Received: by iofz202 with SMTP id z202so46289568iof.2
        for <linux-btrfs@vger.kernel.org>; Thu, 29 Oct 2015 07:00:46 -0700 (PDT)
Subject: Re: Bad fs performance, IO freezes
To: "cheater00 ." <cheater00@gmail.com>, Liu Bo <bo.li.liu@oracle.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com>
 <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
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
Cc: Henk Slager <hslager@hotmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56322679.8050001@gmail.com>
Date: Thu, 29 Oct 2015 10:00:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+9GZUhKmH9x_D6r=P8p=E4H38t+jcUQd1bFeVeE_uj1GyTA8A@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040005010101000709050908"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040005010101000709050908
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-29 09:03, cheater00 . wrote:
> Hi Liu,
> after talking with Holger I believe turning off COW on this FS will
> work to alleviate this issue. However, even with COW on, btrfs
> shouldn't be making my computer freeze every 5 seconds... especially
> while the disk is written to at mere tens of kilobytes per second.
> It's not even the disk holding the system. I consider this a pretty
> bad bug... should we go on with trying to reproduce a minimum case?
> How would I go about this?

Well, COW can cause some pretty unexpected behavior for some use cases.=20
  If you have a big disk (I think I remember you saying it was larger=20
than 1TB), then COW can cause some pretty significant seek times because =

of how it works.  With the current state of BTRFS, I wouldn't personally =

consider running BTRFS on anything bigger than 256G with a non-zero seek =

time with COW turned on, because large rewrites would have the potential =

to cause horrifically long seek times just for a RMW cycle on a single=20
block, and this is in turn part of why database files and=20
virtual-machine images tend to be pathological use cases for BTRFS.

I do agree that this kind of thing is a bug, but it's not something that =

causes data corruption, which means that it is slightly lower priority=20
as far as most people are concerned.  Reproducing it might be tricky=20
also, because I'd be willing to bet that things get better to the point=20
of it being almost unnoticeable with an internal disk (USB is horrible=20
when it comes to block storage performance, and has all kinds of=20
potential reliability issues).

Normally, when I try to go about reproducing something like this, I use=20
a virtual machine running the most recent stable version of the Linux=20
kernel, usually with a minimalistic Gentoo installation (although a=20
clean install of pretty much any distro works fine).  There are a couple =

of reasons I use such a setup:
1. Using a clean install provides a well defined initial state, making=20
it easier for other people to reproduce any results.
2. Using the most recent stable kernel available (usually) eliminates=20
the chances of old bugs causing issues.
3. Using a VM means that your disk access will be slower, which will=20
visibly accentuate any kind of performance issues.
4. Using a VM also means that it is very easy to safely generate crash=20
dumps and simulate data corruption for testing purposes, and makes it=20
easier to experiment with different parameters (for example, UP versus=20
SMP, or different amounts of RAM).

If you do decide to go this route, my suggestion would be to use=20
VirtualBox unless you have significant experience with some other=20
hypervisor, as it's one of the easiest to learn to use (I usually use=20
Xen or QEMU, but both require significant effort to set up initially,=20
and are decidedly non-trivial to learn), and learning to debug stuff=20
like this is itself not an easy task.


--------------ms040005010101000709050908
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI5MTQwMDI1WjBPBgkq
hkiG9w0BCQQxQgRAiG9wdY1nz4ocZAPSU6n9ZDG8cFtSs3GWbaqW9sX6SN0YE+pYDz4evaN9
wNXcAiZpmh0dblPoP0vP7wrb33nY7TBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBMZsTFFC0YjYVjoIR1noPqQzglF0PdSDkyi98z3nT/Pu5jUK/p
RNQXF8CT0ZczBTthUfvKRBtJ2nX++6qW7GFjOfWXQnVfzrPstBxfh98d6nFWdkCFR+nWS8bS
8rzjjBXHSVgrrAuTSeMNJKNEri9cZZjBEBEa8yu2HSrx/Ezr2ltBru3sur6tZrT4L4NHWh8J
uhuTg7wzLy6ro7B0KPaO/hI8rKeQ/yNASuLcImCTwc7nrbM3WNYEJpqLxknDNj40+itHXnJq
d/1BoRjroeJDiPAUy2UmhUXhdCmxmv3Qgb0zCZ550Pt+J9PhWOk3+ZZsPc4HjUdWJwFni4Rv
LAvODqPM9gfETKa3TQdunz5zFHdUFdY+r3tHEy5MdKTr/aD2okWMbpRpfdI8pjz5OXneC0yG
vlhF2WKcJKxJUlbCuDjvVwg1lf48QA+g+xatguDmnIcxBh3HInUqM+5AXarQtOLrrwxcLt//
pk/QL7QLUSz3rRxZ6p2Zt6T1D+XTb0hnVtNvzLjt5w9Mos4OMuGSc8VEC8ANRHr92TYXb8tW
Qxw3ljV9/L/tTDv1jlKCZF3I/b8Z4Q3VCSeuNa1ytG0J79m8g42q3eDT5F3ws9I4XkN7n7iT
tiej0PtNuKaAWKeJja9W8QMGbv2wY9T2FJBfX313JdFOXrnOWkgV6zUR0gAAAAAAAA==
--------------ms040005010101000709050908--
