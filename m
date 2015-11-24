Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f182.google.com ([209.85.223.182]:32899 "EHLO
	mail-io0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603AbbKXUWL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 15:22:11 -0500
Received: by iouu10 with SMTP id u10so33039146iou.0
        for <linux-btrfs@vger.kernel.org>; Tue, 24 Nov 2015 12:22:10 -0800 (PST)
Subject: Re: [PATCH v2 1/5] btrfs-progs: introduce framework to check kernel
 supported features
To: Mike Fleetwood <mike.fleetwood@googlemail.com>,
        Anand Jain <anand.jain@oracle.com>
References: <1448283378-10579-1-git-send-email-anand.jain@oracle.com>
 <1448283378-10579-2-git-send-email-anand.jain@oracle.com>
 <CAMU1PDita6iet1xg97RfCDPWuVUaq=dYBO_eM3ZDQtvLRPcHCw@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.cz>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5654C6BF.8010502@gmail.com>
Date: Tue, 24 Nov 2015 15:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <CAMU1PDita6iet1xg97RfCDPWuVUaq=dYBO_eM3ZDQtvLRPcHCw@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms010205080503030000020702"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms010205080503030000020702
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-11-24 09:39, Mike Fleetwood wrote:
> On 23 November 2015 at 12:56, Anand Jain <anand.jain@oracle.com> wrote:=

>> In the newer kernel, supported kernel features can be known from
>>    /sys/fs/btrfs/features
>> however this interface was introduced only after 3.14, and most the
>> incompatible FS features were introduce before 3.14.
>>
>> This patch proposes to maintain kernel version against the feature lis=
t,
>> and so that will be the minimum kernel version needed to use the featu=
re.
>>
>> Further, for features supported later than 3.14 this list can still be=

>> updated, so it serves as a repository which can be displayed for easy
>> reference.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>> v2: Check for condition that what happens when we fail to read kernel
>>      version. Now the code will fail back to use the default as set by=

>>      the progs.
>>
>>   utils.c | 80 +++++++++++++++++++++++++++++++++++++++++++++++++++++++=
+++++-----
>>   utils.h |  1 +
>>   2 files changed, 76 insertions(+), 5 deletions(-)
>>
>> diff --git a/utils.c b/utils.c
>> index b754686..24042e5 100644
>> --- a/utils.c
>> +++ b/utils.c
>> @@ -32,10 +32,12 @@
>>   #include <linux/loop.h>
>>   #include <linux/major.h>
>>   #include <linux/kdev_t.h>
>> +#include <linux/version.h>
>>   #include <limits.h>
>>   #include <blkid/blkid.h>
>>   #include <sys/vfs.h>
>>   #include <sys/statfs.h>
>> +#include <sys/utsname.h>
>>   #include <linux/magic.h>
>>
>>   #include "kerncompat.h"
>> @@ -567,21 +569,28 @@ out:
>>          return ret;
>>   }
>>
>> +/*
>> + * min_ker_ver: update with minimum kernel version at which the featu=
re
>> + * was integrated into the mainline. For the transit period, that is
>> + * feature not yet in mainline but in mailing list and for testing,
>> + * please use "0.0" to indicate the same.
>> + */
>>   static const struct btrfs_fs_feature {
>>          const char *name;
>>          u64 flag;
>>          const char *desc;
>> +       const char *min_ker_ver;
>>   } mkfs_features[] =3D {
>>          { "mixed-bg", BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS,
>> -               "mixed data and metadata block groups" },
>> +               "mixed data and metadata block groups", "2.7.31"},
> I think you mean 2.6.37 here.
> 67377734fd24c3 "Btrfs: add support for mixed data+metadata block groups=
"
This brings up a rather important question:
Should compat-X.Y mean features that were considered usable in that=20
version, or everything that version offered?  I understand wanting=20
consistency with the kernel versions, but we shouldn't be creating=20
filesystems that we know will break on the specified kernel even if it=20
is mountable on it.



--------------ms010205080503030000020702
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUxMTI0MjAyMTE5WjBPBgkq
hkiG9w0BCQQxQgRAQSgyR2yONVJPoa50En2Jg9h2mYralQ3D9OiQAKF+wqqQdqXSQBa43gRs
4tMS1np/Lhz5gdudFFUGBRiPl8s8IjBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBBH/jgnLeP1qa3+SJyatE2oM+UM+R+USDHPZf+B0mckHHGpw1g
3QQQl09cdMOF+qu89kW65PpbXd1TLEskBL77FjnhXbNljp+KU7Iya0lUCm+Mvdegc1kCPuVH
lFxN+GrhCOrKCVQhEuXWXQ7qqQeNLpOfzhb28kMG1hZEBjM1CnKCNReZPxFoAseewqnW4voo
AOcyf4tpnptcDY830bIROJWt+TWUFcLKAVtl/VL5jhdwY+CAO1sL0J8+EF+4YBxMfXf8+54h
2Pkq6WzlRMIpYbH1a5nRlYaV0UP5rw2I3XvoeQWiUZ2bKLoc2wR25U41F+MQ+TBaVb3S0cUm
oV9ibTviRjSp8Y72lRXl2MJ9d4E+0voovngz1e3mPe05YeG0GAJ8Bk9llmy9DPbsb8UUd9OP
PLVOiNt892czB2WKW4UaLLWR7EC54ev2JSPDszkCHivfD/VkOZgAr7O7XhxZBFah3CWfXt8B
cevx8ejGCSTU3jl2yQ+YgMQEods0i81K4V3FdE36KgSSMcsko07E8fxnPqZ9++I0WuoT2imv
Rc38t5njEtuR3vb/cTqUO0D3nYDpbi3wbGdN4VuvngrHOYTyOsHJkrvUZQY1rcGDLEuiO0Py
WdkWYrmJwzBku+QzgG6FwMAEg33oNp4yRyoLcWVUXItDjSA476tMyTnV9wAAAAAAAA==
--------------ms010205080503030000020702--
