From: Chester <somethingsome2000@gmail.com>
Subject: Re: Extreme slowdown
Date: Thu, 15 Dec 2011 21:44:00 -0600
Message-ID: <CAAE6i0jL=mD=HU0GtfpJPLu__7NtV6WAuGb25CAWtV6N4f33wQ@mail.gmail.com>
References: <4EEA4124.20907@robotech.de> <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Tobias <tracer@robotech.de>,
	Linux Btrfs <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0sd1+kVcgXFPc-x9qFX03ix=4FLuhOniJyqGw-7=3wczug@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 15, 2011 at 8:19 PM, Fajar A. Nugraha <list@fajar.net> wrot=
e:
> On Fri, Dec 16, 2011 at 1:49 AM, Tobias <tracer@robotech.de> wrote:
>> Hi all!
>>
>> My BTRFS-FS ist getting really slow. Reading is ok, writing is slow =
and
>> deleting is horrible slow.
>>
>> There are many files and many links on the FS.
>>
>> # btrfs filesystem df /srv/storage
>> Data: total=3D3.09TB, used=3D3.07TB
>
> this is ... what, over 99% full?
> The slow down is normal, somewhat. Same thing happens on zfs, which
> became slower when usage is above 80-90%.

I don't think "total" actually means "total space available" it
increases as you use up more space.
>
>> Maybe it's because there is so much Metadata and it needs so many se=
eks on
>> the discs when deleting?
>
> I doubt it.
>
>> I'd like to delete some of the old Files but its so horrible slow th=
at i
>> think its maybe faster to copy all needed Data to a different Disc, =
killing
>> the FS and move the Files back...
>>
>> The machine is a QuadCore with 8GB RAM. Kernel is "3.1+for-linus".
>>
>> Any hints how i could speed it up?
>
> Try:
> - mounting it with nodatacow:
> https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#Can_copy-o=
n-write_be_turned_off_for_data_blocks.3F
> - clobbering a big file:
> https://btrfs.wiki.kernel.org/articles/f/a/q/FAQ_1fe9.html#if_your_de=
vice_is_large_.28.3E16gb.29
>
> ... until you have at least 20% free space available.
>
> --
> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
