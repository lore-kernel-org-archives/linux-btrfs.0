Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f175.google.com ([209.85.223.175]:34960 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbbGWLLt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jul 2015 07:11:49 -0400
Received: by iecri3 with SMTP id ri3so94623254iec.2
        for <linux-btrfs@vger.kernel.org>; Thu, 23 Jul 2015 04:11:48 -0700 (PDT)
Subject: Re: Can't mount btrfs volume on rbd
To: Gregory Farnum <greg@gregs42.com>
References: <CAEMJtDs=U5+YO9sbVvjxLthdxp6JvZO=07EMhcU5Smif_1m5QQ@mail.gmail.com>
 <557A890D.8080306@cn.fujitsu.com>
 <CAEMJtDu2zZJc-dg9opj0xHaKyeL78H0ppivb8mJFhChJ4J63uA@mail.gmail.com>
 <557E877E.2060704@cn.fujitsu.com>
 <CAEMJtDusywPEnDcNcMvvFKQsuZyTmSMXXgJT=eBZX1F+R8RM8w@mail.gmail.com>
 <557F7B82.2060203@cn.fujitsu.com>
 <CAEMJtDv1Tm7-O2mU03kZhPDkaSj7nVi+VAZVhPfh7BN8AuF2Bg@mail.gmail.com>
 <55A46473.8070106@cn.fujitsu.com> <55AE04EF.6040807@cn.fujitsu.com>
 <55AE29DA.4050201@gmail.com>
 <CAEMJtDuaOYPomha_VbTah521BZTYzmrg2D5tk6N4rd1Y8UPaog@mail.gmail.com>
 <55AEF984.9080706@cn.fujitsu.com> <55AF7B84.9000009@gmail.com>
 <CAC6JEv-=9LPR7XL9XJt6ZSKGuGYS4eAT+fAYHNrRQJWxe1metQ@mail.gmail.com>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>, Steve Dainard <sdainard@spd1.com>,
        linux-btrfs@vger.kernel.org
From: Austin S Hemmelgarn <ahferroin7@gmail.com>
Message-ID: <55B0CBE6.7080306@gmail.com>
Date: Thu, 23 Jul 2015 07:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <CAC6JEv-=9LPR7XL9XJt6ZSKGuGYS4eAT+fAYHNrRQJWxe1metQ@mail.gmail.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-512; boundary="------------ms060308070804090205070709"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is a cryptographically signed message in MIME format.

--------------ms060308070804090205070709
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 2015-07-22 10:13, Gregory Farnum wrote:
> On Wed, Jul 22, 2015 at 12:16 PM, Austin S Hemmelgarn
> <ahferroin7@gmail.com> wrote:
>> On 2015-07-21 22:01, Qu Wenruo wrote:
>>>
>>> Steve Dainard wrote on 2015/07/21 14:07 -0700:
>>>>
>>>> I don't know if this has any bearing on the failure case, but the
>>>> filesystem that I sent an image of was only ever created, subvol
>>>> created, and mounted/unmounted several times. There was never any da=
ta
>>>> written to that mount point.
>>>>
>>> Subvol creation and rw mount is enough to trigger 2~3 transaction wit=
h
>>> DATA written into btrfs.
>>> As the first rw mount will create free space cache, which is counted =
as
>>> data.
>>>
>>> But without multiple mount instants, I really can't consider another
>>> method to destroy btrfs so badly but with all csum OK...
>>>
>> I know that a while back RBD had some intermittent issues with data
>> corruption in the default configuration when the network isn't absolut=
ely
>> 100% reliable between all nodes (which for ceph means not only no pack=
et
>> loss, but also tight time synchronization between nodes and only very =
low
>> network latency).
>>
>> I also heard somewhere (can't remember exactly where though) of people=

>> having issues with ZFS on top of RBD.
>>
>> The other thing to keep in mind is that Ceph does automatic background=
 data
>> scrubbing (including rewriting stuff it thinks is corrupted), so there=
 is no
>> guarantee that the data on the block device won't change suddenly with=
out
>> the FS on it doing anything.
>
> Ceph will automatically detect inconsistent data with its scrubbing,
> but it won't rewrite that data unless the operator runs a repair
> command. No invisible data changes! :)
Ah, you're right, I forgot about needing admin intervention for changes=20
(It's been a while since I tried to do anything with Ceph).
>
> I'm also not familiar with any consistency issues around network speed
> or time sync, but I could have missed something. The only corruption
> case I can think of was a release that enabled some local FS features
> which in combination were buggy on some common kernels in the wild.
Poor time synchronization between the nodes can cause some of the=20
monitor nodes to lose their minds, which can cause corruption if the=20
cluster is actually being utilized, but won't usually cause issues=20
otherwise (although it will complain very noisily and persistently about =

lack of proper time synchronization).



--------------ms060308070804090205070709
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
cnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcN
AQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTANBglghkgBZQMEAgMFAKCCAiEwGAYJKoZI
hvcNAQkDMQsGCSqGSIb3DQEHATAcBgkqhkiG9w0BCQUxDxcNMTUwNzIzMTExMTM0WjBPBgkq
hkiG9w0BCQQxQgRA2OJe7guhFAFz169Ws8GSlZhiflEhRuLQfRhZsnOzTwAHm7/1tGm4wgzr
fA6sLxh1VNlrfelQHH9rMnpB1JqFXzBsBgkqhkiG9w0BCQ8xXzBdMAsGCWCGSAFlAwQBKjAL
BglghkgBZQMEAQIwCgYIKoZIhvcNAwcwDgYIKoZIhvcNAwICAgCAMA0GCCqGSIb3DQMCAgFA
MAcGBSsOAwIHMA0GCCqGSIb3DQMCAgEoMIGRBgkrBgEEAYI3EAQxgYMwgYAweTEQMA4GA1UE
ChMHUm9vdCBDQTEeMBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlD
QSBDZXJ0IFNpZ25pbmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2Vy
dC5vcmcCAxBuVTCBkwYLKoZIhvcNAQkQAgsxgYOggYAweTEQMA4GA1UEChMHUm9vdCBDQTEe
MBwGA1UECxMVaHR0cDovL3d3dy5jYWNlcnQub3JnMSIwIAYDVQQDExlDQSBDZXJ0IFNpZ25p
bmcgQXV0aG9yaXR5MSEwHwYJKoZIhvcNAQkBFhJzdXBwb3J0QGNhY2VydC5vcmcCAxBuVTAN
BgkqhkiG9w0BAQEFAASCAgAEBTFcizp8E8mfGp3vIP7/eTOJBCQNT3KnPGKwxHa+wtYGVLmb
v8tGQDUB60fky6uJDghkagDXy1MeoMG2iuA1qI9zAS7Top2WhfhAEbziYX0+XrsAklY3Su3x
Z0Wzmm3EjaoKQH7T+y2p4uqi07NyTmPcEQqSgSJDZ4qrOcwXWI8OYIu5L+Sa/tUs0N2H8I1s
8wFsfX3oDAnQlDxDtpZiuXITa7TFdXcOWSyEIS0gPzoBPsc0u7cEKg8fEZiEFKV1DUj12JVm
ZAm/KTh4yH1zkcsQgPtXHCjvHjDvC22Vi0tn65chGFqXdSC7HOZdM6jN1Y4uh/yEy3vKRpMa
7VmTgX+hk71aRO/76X0bD+37QHjJCYu6BXg1bvWPljvRJGW6RCTtIgulQbyxaKfEX43sgmiz
/FA/kvkwuGjAtcKIcSBKwhM/V2oUkDaeP/kyRJGbJjrwmPtEd7kWiY8aIo1Z127FRdijxDlR
8JFi+VhF/16bBsvfNr46t4afikRV3lU0PDaaTPpARaZuZvztOOjIr2GkEE5GHxIxd1N/khM5
Gt6uN/cby/ZwZEa2HpiqAyI6vGqz973j7F/2nuvX4uHoNe3mgxndMbD00LwQv09HJ6JNBIwT
43g4qjwR+ZP2sF88ix3faa73Hm1kmahrpAxmEwEH69pAMy7UR8OxzacO6gAAAAAAAA==
--------------ms060308070804090205070709--
