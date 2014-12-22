Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:52618 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753976AbaLVOQk (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Dec 2014 09:16:40 -0500
Received: by mail-ig0-f179.google.com with SMTP id r2so4013351igi.6
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Dec 2014 06:16:39 -0800 (PST)
Received: from [191.9.212.191] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by mx.google.com with ESMTPSA id n2sm4910756igp.16.2014.12.22.06.16.37
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 22 Dec 2014 06:16:38 -0800 (PST)
Message-ID: <549827C3.6060009@gmail.com>
Date: Mon, 22 Dec 2014 09:16:35 -0500
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: Oddly slow read performance with near-full largish FS
References: <20141217024228.GA5544@pyropus.ca> <54955624.5040808@pobox.com> <20141221163207.GA18988@pyropus.ca> <54973C65.6070709@pobox.com> <20141221225315.GA19479@pyropus.ca>
In-Reply-To: <20141221225315.GA19479@pyropus.ca>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms010400070205020001000201"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010400070205020001000201
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-12-21 17:53, Charles Cazabon wrote:
> Hi, Robert,
>
> My performance issues with btrfs are more-or-less resolved now -- the
> performance under btrfs still seems quite variable compared to other
> filesystems -- my rsync speed is now varying between 40MB and ~90MB/s, =
with
> occasional intervals where it drops further, down into the 10-20MB/s ra=
nge.
> Still no disk errors or SMART warnings that would indicate that problem=
 is at
> the hardware level.
>
>> Do make sure you are regularly running the long "offline" test.
>
> Ok, I'll do that.
>
>> Otherwise SMART is just going to tell you the disk just died when it d=
ies.
>
> Ya, I'm aware of how limited/useful the SMART diagnostics are.  I'm als=
o
> paranoid enough to be using RAID 6...
>
>> The thing with "movablecore=3D" will not lead to an "out of memory"
>> condition or not, its a question of cache and buffer evictions.
>
> I'm fairly certain memory isn't the issue here.  For what it's worth:
>
> %Cpu(s):  2.1 us, 19.4 sy,  0.0 ni, 78.0 id,  0.2 wa,  0.3 hi,  0.0 si,=
  0.0 st
> KiB Mem:  16469880 total, 16301252 used,   168628 free,      720 buffer=
s
> KiB Swap:  7811068 total,        0 used,  7811068 free, 15146580 cached=

>
> Swappiness I've left at the default of 60, but I'm not seeing swapping =
going
> on regardless.
>
>>> Is this remaining difference (25 vs 100+ MB/s) simply due to btrfs no=
t being
>>> tuned for performance yet
>
> I found the cause of this.  Stupidly enough, there was a bwlimit set up=
 in a
> shell alias for rsync.
>
> So btrfs is not nearly as slow as I was seeing.  It's still slower than=

> reading from an ext4 or XFS filesystem on these disks, but the absolute=
 level
> of read speed seems reasonable enough given that btrfs has not been und=
er
> heavy performance tuning to date.  My only remaining concern would be t=
he
> variability I still see in the read speed.
This actually sounds kind of like the issues I have sometimes on my=20
laptop using btrfs on an SSD, I've mostly resolved them by tuning IO=20
scheduler parameters, as the default IO scheduler (the supposedly=20
Completely Fair Queue, which was obviously named by a mathematician who=20
had never actually run the algorithm) has some pretty brain-dead default =

settings.  The other thing I would suggest looking into regarding the=20
variability is tuning the kernel's write-caching settings, with the=20
defaults you're caching ~1.6G worth of writes before it forces=20
write-back, which is a ridiculous amount;  I've that the highest value=20
that is actually usable is about 256M, and that's only if you are doing=20
mostly bursty IO and not the throughput focused stuff that rsync does,=20
I'd say try setting /proc/sys/vm/dirty_background_bytes to 67108864=20
(64M) and see if that helps things some.


--------------ms010400070205020001000201
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMjIyMTQxNjM1
WjAjBgkqhkiG9w0BCQQxFgQULGyx+0pHJkA7hhzuB0C/uYCrcpEwbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAfnIE6K3GYWBrNuZhK4Z74l8p3mCy
Wxqg1muYFaOIU37dRaKL86MadsH/tZbZXmsQLxNu12tlcY8AhkozjR1JszoER5zeUbt00ijM
CMEbwpIcsC+pm4Y9guOqib97bHpnWIkjB4hA0ZeUwYTCbj6+ylzrQf999BU+a7sWYCsyPJNI
6uUnwnErw26aJbcAQPsaC3FPkfwHX9sIkvu24IPyIItIn9vCgxyv19Xpe2hmmh9miYgXHDkD
rpy416vQyngfBgLPwknP6klncaCrSj7fUly0LljEzb/T3bb8Q9QrpnoyDPIW1OjQeJgfT2OO
J+TeCIFE7LufGNkNs4WCRPuWwAAAAAAAAA==
--------------ms010400070205020001000201--
