Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f178.google.com ([209.85.223.178]:34904 "EHLO
	mail-io0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752835AbbKPNfD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 08:35:03 -0500
Received: by ioc74 with SMTP id 74so159224719ioc.2
        for <linux-btrfs@vger.kernel.org>; Mon, 16 Nov 2015 05:35:03 -0800 (PST)
Subject: Re: More memory more jitters?
To: "CHENG Yuk-Pong, Daniel " <j16sdiz@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5649DB83.2080108@gmail.com>
Date: Mon, 16 Nov 2015 08:34:59 -0500
MIME-Version: 1.0
In-Reply-To: <CAOcLnUfVNvRLYdeQG_kTZyXaceaLCez=XsQ8PXwEyaXPeYiMwg@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090009040204030505060604"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090009040204030505060604
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-14 09:11, CHENG Yuk-Pong, Daniel  wrote:
> Hi List,
>
>
> I have read the Gotcha[1] page:
>
>     Files with a lot of random writes can become heavily fragmented
> (10000+ extents) causing trashing on HDDs and excessive multi-second
> spikes of CPU load on systems with an SSD or **large amount a RAM**.
>
> Why could large amount of memory worsen the problem?
>
> If **too much** memory is a problem, is it possible to limit the
> memory btrfs use?
As Duncan already replied, your issue is probably with the kernel's=20
ancient defaults for write-back buffering.  It defaults to waiting for=20
10% of system RAM to be pages that need written to disk before forcing=20
anything to be flushed.  This worked fine when you had systems where=20
256M was a lot of RAM, but is absolutely inane when you get above about=20
4G (the actual point at which it becomes a problem is highly dependent=20
on your storage hardware however).  I find that on most single disk=20
systems with a fast disk, you start to get slowdowns when trying to=20
cache more than about 256M for writeback.
>
> Background info:
>
> I am running a heavy-write database server with 96GB ram. In the worse
> case it cause multi minutes of high cpu loads. Systemd keeping kill
> and restarting services, and old job don't die because they stuck in
> uninterruptable wait... etc.
>
> Tried with nodatacow, but it seems only affect new file. It is not an
> subvolume option either...
This is a known limitation, although NOCOW is still something that=20
should be used for database files.  The trick to get it set on an=20
existing file is to create a new, empty file, set the attribute on that, =

then copy the existing file into the new one, then rename the new one=20
over the old one.



--------------ms090009040204030505060604
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTE2MTMzNDU5WjBPBgkq
hkiG9w0BCQQxQgRA92vvSNOGiGw3qY14ACpjcdJHQjmGy9LSZNyDr1i+wuMe9irwVZ8TxEEh
f+Cz/P3DaljNYM5K3GXGd1ZrHJPA0jBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBIJ8QcTgwKeWHGRvH5yw8+W+JClNAQYzrCW05VsmPO71kvGnzr
H5XTFDG6SV1jPdIPcQ8AeoIoeJdzR2RISZKCRYztV69zNV+Ti8j9ihTC5XensJt1TpbIrQGE
xDz+1U017aoWrZQYeI+22xU3RXstlcFx1Li8TGfknSAev5+9HFBgUvZFMOstWNsBPMoRjDuR
ES61GUKJP+WD1tDBsJ7z3BwH5/jJ+eWcGZL5CmcR3OhpDPY7P6/K3qM97vpG+20Omsv6y+fx
aI8YDSgHcJ6UQKi1OUvtKvFNzYEr2Ou6BcMUlNKCYgfE5SfwifGCb2ZB0+Xt9XJRtnly8nMH
50fH5pDwRwnos9iX61HmlEWDmNLQeCdZQ3K8IWTs4aL6bfqGSAq6I/n1JaRliGbqcBBttN0h
k5VgLlx9dCRya0buMkti6SLLp3KQJzVW4F7NF4FIHX1+nKnlsM4Hr4cT8W1dNauujWgjucHT
M8TTQ65gazEU5f/yPiD6p09cA1X0bpC0zDczJmhbVAWNwGBOOg36Mbxl//zE74XbMhILyUXX
UEhw9LCIa/YP3KakK04gK5QK+M5q9UtlN/kUIVzfptgxHUcvwk16HA0nL/ApIZEsWRoID53E
sox8v8Y5dpcH3TomFv8QD9gnZS3OlbdfkDrSQEa2Nxl1MFK8eovinLNmXgAAAAAAAA==
--------------ms090009040204030505060604--
