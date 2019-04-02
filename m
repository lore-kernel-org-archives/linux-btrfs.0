Return-Path: <SRS0=SOow=SE=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.7 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A561BC4360F
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 14:12:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 504282070B
	for <linux-btrfs@archiver.kernel.org>; Tue,  2 Apr 2019 14:12:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=gmx.net header.i=@gmx.net header.b="KiEF7SG4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729697AbfDBOMW (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 2 Apr 2019 10:12:22 -0400
Received: from mout.gmx.net ([212.227.15.18]:58327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726903AbfDBOMV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 Apr 2019 10:12:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1554214337;
        bh=vOGcmpb1+ps6o7wwgnhmNqmcAS2aca11FlGRYkPW3+Y=;
        h=X-UI-Sender-Class:Subject:To:References:From:Date:In-Reply-To;
        b=KiEF7SG4GP42uhVvpdXNsr3OdADwlcXPnAXDqOVNZZgEtJX2/AUDt+SvZZfhGZO7t
         LEDwYQn3OLRAcp7TK/MyuHtPKB5VGzBkj6LzTK8mptIuy1pf5H2xu1LfuOjjP6OmGw
         7XaaAxoU0JUDbsxelxcQONUjnsVZ4L8qLzI9NzYs=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MbOoG-1hTwxW46cO-00IiGw; Tue, 02
 Apr 2019 16:12:17 +0200
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
To:     "Nik." <btrfs@avgustinov.eu>, linux-btrfs@vger.kernel.org
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
Date:   Tue, 2 Apr 2019 22:12:10 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Qv7Up4wFBeASIbiJHgpxAATQAwyCSQH76"
X-Provags-ID: V03:K1:0tv9Swec4WbtY9fk/L6/L9Ci+e42twTf3v2xJk1UNWhvb9k64Ht
 bm0GP9fIB77vccWpKPb+gypoA+AyT2MYtwfuDOFUyV2dpm0oZ0bQdk8mgeWlTU/YGqRt+Ia
 6SVMZfjIFRz1E9wi/zd8KXqsTtpaxAAtZkHKWe7HQfWeNGjwdC0HtxWWOSEgQKTjrG0FjB8
 bOKqAoKsaTzH5FIN0uZhg==
X-UI-Out-Filterresults: notjunk:1;V03:K0:nRG/kz/sTgs=:Hn3wuSGSvzgFRA6H6m/tps
 334W32Kg42AFdZHTU0gXLA6WC7hPm63UnNTlzH4QQnp0GxECcyrJRzbUMLJJMUpqRIUzL2eXb
 cAekjEnM7G/N6o/p87F2rue3oyXiKB6TbEqPDJIiYAz5zEGPP8ZFlgpZkAoFOG9arNvJlH9fC
 eH9tf4X4VoBF+/MrxPOY6sUicJHn/jXR+jh6+LutKWxucSn+KWj8corzJdhSHucrl6rOlUKGp
 6l3Kscg8OSvdGtGrmQI8p2tG9dlEmemkRRA+Jgw+kFF0ImXZMU3oMWFeviWElK/YmIqz3bxrJ
 ABoGCzjJJ0GqoDksYm9Ydoge2iaEeB4PVfWtAfLJ5msIRCMSeXag59SJ8Q1fwRfDZaL9lxmBI
 gZ9i3UNJU+dFHDl1XJyyBABcIq6DSxCQdHLxZZX0nBUaNkIh/Oa2KwHiL2xk5Fhvf554rolvQ
 CLOm5+hU32HkkvELg1mib0oKRbeR0W8+xuTjx2CxnXmHM2Z5itMr1dZJRfh6VGKI2IUS2+/p0
 FcyByhhf6Gua7wygyAgQRTfWH+yIO9Wsd6KDrQ5yYg12xtcpI4gZ1VpJRu7pV0o+jABFuWECo
 Wrmnyz9TOqagyES5TxiYmHbu0tbDVHAk3bhFECVvI5nvQW1YFEqCNdupanNcMIK2zdglg5PJc
 r5qMlSx7K3jeVk9CX+UNGx5o0LlbFHF3h7WpHMbd7sEXIRbCK/AtJ6owI3kqciKlxgh867O6A
 1yhKSVIKqJcbXrFPdEdkXG7urpEpygwe1AHT/zJU2XYYIQmnerZWpA0QX9fLOzp2EISpVJuCa
 93Xlum0stLuCiLX5bb4cv6JNopugEEt3jNwozObKQmA5LCGHvHirP8fO3o81th4famx1OC++7
 MQ/4EzQ1p9+fpDlDq2B8b4tMxh1iejRClLxhnF0jDQhrjwt+GpW6Y8JoETNNE1
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Qv7Up4wFBeASIbiJHgpxAATQAwyCSQH76
Content-Type: multipart/mixed; boundary="VnvDPZjWMpJ973I93FGUww7CZW0nPJDEx";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: "Nik." <btrfs@avgustinov.eu>, linux-btrfs@vger.kernel.org
Message-ID: <ff7f4039-25d8-f5c9-80ac-4e7afaace3d0@gmx.com>
Subject: Re: interest in post-mortem examination of a BTRFS system and
 improving the btrfs-code?
References: <aa81a49a-d5ca-0f1c-fa75-9ed3656cff55@avgustinov.eu>
 <a6cb572c-c015-1e19-7489-c59fd1384509@avgustinov.eu>
 <9cf1e935-c0b1-6546-5f1e-f8e88839d560@gmx.com>
 <99c1632a-a575-b5eb-8a26-8f92666f9c3a@avgustinov.eu>
 <c0909c80-8167-7b46-3a3c-d57962aee7fd@gmx.com>
 <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>
In-Reply-To: <6c4d5ccf-562d-a9b7-3aba-0a3bfd3797eb@avgustinov.eu>

--VnvDPZjWMpJ973I93FGUww7CZW0nPJDEx
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2019/4/2 =E4=B8=8B=E5=8D=889:59, Nik. wrote:
>=20
>=20
> 2019-04-02 15:24, Qu Wenruo:
>>
>>
>> On 2019/4/2 =E4=B8=8B=E5=8D=889:06, Nik. wrote:
>>>
>>> 2019-04-02 02:24, Qu Wenruo:
>>>>
>>>> On 2019/4/1 =E4=B8=8A=E5=8D=882:44, btrfs@avgustinov.eu wrote:
>>>>> Dear all,
>>>>>
>>>>>
>>>>> I am a big fan of btrfs, and I am using it since 2013 - in the
>>>>> meantime
>>>>> on at least four different computers. During this time, I suffered =
at
>>>>> least four bad btrfs-failures leading to unmountable, unreadable an=
d
>>>>> unrecoverable file system. Since in three of the cases I did not
>>>>> manage
>>>>> to recover even a single file, I am beginning to lose my confidence=
 in
>>>>> btrfs: for 35-years working with different computers no other file
>>>>> system was so bad at recovering files!
>>>>>
>>>>> Considering the importance of btrfs and keeping in mind the number =
of
>>>>> similar failures, described in countless forums on the net, I have =
got
>>>>> an idea: to donate my last two damaged filesystems for investigatio=
n
>>>>> purposes and thus hopefully contribute to the improvement of btrfs.=

>>>>> One
>>>>> condition: any recovered personal data (mostly pictures and audio
>>>>> files)
>>>>> should remain undisclosed and be deleted.
>>>>>
>>>>> Should anybody be interested in this - feel free to contact me
>>>>> personally (I am not reading the list regularly!), otherwise I am
>>>>> going
>>>>> to reformat and reuse both systems in two weeks from today.
>>>>>
>>>>> Some more info:
>>>>>
>>>>> =C2=A0=C2=A0=C2=A0 - The smaller system is 83.6GB, I could either s=
end you an
>>>>> image of
>>>>> this system on an unneeded hard drive or put it into a dedicated
>>>>> computer and give you root rights and ssh-access to it (the network=

>>>>> link
>>>>> is 100Mb down, 50Mb up, so it should be acceptable).
>>>>
>>>> I'm a little more interested in this case, as it's easier to debug.
>>>>
>>>> However there is one requirement before debugging.
>>>>
>>>> *NO* btrfs check --repair/--init-* run at all.
>>>> btrfs check --repair is known to cause transid error.
>>>
>>> unfortunately, this file system was used as testbed and even
>>> "btrfs check --repair --check-data-csum --init-csum-tree --init-exten=
t
>>> tree ..." was attempted on it.
>>> So I assume you are not interested.
>>
>> Then the fs can be further corrupted, so I'm not interested.
>>
>>>
>>> On the larger file system only "btrfs check --repair --readonly ..." =
was
>>> attempted (without success; most command executions were documented, =
so
>>> the results can be made available), no writing commands were issued.
>>
>> --repair will cause write, unless it even failed to open the filesyste=
m.
>>
>> If that's the case, it would be pretty interesting for me to poking
>> around the fs, and obviously, all read-only.
>>
>>>
>>>> And, I'm afraid even with some debugging, the result would be pretty=

>>>> predictable.
>>>
>>> I do not need anything from the smaller file system and have (hopeful=
ly
>>> fresh enough) backups from the bigger one.
>>> I would be good enough if it helps to find any bugs, which are still =
in
>>> the code.
>>>
>>>> It will be 90% transid error.
>>>> And if it's tree block from future, then it's something barrier
>>>> related.
>>>> If it's tree block from the past, then it's some tree block doesn't
>>>> reach disk.
>>>>
>>>> We have being chasing the spectre for a long time, had several
>>>> assumption but never pinned it down.
>>>
>>> IMHO spectre would lead to much bigger loses - at least in my case it=

>>> could have happened all four times, but it did not.
>>>
>>>> But anyway, more info is always better.
>>>>
>>>> I'd like to get the ssh access for this smaller image.
>>>
>>> If you are still interested, please advise how to create the image of=

>>> the file system.
>>
>> If the larger fs really doesn't get any write (btrfs check --repair
>> failed to open the fs, thus have the output "cannot open file system")=
,
>> I'm interesting in that one.
>=20
> This is excerpt from the terminal log:
> "# btrfs check --readonly /dev/md0
> incorrect offsets 15003 146075
> ERROR: cannot open file system
> #"

