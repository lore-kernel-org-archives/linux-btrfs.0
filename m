Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:32803 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756365AbbIYNqw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Sep 2015 09:46:52 -0400
Received: by iofh134 with SMTP id h134so110802215iof.0
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Sep 2015 06:46:52 -0700 (PDT)
Subject: Re: BTRFS as image store for KVM?
To: Jim Salter <jim@jrs-s.net>, Rich Freeman <r-btrfs@thefreemanclan.net>
References: <55F88ECC.1040604@menke.ac> <55FE0B42.50300@jrs-s.net>
 <CAGfcS_=bst0S8YLsr6y4oGDu7Gy-ox9ow5+_nD4c3zFdj-Y6ug@mail.gmail.com>
 <56054665.1020608@gmail.com> <5605483A.7040103@jrs-s.net>
Cc: Gert Menke <gert@menke.ac>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56055019.4010506@gmail.com>
Date: Fri, 25 Sep 2015 09:46:01 -0400
MIME-Version: 1.0
In-Reply-To: <5605483A.7040103@jrs-s.net>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010006010505030202050806"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010006010505030202050806
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-25 09:12, Jim Salter wrote:
> Pretty much bog-standard, as ZFS goes.  Nothing different than what's
> recommended for any generic ZFS use.
>
> * set blocksize to match hardware blocksize - 4K drives get 4K
> blocksize, 8K drives get 8K blocksize (Samsung SSDs)
> * LZO compression is a win.  But it's not like anything sucks without
> it.  No real impact on performance for most use, + or -. Just saves spa=
ce.
> * > 4GB allocated to the ARC.  General rule of thumb: half the RAM
> belongs to the host (which is mostly ARC), half belongs to the guests.
>
> I strongly prefer pool-of-mirrors topology, but nothing crazy happens i=
f
> you use striped-with-parity instead.  I use to use RAIDZ1 (the rough
> equivalent of RAID5) quite frequently, and there wasn't anything
> amazingly sucky about it; it performed at least as well as you'd expect=

> ext4 on mdraid5 to perform.
>
> ZFS might or might not do a better job of managing fragmentation; I
> really don't know.  I /strongly/ suspect the design difference between
> the kernel's simple FIFO page cache and ZFS' weighted cache makes a
> really, really big difference.
I've been coming to that same conclusion myself over the years.  I would =

really love to see a drop in replacement for Linux's pagecache with=20
better performance (I don't remember for sure, but I seem to remember=20
that the native pagecache isn't straight FIFO), but the likelihood of=20
that actually getting into mainline is slim to none (can you imagine=20
though how fast XFS or ext* would be with a good caching algorithm?).
>
>
>
> On 09/25/2015 09:04 AM, Austin S Hemmelgarn wrote:
>> you really need to give specifics on how you have ZFS set up in that
>> case.
>>
>



--------------ms010006010505030202050806
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTI1MTM0NjAxWjBPBgkq
hkiG9w0BCQQxQgRAVUEfIbyiscw1BiTDndaIC6ltfKPne6KRMjCp9gkAH5kH0o1M7h4IXdCU
/+aJcWHbrj6smZ10maUah5g36W0qTzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBrW1nHdRFOgFCYI03Wx897bM5OBDANqpvy0dX1Y1/F+UzCB8dA
uCd5gYDIpvqo4uyeQVYyWhUY2CbSJxJm+wgNON7bwa4y9QCSjsbYIi81OIFa4XKi1nfNEWfT
LoRFx2NjEP3caxOUjO4YTURc7eX4ayU7wph/EEFqcdpGbCP7WW14oDHTB1/9AUKBEDwn9xsM
y0JnjF1tYJpTv9u1uXrANPsf86B5nsGrRMf69ImfpCpvY8YfQ1LLpheI12YcQP5cAhYw1NGc
NbbXr0STkp/vvkz1s+QXAR1Tex7nLzeMFpHnO7Skyd9yVXqdHQNDioPkaESefocnNHH3CO+a
+Ei2BV1IfvP+DLJZAjbArrEsWY6KHaCfxm4etxsz4905a0+Qzs25J5EDJ8um1lFlw+R6jzb+
aIsTZq2K6+kRo6rNUBu2tEGFSsGkVKi5HoH0YFXheTp/LilZg/ojGpSnJyQggVRJDOAS/MVe
quVSdlYtUHWDrZA+4X/yV2odtcTHIlCv3nrHtO4bFpGM52jA1UmvG9ZzQqV3+uaNzwsS0XsR
K/EHtRC6UmpZgzf5fhhNE/Q5NWWEa47a4uUs9dbfeqLYNQIMPoW8ZIKSw9xLadhlT2TEOcfP
qMtuBK2XA8oDb5bfdV/yVA1V1gql2pIFGUh3AufPbG5qNwXz/VkkfbMmZQAAAAAAAA==
--------------ms010006010505030202050806--
