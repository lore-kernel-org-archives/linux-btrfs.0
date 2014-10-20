Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f171.google.com ([209.85.213.171]:46860 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaJTNTo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Oct 2014 09:19:44 -0400
Received: by mail-ig0-f171.google.com with SMTP id h15so5251446igd.10
        for <linux-btrfs@vger.kernel.org>; Mon, 20 Oct 2014 06:19:43 -0700 (PDT)
Message-ID: <54450BE8.6000904@gmail.com>
Date: Mon, 20 Oct 2014 09:19:36 -0400
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
MIME-Version: 1.0
To: Zygo Blaxell <zblaxell@furryterror.org>, Duncan <1i5t5.duncan@cox.net>
CC: linux-btrfs@vger.kernel.org
Subject: Re: strange 3.16.3 problem
References: <201410181454.19375.russell@coker.com.au> <pan$9907e$9b197fe7$2a806862$700ddfa7@cox.net> <20141020130243.GB29401@hungrycats.org>
In-Reply-To: <20141020130243.GB29401@hungrycats.org>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha1; boundary="------------ms030001050905040304020704"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms030001050905040304020704
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2014-10-20 09:02, Zygo Blaxell wrote:
> On Mon, Oct 20, 2014 at 04:38:28AM +0000, Duncan wrote:
>> Russell Coker posted on Sat, 18 Oct 2014 14:54:19 +1100 as excerpted:
>>
>>> # find . -name "*546"
>>> ./1412233213.M638209P10546 # ls -l ./1412233213.M638209P10546 ls: can=
not
>>> access ./1412233213.M638209P10546: No such file or directory
>>
>> Does your mail server do a lot of renames?  Is one perhaps stuck?  If =
so,
>> that sounds like the same thing "Zygo Blaxell" is reporting in the
>> "3.16.3..3.17.1 hang in renameat2()" thread, OP on Sun, 19 Oct 2014
>> 15:25:26 -400, Msg-ID: <20141019192525.GA29401@hungrycats.org>, as lin=
ked
>> here:
>>
>> <http://permalink.gmane.org/gmane.comp.file-systems.btrfs/39539>
>>
>> I pointed him at this thread too.  I hadn't seen you mention a hung
>> rename, but the other symptoms sound similar.
>
> Not really.  It looks like Russell having a NFS client-side problem,
> I'm having a server-side one (maybe).  Also, all Russell's system calls=

> seem to be returning promptly, while some of mine are not.  Even if
> there were timeouts, an NFS server timeout gives a different error than=

> 'No such file or directory'.  Finally, the one and only thing I _can_
> do with my bug is 'ls' on the renamed files (for me, the find would get=

> stuck before returning any output).
>
> For Russell's issue...most of the stuff I can think of has been
> tried already.  I didn't see if there was any attempt try to ls the
> file from the NFS server as well as the client side.  If ls is OK on
> the server but not the client, it's an NFS issue (possibly interacting
> with some btrfs-specific quirk); otherwise, it's likely a corrupted
> filesystem (mail servers seem to be unusually good at making these).
>
> Most of the I/O time on mail servers tends to land in the fsync() syste=
m
> call, and some nasty fsync() btrfs bugs were fixed in 3.17 (i.e. after
> 3.16, and not in the 3.16.x stable update for x <=3D 5 (the last one
> I've checked)).  That said, I'm not familiar with how fsync() translate=
s
> over NFS, so it might not be relevant after all.
>
> If the NFS server's view of the filesystem is OK, check the NFS protoco=
l
> version from /proc/mounts on the client.  Sometimes NFS clients will
> get some transient network error during connection and fall back to som=
e
> earlier (and potentially buggier) NFS version.  I've seen very differen=
t
> behavior in some important corner cases from v4 and v3 clients, for
> example, and if the client is falling all the way back to v2 the bugs
> and their workarounds start to get just plain _weird_ (e.g. filenames
> which produce specific values from some hash function or that contain
> specific character sequences are unusable).  v2 is so old it may even
> have issues with 64-bit inode numbers.
>
Just now saw this thread, but IIRC 'No such file or directory' also gets =

returned sometimes when trying to automount a share that can't be=20
enumerated by the client, and also sometimes when there is a stale NFS=20
file handle.


--------------ms030001050905040304020704
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
GAYJKoZIhvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTQxMDIwMTMxOTM2
WjAjBgkqhkiG9w0BCQQxFgQUcsanWytK/qdkrZ3/tLFRyZgeLO0wbAYJKoZIhvcNAQkPMV8w
XTALBglghkgBZQMEASowCwYJYIZIAWUDBAECMAoGCCqGSIb3DQMHMA4GCCqGSIb3DQMCAgIA
gDANBggqhkiG9w0DAgIBQDAHBgUrDgMCBzANBggqhkiG9w0DAgIBKDCBkQYJKwYBBAGCNxAE
MYGDMIGAMHkxEDAOBgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0
Lm9yZzEiMCAGA1UEAxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJ
ARYSc3VwcG9ydEBjYWNlcnQub3JnAgMPYFQwgZMGCyqGSIb3DQEJEAILMYGDoIGAMHkxEDAO
BgNVBAoTB1Jvb3QgQ0ExHjAcBgNVBAsTFWh0dHA6Ly93d3cuY2FjZXJ0Lm9yZzEiMCAGA1UE
AxMZQ0EgQ2VydCBTaWduaW5nIEF1dGhvcml0eTEhMB8GCSqGSIb3DQEJARYSc3VwcG9ydEBj
YWNlcnQub3JnAgMPYFQwDQYJKoZIhvcNAQEBBQAEggEAUI0e9lZVexveyyBD9HfOISSxNylI
YaHeXUPY+rx0Mhz4sGqDpPp9amCa+kFBtOMvvfUAeqcoQt62ivA8G/nBTAer/5wR0CCmjmpC
Pebk4gYt6lTArxT1qQu6ub7zuS3SyYdOKjQ5UVYkPtC7Bksh9v5m/WTncd+sCSwKd/F2dwoW
InIDUB1L04Kc+zecZMUvzVG7XFIOlHnIHSoYbSLkFGJVW0iNup+lNq5HkV56m1NB+7LmGdYX
5RkPI0gLwKglg99JO6OlIa2t/2UtZg3XAYWWaqFl60+6Or27mdRzh73djllfUUbE83MK0ME+
gALb4kc0DNwwH8nb1zRDx//z9wAAAAAAAA==
--------------ms030001050905040304020704--
