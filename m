Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:46228 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932707AbaLBVN1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Dec 2014 16:13:27 -0500
Received: by mail-ig0-f182.google.com with SMTP id hn15so11621787igb.3
        for <linux-btrfs@vger.kernel.org>; Tue, 02 Dec 2014 13:13:26 -0800 (PST)
Message-ID: <547E2B71.8050606@gmail.com>
Date: Tue, 02 Dec 2014 16:13:21 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Shriramana Sharma <samjnaa@gmail.com>, dsterba@suse.cz,
        Chris Murphy <lists@colorremedies.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Moving an entire subvol?
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com> <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com> <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com> <20141202132842.GT12140@twin.jikos.cz> <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
In-Reply-To: <CAH-HCWVubkp+viAEVqGoJFxJ_t1chTVC08xm6A15ucosqbWqxQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms070600090605000503010102"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms070600090605000503010102
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-02 10:11, Shriramana Sharma wrote:
> On Tue, Dec 2, 2014 at 6:58 PM, David Sterba <dsterba@suse.cz> wrote:
>>
>> A subvolume is also a snapshotting barrier, so it's convenient to crea=
te
>> subvolumes in well-known paths that contain data that should not be
>> rolled back (/var/log, /srv, bootloader).
>
> Hi David -- a real honour to meet one of the core Btrfs/SuSE (heh,
> when that was the spelling!) guys!
>
> That makes sense. Is there anywhere that the "official" SuSE
> recommended subvol layout is mentioned that I can refer to without
> having to start up an installer? (I currently chose ext4 for / for
> other reasons so I can't refer to my layout.)
>
> I am now reading a SuSECon 2013 presentation by Nyers and Schnell but
> they are very generic about the recommendations.
>
Here's my approach to things:
In the top level of the btrfs filesystem I use for /, I have a subvolume =

called /root,  This is what get's mount on /.  I also have a separate=20
subvolume called /home for the home directories when I have those on the =

same FS.  I place /boot on an entirely separate filesystem because I use =

a bunch of mount options there that would break or slow down other=20
filesystems (most notably, noexec, nosuid, nodev, and sync).  Within=20
both /home and /root, I use a handful of subvolumes to control what gets =

saved in a snapshot, the most notable examples being /var//log,=20
/usr/portage, and /home/austin/dropbox.

As far as snapshots go, I take a snapshot of /root every time I boot,=20
and keep the past 2 days worth, take a snapshot of /home hourly, and=20
keep a weeks worth, and do a snapshot of both when I generate a system=20
backup.  I generally don't do snapshots of /boot, as I keep around the=20
previous few kernel versions anyway, and mark things there as immutable=20
so that I can't accidentally mess them up.


--------------ms070600090605000503010102
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIAGCSqGSIb3DQEHAqCAMIACAQExCzAJBgUrDgMCGgUAMIAGCSqGSIb3DQEHAQAAoIIFuDCC
BbQwggOcoAMCAQICAw9gVDANBgkqhkiG9w0BAQ0FADB5MRAwDgYDVQQKEwdSb290IENBMR4w
HAYDVQQLExVodHRwOi8vd3d3LmNhY2VydC5vcmcxIjAgBgNVBAMTGUNBIENlcnQgU2lnbmlu
ZyBBdXRob3JpdHkxITAfBgkqhkiG9w0BCQEWEnN1cHBvcnRAY2FjZXJ0Lm9yZzAeFw0xNDA4
MDgxMTMwNDRaFw0xNTAyMDQxMTMwNDRaMGMxGDAWBgNVBAMTD0NBY2VydCBXb1QgVXNlcjEj
MCEGCSqGSIb3DQEJARYUYWhmZXJyb2luN0BnbWFpbC5jb20xIjAgBgkqhkiG9w0BCQEWE2Fo
ZW1tZWxnQG9oaW9ndC5jb20wggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQDdmm8R
BM5D6fGiB6rpogPZbLYu6CkU6834rcJepfmxKnLarYUYM593/VGygfaaHAyuc8qLaRA3u1M0
Qp29flqmhv1VDTBZ+zFu6JgHjTDniBii1KOZRo0qV3jC5NvaS8KUM67+eQBjm29LhBWVi3+e
a8jLxmogFXV0NGej+GHIr5zA9qKz2WJOEoGh0EfqZ2MQTmozcGI43/oqIYhRj8fRMkWXLUAF
WsLzPQMpK19hD8fqwlxQWhBV8gsGRG54K5pyaQsjne7m89SF5M8JkNJPH39tHEvfv2Vhf7EM
Y4WGyhLAULSlym1AI1uUHR1FfJaj3AChaEJZli/AdajYsqc7AgMBAAGjggFZMIIBVTAMBgNV
HRMBAf8EAjAAMFYGCWCGSAGG+EIBDQRJFkdUbyBnZXQgeW91ciBvd24gY2VydGlmaWNhdGUg
Zm9yIEZSRUUgaGVhZCBvdmVyIHRvIGh0dHA6Ly93d3cuQ0FjZXJ0Lm9yZzAOBgNVHQ8BAf8E
BAMCA6gwQAYDVR0lBDkwNwYIKwYBBQUHAwQGCCsGAQUFBwMCBgorBgEEAYI3CgMEBgorBgEE
AYI3CgMDBglghkgBhvhCBAEwMgYIKwYBBQUHAQEEJjAkMCIGCCsGAQUFBzABhhZodHRwOi8v
b2NzcC5jYWNlcnQub3JnMDEGA1UdHwQqMCgwJqAkoCKGIGh0dHA6Ly9jcmwuY2FjZXJ0Lm9y
Zy9yZXZva2UuY3JsMDQGA1UdEQQtMCuBFGFoZmVycm9pbjdAZ21haWwuY29tgRNhaGVtbWVs
Z0BvaGlvZ3QuY29tMA0GCSqGSIb3DQEBDQUAA4ICAQCr4klxcZU/PDRBpUtlb+d6JXl2dfto
OUP/6g19dpx6Ekt2pV1eujpIj5whh5KlCSPUgtHZI7BcksLSczQbxNDvRu6LNKqGJGvcp99k
cWL1Z6BsgtvxWKkOmy1vB+2aPfDiQQiMCCLAqXwHiNDZhSkwmGsJ7KHMWgF/dRVDnsl6aOQZ
jAcBMpUZxzA/bv4nY2PylVdqJWp9N7x86TF9sda1zRZiyUwy83eFTDNzefYPtc4MLppcaD4g
Wt8U6T2ffQfCWVzDirhg4WmDH3MybDItjkSB2/+pgGOS4lgtEBMHzAGQqQ+5PojTHRyqu9Jc
O59oIGrTaOtKV9nDeDtzNaQZgygJItJi9GoAl68AmIHxpS1rZUNV6X8ydFrEweFdRTVWhUEL
70Cnx84YBojXv01LYBSZaq18K8cERPLaIrUD2go+2ffjdE9ejvYDhNBllY+ufvRizIjQA1uC
OdktVAN6auQob94kOOsWpoMSrzHHvOvVW/kbokmKzaLtcs9+nJoL+vPi2AyzbaoQASVZYOGW
pE3daA0F5FJfcPZKCwd5wdnmT3dU1IRUxa5vMmgjP20lkfP8tCPtvZv2mmI2Nw5SaXNY4gVu
WQrvkV2in+TnGqgEIwUrLVbx9G6PSYZZs07czhO+Q1iVuKdAwjL/AYK0Us9v50acIzbl5CWw
ZGj3wjGCA6EwggOdAgEBMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6
Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEh
MB8GCSqGSIb3DQEJARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwCQYFKw4DAhoFAKCCAfUw
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjAyMjExMzIx
WjAjBgkqhkiG9w0BCQQxFgQUnTe3uYBACoXd/EhQoamqsWwILlEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEADGShKnUG3JnmpxB14uriuggG9oNS
3nN8mQRBeY+bRHBI/8IUR/PX6OKtN4iEokR5afrvftUtxZkQ03huGFMxXPwvhKMQSC/RQgOY
Iv4t7Uld9IKuiS4NGltVIRxgSEQtfEjue7M+OEnYEGyuiGqv211yNaw1zCNVyuJgcm2I8Gev
NF4afroQVcPoK3ywEAOOcUC7nba0GG4Fn8ZGSdBy9fbTa1lHatafZrgiw/8F4XBJOtWEt/yc
A0Wxa4dK5UtOt2858WJSySQvhKcYK09DNquRFRAJyh6dgUcKFpY15fKnkAZwwZRYa+K+ADF/
qPWfxONnVxqhzvAwXw1y9gx2iwAAAAAAAA==
--------------ms070600090605000503010102--
