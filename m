Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:62256 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750955AbeAVAjS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jan 2018 19:39:18 -0500
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, linux-btrfs@vger.kernel.org
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
Date: Mon, 22 Jan 2018 08:39:11 +0800
MIME-Version: 1.0
In-Reply-To: <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="TEpI3KEy7dF1ru9MFL93r6gwMVRxHiT2j"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--TEpI3KEy7dF1ru9MFL93r6gwMVRxHiT2j
Content-Type: multipart/mixed; boundary="dpzCigMZdThZU0VK2C2hlDeAvVwZfGNk2";
 protected-headers="v1"
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
To: Sebastian Ochmann <ochmann@cs.uni-bonn.de>, linux-btrfs@vger.kernel.org
Message-ID: <218e3b6d-a15a-7a43-35b0-721be18fcd86@gmx.com>
Subject: Re: Periodic frame losses when recording to btrfs volume with OBS
References: <f52e20c8-db0d-ffbb-91e3-268c548a544a@cs.uni-bonn.de>
 <35acc308-d68d-3a4b-a626-38b9a7820fd4@gmx.com>
 <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>
In-Reply-To: <a0b4a2c9-b61c-7f9a-5a24-88e4b83b887c@cs.uni-bonn.de>

--dpzCigMZdThZU0VK2C2hlDeAvVwZfGNk2
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable



On 2018=E5=B9=B401=E6=9C=8821=E6=97=A5 23:27, Sebastian Ochmann wrote:
> On 21.01.2018 11:04, Qu Wenruo wrote:
>>
>>
>> On 2018=E5=B9=B401=E6=9C=8820=E6=97=A5 18:47, Sebastian Ochmann wrote:=

>>> Hello,
>>>
>>> I would like to describe a real-world use case where btrfs does not
>>> perform well for me. I'm recording 60 fps, larger-than-1080p video us=
ing
>>> OBS Studio [1] where it is important that the video stream is encoded=

>>> and written out to disk in real-time for a prolonged period of time (=
2-5
>>> hours). The result is a H264 video encoded on the GPU with a data rat=
e
>>> ranging from approximately 10-50 MB/s.
>>
>>>
>>> The hardware used is powerful enough to handle this task. When I use =
a
>>> XFS volume for recording, no matter whether it's a SSD or HDD, the
>>> recording is smooth and no frame drops are reported (OBS has a nice
>>> Stats window where it shows the number of frames dropped due to encod=
ing
>>> lag which seemingly also includes writing the data out to disk).
>>>
>>> However, when using a btrfs volume I quickly observe severe, periodic=

>>> frame drops. It's not single frames but larger chunks of frames that =
a
>>> dropped at a time. I tried mounting the volume with nobarrier but to =
no
>>> avail.
>>
>> What's the drop internal? Something near 30s?
>> If so, try mount option commit00 to see if it helps.
>=20
> Thank you for your reply. I observed the interval more closely and it
> shows that the first, quite small drop occurs about 10 seconds after
> starting the recording (some initial metadata being written?). After
> that, the interval is indeed about 30 seconds with large drops each tim=
e.

This almost proves my assumption to transaction commitment performance.

But...

>=20
> Thus I tried setting the commit option to different values. I confirmed=

> that the setting was activated by looking at the options "mount" shows
> (see below). However, no matter whether I set the commit interval to
> 300, 60 or 10 seconds, the results were always similar. About every 30
> seconds the drive shows activity for a few seconds and the drop occurs
> shortly thereafter.

Either such mount option has a bug, or some unrelated problem.

As you mentioned the output is about 10~50MiB/s, 30s means 300~1500MiBs.
Maybe it's related to the dirty data amount?

Would you please verify if a lower or higher profile (resulting much
larger or smaller data stream) would affect?


Despite that, I'll dig to see if commit=3D option has any bug.

And you could also try the nospace_cache mount option provided by Chris
Murphy, which may also help.

Thanks,
Qu

> It almost seems like the commit setting doesn't have
> any effect. By the way, the machine I'm currently testing on has 64 GB
> of RAM so it should have plenty of room for caching.
>=20
>>>
>>> Of course, the simple fix is to use a FS that works for me(TM). Howev=
er
>>> I thought since this is a common real-world use case I'd describe the=

>>> symptoms here in case anyone is interested in analyzing this behavior=
=2E
>>> It's not immediately obvious that the FS makes such a difference. Als=
o,
>>> if anyone has an idea what I could try to mitigate this issue (mount =
or
>>> mkfs options?) I can try that.
>>
>> Mkfs.options can help, but only marginally AFAIK.
>>
>> You could try mkfs with -n 4K (minimal supported nodesize), to reduce
>> the tree lock critical region by a little, at the cost of more metadat=
a
>> fragmentation.
>>
>> And is there any special features enabled like quota?
>> Or scheduled balance running at background?
>> Which is known to dramatically impact performance of transaction
>> commitment, so it's recommended to disable quota/scheduled balance fir=
st.
>>
>>
>> Another recommendation is to use nodatacow mount option to reduce the
>> CoW metadata overhead, but I doubt about the effectiveness.
>=20
> I tried the -n 4K and nodatacow options, but it doesn't seem to make a
> big difference, if at all. No quota or auto-balance is active. It's
> basically using Arch Linux default options.
>=20
> The output of "mount" after setting 10 seconds commit interval:
>=20
> /dev/sdc1 on /mnt/rec type btrfs
> (rw,relatime,space_cache,commit=10,subvolid=3D5,subvol=3D/)
>=20
> Also tried noatime, but didn't make a difference either.
>=20
> Best regards
> Sebastian
>=20
>> Thanks,
>> Qu >>
>>> I saw this behavior on two different machines with kernels 4.14.13 an=
d
>>> 4.14.5, both Arch Linux. btrfs-progs 4.14, OBS 20.1.3-241-gf5c3af1b
>>> built from git.
>>>
>>> Best regards
>>> Sebastian
>>>
>>> [1] https://github.com/jp9000/obs-studio
>>> --=C2=A0
>>> To unsubscribe from this list: send the line "unsubscribe
>>> linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.ht=
ml
>>
> --=20
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at=C2=A0 http://vger.kernel.org/majordomo-info.html=



--dpzCigMZdThZU0VK2C2hlDeAvVwZfGNk2--

--TEpI3KEy7dF1ru9MFL93r6gwMVRxHiT2j
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFLBAEBCAA1FiEELd9y5aWlW6idqkLhwj2R86El/qgFAlplMq8XHHF1d2VucnVv
LmJ0cmZzQGdteC5jb20ACgkQwj2R86El/qiEmgf/dTI677IiXgd4EeZwsEfGPQoc
z8o3t41ysQOGJUiXKbHD8qGix9Kikg+quwrFchkHymiagnnwrzvMqEmOMKuM76pf
/9TBOS5OQZwpZCpQPfPPPQTFwZcDAHDLx8jqswEopu7LvNXerqEFQa5N+68iJyMj
4xLoQ5C6YP93ha5ZhLUHt5yn3kKE2S6h+BdwMdfGJWGFCbxEL+S1GFAYf+5efKWS
dqeTKHsymhKk17Gu7uws+sVTmVRxgQoazil6AnjvDEUQmEI1JkvLjGFU0NbRZMmv
rfEgl0XKte9EaNEH5OhtQ1JSLsmqN1mBPnz0h3jRM5RFnmUVbJUREJIQiDVtSw==
=Cadu
-----END PGP SIGNATURE-----

--TEpI3KEy7dF1ru9MFL93r6gwMVRxHiT2j--
