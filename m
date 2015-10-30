Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35622 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966231AbbJ3LJJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Oct 2015 07:09:09 -0400
Received: by igpw7 with SMTP id w7so8933488igp.0
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Oct 2015 04:09:08 -0700 (PDT)
Subject: Re: RichACLs for BTRFS? (this time complete)
To: Marcel Ritter <ritter.marcel@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <CADurGxxzrqGs9E0HE4hqfk9KAz1o_RNRdeiF3TEVhiSGnzhChA@mail.gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <56334FA7.9000606@gmail.com>
Date: Fri, 30 Oct 2015 07:08:23 -0400
MIME-Version: 1.0
In-Reply-To: <CADurGxxzrqGs9E0HE4hqfk9KAz1o_RNRdeiF3TEVhiSGnzhChA@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms050005090806060405040301"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms050005090806060405040301
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-10-30 05:45, Marcel Ritter wrote:
> Hi btrfs-developers,
>
> I just read about the possible/planned merge of richacl patches into
> linux kernel 4.4.
>
> s. http://lwn.net/Articles/661078/
> s. http://lwn.net/Articles/661357/
>
> Will btrfs support richacls with kernel 4.4?
>
> According to the btrfs wiki, this topic has not been claimed:
>
> https://btrfs.wiki.kernel.org/index.php/Project_ideas#RichACLs_.2F_NFS4=
_ACLS
>
> As we'd like to use btrfs with NFSv4 I'd really like to see richacls on=
 btrfs.
>
> Hope someone can comment on this topic.
>
While I don't think we'll directly support richacls, it shouldn't be=20
hard to integrate, as they're just stored in a couple of xattrs in the=20
'system' prefix.  AFAICT, all that would really be needed is to make=20
sure that things are wired up correctly so that we can differentiate=20
between using POSIX ACL's and richacls (while I don't agree with a=20
number of choices the developers have made with richacls (It should be=20
relatively easy to find the long discussions we've had in the LKML=20
archives), I do agree that these two different models should not be mixed=
).



--------------ms050005090806060405040301
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMDMwMTEwODIzWjBPBgkq
hkiG9w0BCQQxQgRAgNpzSVuMl9TmO+qAC+FrqlP+7E5BWyQTI/+hwbWkAp1485Nh+OCQ48nn
zrmJaF1Lf5Vy3po3nTV0jjst9xDtPTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgAJyKQzc1+2aV8seGJIse5R93x79FzK2JmsZjVogdOnN1cdsS4v
3Mq0mZMJFGLSBO1965cjlxrNRmMRDcauN/5YT6PHnrAucjaPLCUIhbRTByHhxCLnKfm5/mX5
s4sOVVy3WGT3PGtz0yxrWem78aBkhVY5mi76O+jgg9zqipCm/HAZ5ReQwN5PAxODqgZClQoF
bxq7h7i7Xlj1GtOt2OuAghRKyLIUIDbPG2wVTIOTg5fwks+OU9GYA2tY9MldYfEgOOyiO6mf
vrMvjpaCH06XI9B4I1B2mRfssS0jfG+B9IcQna9Cv+rDszWJnkdx24DYIVhmL35R1ou05Gfu
9AOcQsTQpPxjt+LMcqbxv/qj0FBp/Z4Ip9cCml3KUMaLXBE4cFKN9PXZLu/IyHcKm87eR3FU
VWUH8DULYDtIDQBs29KCFi15E6z3PoOHdCpkmQFBE2K0iF+mAJkpFfJG0HV7qOY5l25WIFgN
8M8ppB4qPdPAI1MxrtS1fAcIKAGJA8LNNTjW0uEA96VDD+yV2SSJoLxDhD5fwLJrdMKiQbgd
UzBbtNKuJs9f01vTKzZT3k3E5UL0kLlhQMETcrR2S4cPZ1G7umo/OivRMd2oE6nabnMPIUau
eKBJEAEPnjIoWYNgQH+XOK+q1BBPK+HKybo5WHDjPqSR6rQu1XKXqm2zgwAAAAAAAA==
--------------ms050005090806060405040301--