That's great.

And to my surprise, this is completely different problem.

And I believe, it will be detected by latest write time tree checker
patches in next kernel release.

This problem is normally caused by memory bit flip.
This should ring a little alert about the problem.

Anyway, v5.2 or v5.3 kernel would be much better to catch such problems.

>=20
> Btw., since the list does allow _plain_text_only, I wonder how do you
> quote?
>=20
>> If not, then no.
>>
>>> I can imagine that it is preferable to use the
>>> original, but in my case it is a (not mounted) partition of a bigger
>>> hard drive, and the other partitions are in use. The "btrfs-image" se=
ems
>>> inappropriate to me, "dd" will probably screw things up?
>>
>> Since the fs is too large, I don't think either way is good enough.
>>
>> So in this case, the best way for me to poke around is to give me a
>> caged container with only read access to the larger fs.
>=20
> I am afraid that this machine is too weak for using containers on it
> (QNAP SS839Pro NAS, Intel Atom, 2GB RAM), and right now I do not have
> other machine, which could accommodate five hard drives. Let me conside=
r
> how to organize this or give another idea. One way could be "async ssh"=

> -=C2=A0 a private ssl-chat on one of my servers, so that you can write =
your
> commands there, I execute them on the machine as soon as I can and put
> the output back into the chat-window? Sounds silly, but could start
> immediately, and I have no better idea right now, sorry!

