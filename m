From: 810d4rk <810d4rk@gmail.com>
Subject: Re: btrfs encryption problems
Date: Tue, 13 Mar 2012 15:50:20 +0000
Message-ID: <CAAVfQjm52wfJJGkkPZfeD6sTm_E-Xs4Uqf=53H_-hb6vDSTrGw@mail.gmail.com>
References: <CAAVfQj=O5nDAcgsiNHz3dNXHDerNrq2Jw01WFLJr5q563oZToA@mail.gmail.com>
 <20111123110956.GB31800@attic.humilis.net> <CAAVfQj=r-Op2ZUrq8YOchVV=0_LzNmdxjYd03nDHn+t=120YQw@mail.gmail.com>
 <20111124160617.680b676f@zougloub.eu> <CAAVfQj=gM7ikTzdFmi=yNpo9guukQwFyKfdu7jD=z-J2PwrZEg@mail.gmail.com>
 <20111124165429.10496040@Bidule> <CAAVfQjmmXnyCmXerCyymEQm-DhDxi0YSSo9sVSvkHE1WvJ4wYA@mail.gmail.com>
 <20111130134814.GW24338@shiny> <CAAVfQjk+O_3uLb=DShFwV2gVnLeDzQ45ebpMidDGFXZtqXJBbQ@mail.gmail.com>
 <CAG1y0scRTcpHxEnRHgeKgFtYgVYJdgMFydZfXmKEOnRQvUpcQA@mail.gmail.com>
 <CAAVfQjnHkovhOQcWcRGAXON6ywfBAFHuT9vwp8QBf8hVd+wkjw@mail.gmail.com>
 <CAAVfQjm03u6ZZTyvLGrz8VC7MebEkBzQ8Mo_Sqw2kmuEx427vg@mail.gmail.com>
 <CAKcLGm_scJ57cC1hHY4rmqTrqwOdndQDbBtj09UYMYYABLb2Tw@mail.gmail.com> <CAAVfQjkeH_umb41EoH4LRD_c15a7jxbR2N=6-3v9NcoHsiOR0Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "Fajar A. Nugraha" <list@fajar.net>,
	Chris Mason <chris.mason@oracle.com>,
	=?UTF-8?B?SsOpcsO0bWUgQ2FycmV0ZXJv?= <cJ-ko@zougloub.eu>,
	sander@humilis.net, linux-btrfs@vger.kernel.org
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAVfQjkeH_umb41EoH4LRD_c15a7jxbR2N=6-3v9NcoHsiOR0Q@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

I'm not having luck getting the encrypted btrfs back since the drive
the drive was unplugged during a write operation, the experimental
fsck with the repair option gives no valid btrfs found, mount gives
this:
sudo mount -t btrfs /dev/dm-1 /media/
mount: wrong fs type, bad option, bad superblock on
/dev/mapper/udisks-luks-uuid-269300fe-1329-42f8-b7fa-4a399a71d56f-uid10=
00,
missing codepage or helper program, or other error

There is nothing more to do to this?


On 23 December 2011 14:25, 810d4rk <810d4rk@gmail.com> wrote:
>> I've been using btrfs and luks encryption on my Acer netbook for abo=
ut
>> a year now. =C2=A0I haven't had an unmountable corruption on that co=
mputer
>> yet.
>>
>> What are your goals now?
>
> I would like to recover the data that is not in the backup.
>
>> Are you trying to recover data from this disk, or are you trying to
>> accomplish some debugging?
>
> I am trying to recover the data, also I think this bug needs to be fi=
xed.
>
>> Reviewing the thread, I don't see where you've run btrfsck on the
>> /dev/mapper/<entry>.
>>
>> Although btrfsck won't fix anything, it might give some insight as t=
he
>> the extent of the corruption.
>
> I have run it now and it says "No valid Btrfs found"
>
>
> --
> Thanks



--=20
Thanks
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
