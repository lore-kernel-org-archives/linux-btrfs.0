Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f176.google.com ([209.85.223.176]:36107 "EHLO
	mail-io0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932072AbbJ0NbI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 27 Oct 2015 09:31:08 -0400
Received: by ioll68 with SMTP id l68so222271307iol.3
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Oct 2015 06:31:08 -0700 (PDT)
Subject: Re: Bad fs performance, IO freezes
To: Henk Slager <hslager@hotmail.com>, "cheater00 ." <cheater00@gmail.com>
References: <CA+9GZUiUNiRJOjwhxZaE06GdfcLQBpWfY5kpkpmLhD6eg_cg4g@mail.gmail.com>
 <562E37F4.9080602@oracle.com>
 <CA+9GZUjnrdA-O24bbY4KGAxcLOk26uohS8cF+Z=vLjOT88-rwQ@mail.gmail.com>
 <CA+9GZUi9jiJ9RBezrh7Xi4_1eBpyeNBdrs+hYxsECaa_a9_csA@mail.gmail.com>
 <CA+9GZUipGeuNuVP2=g2+gbWpJWxbeHVQEcQ5QYfOCWjkv5JDcQ@mail.gmail.com>
 <CA+9GZUhAZRYto0Rm3Edy0j3gFfGZbfWpqunA3vzraxwh-ANORg@mail.gmail.com>
 <CA+9GZUjTt7C4rjSgui3M65S_WEQ3zsLEjw39x=_Ots=N8Jn3eg@mail.gmail.com>
 <562F638B.1040701@gmail.com> <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <562F7C7B.6060408@gmail.com>
Date: Tue, 27 Oct 2015 09:30:35 -0400
MIME-Version: 1.0
In-Reply-To: <BLU436-SMTP2188EE1DBF30D4E50D6F3DA9220@phx.gbl>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms040905060308070402050402"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms040905060308070402050402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-27 09:00, Henk Slager wrote:
> I don't have a lot experience with autodefrag, but as indicated by
> Austin, expect a lot of full rewrites of files that are relatively
> slowly filled up by a torrent client, starting with a sparse file. So
> 1st advice would be to remove this option and run it as crontask at
> particular times.
>
> What SATA-USB bridge is between the harddisk and the PC motherboard ?
I hadn't thought of this, but the specific adapter being used for the=20
disk can have a lot of impact on how it preforms.  I've personally had=20
lots of issues with JMicron chipsets (ranging from latency issues like=20
what you are seeing to sever data corruption), but have found that=20
ASMedia ones tend to be pretty much rock solid reliable and have good=20
performance (although I think they only do USB 3.0 adapters).
> Also what USB host chipset is on the PC motherboard ?
If it's a Intel motherboard, the USB 2.0 ports are probably routed=20
through on-board hubs to the ports provided by whatever Intel calls=20
their equivalent of the south bridge these days, and the USB 3.0 ports=20
are probably a mix of Intel and ASMedia XHCI controllers (ASMedia was=20
one of the first companies to do an inexpensive standalone XHCI chip, so =

they're relatively popular for extra USB 3.0 ports).  FWIW, the first=20
generation of Intel XHCI chips had some issues with older Linux kernels, =

although IIRC those issues were along the lines of a port just=20
disappearing after disconnecting whatever was connected to it.
> Why don't you run 64-bit Ubuntu on this core i7 ?
64 versus 32 bit shouldn't cause anything like this to happen (although, =

if it can be proven that it does, then that is a serious bug that needs=20
to be fixed).  That said, unless you have some desperate need to be=20
running 32-bit only, you should seriously look into updating to a 64-bit =

version, your whole system should run faster, and Ubuntu has really good =

32-bit compatibility in the 64-bit version (which is part of why it's=20
popular as a support target for third party software like Steam).
>
>
> On Tue, Oct 27, 2015 at 12:44 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-10-26 22:00, cheater00 . wrote:
>>>
>>> Hello,
>>> currently my computer freezes every several seconds for half a second=

>>> or so. Using it feels like I'm playing musical chairs with the kernel=
=2E
>>> I have just one download happening on utorrent right now - this is
>>> what the graph looks like:
>>> http://i.imgur.com/LqhMtrJ.png
>>> and every time a new spike happens, a freeze happens just before
>>> that... that's the only time those freezes happen, too.
>>>
>> Do you have the 'autodefrag' mount option enabled?  If it is turned on=
, then
>> that may be the problem.  Most bittorrent clients pre-allocate the spa=
ce for
>> a download, then write each block directly into the location it's supp=
osed
>> to be in the resultant download, which means depending on how it's
>> pre-allocating the space, that you end up with a large number of rando=
mly
>> ordered writes into a single file, which in turn will trigger the auto=
defrag
>> code, which can cause latency spikes when you're also hitting the disk=
 at
>> the same time.



--------------ms040905060308070402050402
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDI3MTMzMDM1WjBPBgkq
hkiG9w0BCQQxQgRAyCFWeChLrHNKUf7uLeH7JoGDkzPREoknnKTdMu31avS7XsyZo83IHh2a
FXiKYk0qx+lO8c/V77dpwI4W9ETx/DBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBp5ES2gQ0MHGqD6Ic90qSfB3ag3v0bQt9f6elqHLwBgZzrBkX4
6/5sBxeIS98Uj4vLUTXG3QuPZEHXNq2efwHsivbmAzR5QI5CUGfxAZB/5CUOnpzr6gxeATDx
xuWdaO2JICs5lJaoVpCc0E4Zk/5siV6TsP5qnCrYs8pfHIyrh6yBWjLUOW8dx2/Q7Nmp6S3H
Ujb12VL0As5JVqT/uThMZQeXb4zpcUX0vUw750boY9YxG9lFGX/z0c0i3mpYme0fEuSlRNge
onUfYwyW/Bs+U8s9NH+NlyaYlFMFCbU0+kRrbD4lEaUvMA4uChd0Sc4uTodLJHsKVNE+RUKD
fR7x8sMP+3szL1nYWmSKmNI3ERU+789bEkFie6ne7X1ohescc1k+i1hRiv6Nv4H8FAn2FsyT
C0HjlssuqzGAsJ/sie/zyEyS0Wafc5EtPkXiZW0lI/dF2YoPJBi4wBTaQYiqSz5KpbVFTUE5
f8aaLq8PZFN0bERhWQv5qOzWDkFW9S5VNlTvHcVrz9W5S+7nIphFatpZRS9QqEuqg/v3PjF4
jkBPqSQiTmB3WTM/zKm9mGtB41VB4XLlHtvWmxM75bYlXMd20UOgLyVtsA8GF+rFGG0JCWGr
KMNTCUFjn5lYmlAJGiJ/vupRgaYBDH63z9onv+sb6LrUQRl7sU2A64y/fQAAAAAAAA==
--------------ms040905060308070402050402--