Your btrfs check output is already good enough to locate the problem.

The next thing would be just to help you recovery that image if that's
what you need.

The purposed idea is not that uncommon. In fact it's just another way of
"show commands, user execute and report, developer check the output" loop=
=2E

In your case, you just need latest btrfs-progs and re-run "btrfs check
--readonly" on it.

If it just shows the same result, meaning I can't get the info about
which tree block is corrupted, then you could try to mount it with -o ro
using *LATEST* kernel.

Latest kernel will report anything wrong pretty vocally, in that case,
dmesg would include the bytenr of corrupted tree block.

Then I could craft needed commands to further debug the fs.

Thanks,
Qu

>=20
> Thank you for trying to improve btrfs!
>=20
> Nik.
>>
>> Thanks,
>> Qu
>=20
> You are not from the 007 - lab, are you? ;-)
>=20
>>>
>>> Kind regards,
>>>
>>> Nik.
>>


--VnvDPZjWMpJ973I93FGUww7CZW0nPJDEx--

--Qv7Up4wFBeASIbiJHgpxAATQAwyCSQH76
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEyBAEBCAAdFiEELd9y5aWlW6idqkLhwj2R86El/qgFAlyjbboACgkQwj2R86El
/qgB4wf42vYlAuGk7e1plmBfVBXJtty1s8o23L6ilcJVliW+TPj/anlH6wMJxYms
A9WTJGYBGOyAzbCmEbEJW5IApH7XQuJJnFMVEuZVqeXO3nI3XUImVNjoCDrWYaYl
vp2FLchSnTxn6Havt1DSHhW6F/+moqzlVXyDypL26NK4GORtyHcw/EGaZHhfGaLm
YQkcHvKVTMoMA/JKDDHlPOfjkD7kr3KDjurXqpx9xvqmfYcqe4l/4FGc+dlXffap
I73fUPDQnbcgpF3iU75GLuKiQ5lh+dA4X3BbLr4QB+tIfUK75Z5IfTCMS+e0gnjF
583ycc228dbgVe/ouy1HIB24+t7X
=/iui
-----END PGP SIGNATURE-----

--Qv7Up4wFBeASIbiJHgpxAATQAwyCSQH76--
