Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:36102 "EHLO
	mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754145AbbIWN5t (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Sep 2015 09:57:49 -0400
Received: by qkcf65 with SMTP id f65so17309835qkc.3
        for <linux-btrfs@vger.kernel.org>; Wed, 23 Sep 2015 06:57:48 -0700 (PDT)
Subject: Re: [PATCH] btrfs: Fix no space bug caused by removing bg
To: dsterba@suse.cz, Hugo Mills <hugo@carfax.org.uk>,
        =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        linux-btrfs@vger.kernel.org
References: <15fc8f8d002e4ffcdb46e769736f240ae7ace20b.1442839332.git.zhaolei@cn.fujitsu.com>
 <560150CD.6070301@suse.com> <5601596B.1020607@googlemail.com>
 <20150922134131.GH5918@carfax.org.uk> <20150922142333.GH12815@twin.jikos.cz>
 <20150922143602.GI5918@carfax.org.uk> <56016BB5.6060101@gmail.com>
 <20150922153930.GK5918@carfax.org.uk> <20150923132829.GB12815@twin.jikos.cz>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <5602AFDB.6030002@gmail.com>
Date: Wed, 23 Sep 2015 09:57:47 -0400
MIME-Version: 1.0
In-Reply-To: <20150923132829.GB12815@twin.jikos.cz>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms000502010300030207050505"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms000502010300030207050505
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-09-23 09:28, David Sterba wrote:
> On Tue, Sep 22, 2015 at 03:39:30PM +0000, Hugo Mills wrote:
>>> The way I would expect things to work is that a new subvolume
>>> inherits it's properties from it's parent (if it's a snapshot),
>>
>>     Definitely this.
>>
>>> or
>>> from the next higher subvolume it's nested in.
>>
>>     I don't think I like this. I'm not quite sure why, though, at the
>> moment.
>
> I don't like inheritance from other than the parent subvolume because
> this makes things less obvious.
Possibly, but that depends on how you view things.  Internally,=20
subvolumes are independent of each other, but to a regular user (or=20
anything that just uses the VFS layer), they look hierarchical, and as=20
such without knowing the internals of the FS (which no regular user=20
should need to know) I would expect the profile to propagate down from=20
the (apparently) next higher subvolume.

It's worth noting that I mean that it should just copy the properties=20
from the next higher subvolume at creation, and if the next higher=20
subvolume doesn't have the properties set, then just use the filesystem=20
defaults (and don't try to walk back up more than one level).
>>     It definitely makes the process at the start of allocating a new
>> block group much more complex: you have to walk back up through an
>> arbitrary depth of nested subvols to find the one that's actually got
>> a replication policy record in it. (Because after this feature is
>> brought in, there will be lots of filesystems without per-subvol
>> replication policies in them, and we have to have some way of dealing
>> with those as well).
>>
>>     With an FS default policy, you only need check the current subvol,=

>> and then fall back to the FS default if that's not found.
>
> That looks reasonable to me.
>
>>     These things are, I think, likely to be lightly used: I would be
>> reasonably surprised to find more than two or possibly three storage
>> policies in use on any given system with a sane sysadmin.
>
> Agreed. At the moment I'm thinking about all the configuration
> possibilites we want to give to the users. Eg. the inheritance can be
> configurable on the property level.
>
> The usecase: the toplevel has compression enabled but I don't want any
> new subvolume share this property automatically.
>
> (The blockgroup type is probably a bad example for configurable
> inheritance as it would not work for shared extents if the type is
> different.)
Ideal situation in my opinion WRT block-group profile inheritance would=20
be that when an extent becomes shared, it get's re-striped at the=20
highest raid profile (prioritizing 3-copy or higher replication over=20
raid56) of any of the files that share the extent.  This would result in =

some more I/O than the usual clone operation in some cases, but any=20
other method has the potential to silently reduce the degree of data=20
safety for a given file.



--------------ms000502010300030207050505
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwOTIzMTM1NzQ3WjBPBgkq
hkiG9w0BCQQxQgRA+b/9/ZINMEwIFWB0bPv6iZalirKsw1pDZD1EQD9WPPPxEELYwRJ2T1Yg
GbkOa7UWyvi1VFN/0Vqa9Vx12goHTTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxEt+DCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxEt+DAN
BgkqhkiG9w0BAQEFAASCAgBpoV60hyEMpQp8vb7shVgsZozP+GY8zgmy/g9xpM9R2S9vjcsW
vxECA0PMDefDRGvBgHnf23dEROBiCDi6w8IHfJ4I7NlPfaXHV8RhpFyDo4pXeKT77dJZsR2+
ZdcluX6ipf0t6jgkvYUDPUCxOfRLHWik8qawRPqM7/zGs5N7esv7nHhb6ahEUEjTN8QVNPec
u8Kp0k/IfY16fkX1e7lULczLk4oVw1h2Hab6ovl0nyzE/RYVI52pnXxnBoTIlbbXIsNIfOkN
Vt48JeN1EQcQyVFLUEETJIAkMQv3DQGdFnmkWxzxGcvz/eC2YucYsx2RJ3VdLMbzzQ/R1Cxt
XrSJ7VoKBoqlv8uxlFz8K8S7auFDqe5DB/qgsgriEXp0kitiEIQ2rr3B4vc5MgEyrkxylq9W
wJSPbKVt2yOZe5QezV/gvCXgtEMc5qzEaN8e3a2hrc1iTJR62kqeEoRLjX5HOWGbPVfkaACJ
/YPL5OwAatYjknR7XUP2RzLa2BPKkTCxLAwnUQMkkywIA+DSCr2X1ElOR1beBZ9PW+myWDmL
EZ8EsSPm5AzgK2r51Lbji4sdk1LjSXXtubODf0iviJSdiFSB1XLr8IH/dOq4cmQCsvs5xfhg
RX5yAdNc7oSC9WMSyY3phMsP0lo+dQRGlQ8HvEfzc+L+zoE9YL7M4H5CPwAAAAAAAA==
--------------ms000502010300030207050505--
