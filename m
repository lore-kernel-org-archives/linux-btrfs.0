From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Consistent crash with cp reflink on large files
Date: Tue, 13 Dec 2011 09:28:56 +0800
Message-ID: <4EE6AA58.702@cn.fujitsu.com>
References: <CAB3q875f4HFCaR9=yk0iCy7HF55tpt65q2+-fCuNbkSFHrey_A@mail.gmail.com>	<4EE69FD5.4040009@cn.fujitsu.com> <CAB3q874C0h1+W7t+8q-QNK7Kb2ujTrtHpD0WZkFaxjYbC9qJfg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Cc: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
To: Nik Markovic <nmarkovi.navteq@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAB3q874C0h1+W7t+8q-QNK7Kb2ujTrtHpD0WZkFaxjYbC9qJfg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Nik Markovic wrote:
> Li Zefan wrote:
>>
>> Nik Markovic wrote:
>>> Hi All,
>>>
>>> I have been encountering consistent btrfs filesystem crashes when
>>> using cp =96reflink=3Dalways on a large file and modifying it. I be=
lieve
>>> that the test file needs to be fairly large as I was not able to
>>> reproduce with smaller files. The filesystem size is 45GB and file
>>> size is 10GB.
>>>
>>
>> It should be fixed in 3.1 by this commit:
>>
>> commit b6f3409b2197e8fcedb43e6600e37b7cfbe0715b
>> Author: Sage Weil <sage@newdream.net>
>> Date:   Tue Sep 20 14:48:51 2011 -0400
>>
>>    Btrfs: reserve sufficient space for ioctl clone
>>
>>    Fix a crash/BUG_ON in the clone ioctl due to insufficient reserva=
tion. We
>>    need to reserve space for:
>>
>>     - adjusting the old extent (possibly splitting it)
>>     - adding the new extent
>>     - updating the inode
> Thanks Li,
>=20
> You are probably right. I upgraded to 3.2-rc5 today and was not able
> to reproduce with 100k iterations.
> Do you think that applying the same patch to 3.0 should fix this issu=
e in 3.0?
>=20

yes, it should be fine.
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
