From: Alexander Beregalov <a.beregalov@gmail.com>
Subject: Re: btrfsck: checksum verify failed
Date: Thu, 12 Nov 2009 18:43:00 +0300
Message-ID: <a4423d670911120743o3759d594v533bc6ff8cdedd9@mail.gmail.com>
References: <a4423d670911111808i3affd6d4q4aa14c6086d9c28f@mail.gmail.com>
	 <20091112140233.GB5211@think>
	 <a4423d670911120616k2538809erc006c26fe86eb14d@mail.gmail.com>
	 <20091112145051.GB3196@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Chris Mason <chris.mason@oracle.com>,
	Alexander Beregalov <a.beregalov@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091112145051.GB3196@think>
List-ID: <linux-btrfs.vger.kernel.org>

2009/11/12 Chris Mason <chris.mason@oracle.com>:
> On Thu, Nov 12, 2009 at 05:16:34PM +0300, Alexander Beregalov wrote:
>> 2009/11/12 Chris Mason <chris.mason@oracle.com>:
>> > On Thu, Nov 12, 2009 at 05:08:53AM +0300, Alexander Beregalov wrot=
e:
>> >> # for i in `seq 1 20`; do btrfsck /dev/sde|grep "checksum verify
>> >> failed";echo; done
>> >> checksum verify failed on 31945617408 wanted 6607632D found 9CC3E=
D0
>> >> checksum verify failed on 31945617408 wanted 6607632D found AFBBF=
41
>> >
>> > Was your filesystem mounted at the time? =C2=A0It's strange that t=
he checksum
>> > keeps changing, that points to the data in the block changing.
>>
>> It was not.
>> Any tips how I can try to find a root cause?
>> It is raid0 of two disks.
>
> Well, I'd start by looking for anything else that could be touching t=
he
> FS or the devices. =C2=A0You shouldn't see more than two different cs=
ums in this
> configuration (one from each disk).
I always see only these two blocks in output.
>
> Somehow the disk is giving us different answers each time, which poin=
ts
> to a problem in the storage stack.
Hm, I will try to check discs by "badblocks" with few cycles of write-r=
ead.
>
> Otherwise it is possible that block 31945617408 is multiply linked an=
d
> is actually in use somehow else. =C2=A0btrfsck is a readonly operatio=
n
> though, it doesn't change the FS while it is running.

Can it be a bug in the filesystem itself - in checksum calculation
code, wrong pointer to data or something else?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
