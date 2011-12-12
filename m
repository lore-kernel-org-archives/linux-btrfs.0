From: David Marcin <djmarcin@gmail.com>
Subject: Re: BUG during btrfs device delete missing
Date: Mon, 12 Dec 2011 13:39:37 -0800
Message-ID: <CAHh_JMOyrC76pe1ZyeZJWgY+51LVq57KDD6vPO32L1JQx5r-sQ@mail.gmail.com>
References: <CAHh_JMPvmRNRrhh0aQhQiej+NP4Vb36MbFtECFphc8cUM9B=ZQ@mail.gmail.com>
 <CAHh_JMOxrqLRC2ad5n3DuArL1hQdNiixO7jd8StYSKLkbLUB7A@mail.gmail.com>
 <20111208194556.GS8971@shiny> <CAHh_JMOfLyHV=BSnW8J=8tn6huH0A2AvKqk6+WdOLCdG6zqkAA@mail.gmail.com>
 <20111209165206.GE8971@shiny> <4EE421EA.60809@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>, linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE421EA.60809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 10, 2011 at 7:22 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>>>> On Thu, Dec 08, 2011 at 11:06:47AM -0800, David Marcin wrote:
>>>>> raid10 metadata and data filesystem. =A0dmesg log follows. =A0The=
 system
>>>>> is unable to unmount the filesystem after this occurs.
>>>>>
>>>>> Filesystem mounted at/mnt/btrfs with -o compress,degraded
>>>>> Command: btrfs device delete missing /mnt/btrfs
>>>>>
>>>>> [ =A0283.398222] ------------[ cut here ]------------
>>>>> [ =A0283.398289] kernel BUG at /home/apw/COD/linux/fs/btrfs/trans=
action.c:1329!
>>
>> So this crash means we failed to write all the blocks required to co=
mmit
>> the transaction. =A0The reason is that we're getting failed bios to =
the
>> missing device, and that failure isn't properly eaten by the
>> raid aware endio code.
>>
>> If you pull the top commit from my for-linus branch, it should all w=
ork.
>>
>> I know you've got a big FS here, I haven't tested this on raid10 yet=
,
>> only raid1. =A0If you want to wait a bit for safety I'll do a raid10=
 run
>> too.
>>
>
> The fix looks good to me, and I've tested it on raid10.

Thanks Chris and Li.  I can confirm that this fixed my issues on raid10=
 as well.

David
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
