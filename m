Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:36044 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbHYSJj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 14:09:39 -0400
Received: by igcse8 with SMTP id se8so19724221igc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Aug 2015 11:09:39 -0700 (PDT)
Received: from [127.0.0.1] (rrcs-70-62-41-24.central.biz.rr.com. [70.62.41.24])
        by smtp.googlemail.com with ESMTPSA id r4sm1716433igh.14.2015.08.25.11.09.38
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Aug 2015 11:09:38 -0700 (PDT)
Subject: Re: BTRFS raid6 unmountable after a couple of days of usage.
To: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <55A4F74D.9000305@gmail.com> <55A79A67.8010408@gmail.com>
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55DCAF5D.5090906@gmail.com>
Date: Tue, 25 Aug 2015 14:09:33 -0400
MIME-Version: 1.0
In-Reply-To: <55A79A67.8010408@gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms020307090406070303000907"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms020307090406070303000907
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-16 07:49, Austin S Hemmelgarn wrote:
> On 2015-07-14 07:49, Austin S Hemmelgarn wrote:
>> So, after experiencing this same issue multiple times (on almost a
>> dozen different kernel versions since 4.0) and ruling out the
>> possibility of it being caused by my hardware (or at least, the RAM,
>> SATA controller and disk drives themselves), I've decided to report it=

>> here.
>>
>> The general symptom is that raid6 profile filesystems that I have are
>> working fine for multiple weeks, until I either reboot or otherwise
>> try to remount them, at which point the system refuses to mount them.
>>
>> I'm currently using btrfs-progs v4.1 with kernel 4.1.2, although I've
>> been seeing this with versions of both since 4.0.
>>
>> Output of 'btrfs fi show' for the most recent fs that I had this issue=

>> with:
>>          Label: 'altroot'  uuid: 86eef6b9-febe-4350-a316-4cb00c40bbc5
>>     Total devices 4 FS bytes used 9.70GiB
>>     devid    1 size 24.00GiB used 6.03GiB path /dev/mapper/vg-altroot.=
0
>>     devid    2 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.=
1
>>     devid    3 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.=
2
>>     devid    4 size 24.00GiB used 6.01GiB path /dev/mapper/vg-altroot.=
3
>>
>>          btrfs-progs v4.1
>>
>> Each of the individual LVS that are in the FS is just a flat chunk of
>> space on a separate disk from the others.
>>
>> The FS itself passes btrfs check just fine (no reported errors, exit
>> value of 0), but the kernel refuses to mount it with the message
>> 'open_ctree failed'.
>>
>> I've run btrfs chunk recover and attached the output from that.
>>
>> Here's a link to an image from 'btrfs image -c9 -w':
>> https://www.dropbox.com/s/pl7gs305ej65u9q/altroot.btrfs.img?dl=3D0
>> (That link will expire in 30 days, let me know if you need access to
>> it beyond that).
>>
>> The filesystems in question all see relatively light but consistent
>> usage as targets for receiving daily incremental snapshots for
>> on-system backups (and because I know someone will mention it, yes, I
>> do have other backups of the data, these are just my online backups).
>>
> Secondary but possibly related issue, I'm seeing similar issues with al=
l
> data/metadata profiles when using BTRFS on top of a dm-thinp volume wit=
h
> zeroing-mode turned off (that is, discard doesn't clear data from the
> areas that were discarded).
>
Following up further on this specific issue, I've tracked this down to=20
dm-thinp not clearing the discard_zeros_data flag on the devices when=20
you turn off zeroing mode.  I'm going to do some more digging regarding=20
that and probably send a patch to lkml to fix it.


--------------ms020307090406070303000907
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwODI1MTgwOTMzWjBPBgkq
hkiG9w0BCQQxQgRAuHNhVn4teE7P3xwSSFZL0prdf87Lfu7dznuzDPeb6diw0pr9su0fKOzT
6t5YerfuKrjb/aG1A1+3DijhPYDVMTBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgA1k1pq1jw/h3qmcipWjE7U5wLB/pjWOSNJOmXX5IXj2tVkZ6Kw
LsLmysRnQNi1bGShXwynx9R/6HT+v7djUAL3VEWlpG5ozX4V4hsBk/21xy5HF6lebEAxmvdv
sDi4n9GAD9XZaEyKz2GJEMUEHU3ofgge9AVjxzP8KOKSzJd3LA0QqUUTnEEDnxPPO3i4psYT
02k6JF6Mqu4EPkszIN0eACwah4M+DC4CbPghjx/rt2FV9RLZPjOmF9srXedn2zG0y8qPEqeD
h35pYBo8vtHgkwclaxKxVNzN3XdUh5hf+v18bvSufGc+/+hpolg5zeYvhFwjHPtOvnwFITpV
Rcr39COMESO9HoRlSMzaUrNRsihTcx7mx9iya4ybhV+5IhIJcVZjJPHI8HagqlUrvaPNGeYx
HoEEFQjDux27dMdL0vKxYiRDX7xSRs2nMg7Sp79xjFepkgg0wWdp2K2SGJpNhj64wbNdX2nS
e6yK6gGBgewBSRKnayGaWTzBk0WMbgydpxrt0SaMnjYVb8lBAk+6l90Y2cLgF0YrfrQD/lG2
TXoR+YwVspWVmYZOVY/qRTmN/NalKH8EEq0z7d/U0YYBDQBKzHDjlFS+JDbN9CQjdro3fF2M
5yI/tKkPE95zzKcAsQ/WlLY5Thkxb/H6NCJBXmoLXEJ4Ha/rAFlQlW6TWQAAAAAAAA==
--------------ms020307090406070303000907--
