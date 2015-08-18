Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f176.google.com ([209.85.213.176]:34591 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292AbbHRP5Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Aug 2015 11:57:16 -0400
Received: by igui7 with SMTP id i7so86167150igu.1
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Aug 2015 08:57:16 -0700 (PDT)
Subject: Re: So, wipe it out and start over or keep debugging?
To: Timothy Normand Miller <theosib@gmail.com>
References: <CAK7bmU88ZfLJmFfMiV=q9RjS+=vAWbniu9w6MUTv_xSG+-hj_g@mail.gmail.com>
 <55D1C8D3.5090501@gmail.com>
 <CAK7bmU_oXstgxwkWY_6tSc90aU-=WKh0TLH+1Xw+ec3YZogzbQ@mail.gmail.com>
 <55D31533.4040409@gmail.com>
 <CAK7bmU8aatLabiTc4gBH5NEgh2ZeE=ufYNb8euieNYebs4JmBg@mail.gmail.com>
 <CAK7bmU8uXvAcqWZbJs_Hv5LxG0R9_+pG-ecj1k8Np2q_+yNK_w@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55D355BA.40500@gmail.com>
Date: Tue, 18 Aug 2015 11:56:42 -0400
MIME-Version: 1.0
In-Reply-To: <CAK7bmU8uXvAcqWZbJs_Hv5LxG0R9_+pG-ecj1k8Np2q_+yNK_w@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms090705020305030406090702"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms090705020305030406090702
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-08-18 11:10, Timothy Normand Miller wrote:
> I ran the following command.  It spent a lot of time creating a
> 1672450048 byte file.  Then it stopped writing to the file and started
> using 100% CPU.  It's currently doing no I/O, and it's been doing that
> for a while now.  Is that supposed to happen?
>
Not normally, I've seen this happen sometimes before for a short period=20
when it hits a group of blocks that don't compress well, but that=20
usually goes away after a few seconds.  I think this is probably a bug.=20
  However, it isn't unusual for a big filesystem to have a really small=20
image produced if it contains mostly big files (btrfs-image just copies=20
the metadata, not the actual file data, so even without compression, it=20
usually will take up less space than the filesystem being imaged).



--------------ms090705020305030406090702
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODE4MTU1NjQyWjBPBgkq
hkiG9w0BCQQxQgRAt0UnMT8lP6noNJfZROD4KTbwmn4hV5vWUuOW5aVXDYLqp/e2C/28zFK6
1djsThHd4XkeoxNXNnKIjn1YBK+bpzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgBBqkS8lD67MyVPn/APjT6TLbMa4Fc7V0/wz0QK8Fz1hRVdldNS
TFjXe1RE8z+gxG/Sc+AzEhgenPw1NUA4NM+4ACXLtWztLWhQ7FzSMy9kSBsx7C0bulzQ1jHN
bZZ7HcIvDeY9Px7TDt//BaetvVPbkzgUnVWahWSEjCqTDj+wnEAuE/e6z5Rebs3L7I3AeYlP
vj06Ygz2NblYmVAE3f+bffYew59C71WtMpVXwc5ugVP+X+NE/ipTXAJ/tPKla9JIt5b9fd37
693x7q3ftCXIlQbF25UXAJ8MHHUQQi/sNQCGaCY9bKJDkXPU7iJeWRwjyfeMKN3l+OJjhbVa
La+HADkr/0AWoAt44F42y/HR1rW0FhbiNCIYalt+urmr76DWLQ1mE0EmzzxuJTJ8dfu3HZGz
JE+3MBhchx8AaAj2FsN6+fcwKGJ6CUoA8YfPgoXoUGRmn0L0FjGHM7Y8q5/FS3rchVmkxGxy
nteuAtwcwr/1IZYLnbD3O4uer28Z50viwzHHzJ9SZgyQuyd1YSk3UXzbn7HLQLCkV0GFu9TL
sRUXG3MQpbcwnl7KwcC9KItPsd4OK+K1yzSGJLGXdqmheElygGWCCxFgR9+2jos8rw09wByz
MIlxYxOjZXwH3AqM3iTwFwqWtyu0yrJZGYeN3jGRIfrJloscNQ9lOVHzmgAAAAAAAA==
--------------ms090705020305030406090702--
