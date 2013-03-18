Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45018 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab3CRXjH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Mar 2013 19:39:07 -0400
Received: by mail-ee0-f43.google.com with SMTP id c50so2803337eek.30
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Mar 2013 16:39:05 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABzOi+ea8fchPK82Xzm95BfS76cWvZ6pAR5m5txkFcjUZN9oJg@mail.gmail.com>
References: <CABzOi+d9ku3xJwQLZanBsagWmcd54Uf-oUuApTqkwguFTaHyYg@mail.gmail.com>
	<CAE5mzvi5nsTDw9ZX72hXt2EMsmxJUef3WmvArxxKhqJFJU-CLg@mail.gmail.com>
	<CABzOi+c0e4Oq8=Y2gdRsh5=X=P6kVQubGS2qXE+vbodnzfeoMw@mail.gmail.com>
	<CABzOi+ea8fchPK82Xzm95BfS76cWvZ6pAR5m5txkFcjUZN9oJg@mail.gmail.com>
Date: Mon, 18 Mar 2013 16:39:05 -0700
Message-ID: <CAHGunUkhUjhgzfsdt4y91MF_Wt7tN0xK+f3C+0CAyQgC39vVMQ@mail.gmail.com>
Subject: Re: Btrfs in multiple different disc -d sigle -m raid1 one drive failure...
From: Michael Johnson - MJ <mj@revmj.com>
To: Jan Beranek <jan233321@gmail.com>
Cc: cwillu <cwillu@cwillu.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

While in specific use cases it may be preferable to fill up one disk
and then move on to the next, that does not get you the best
performance, so I suspect you will be hard pressed to find any "real"
filesystem that behaves in such a way.  You may be able to do that
with aufs, but if you you want to limit data loss in the event of a
failure, you probably want to always write to the disk with the most
free space which aufs can do.

On Mon, Mar 18, 2013 at 1:04 PM, Jan Beranek <jan233321@gmail.com> wrote:
> Thank you for the test.
>
> I will do some tests also (later as now I do not have a space for it)
> - when you disconnected one disc (or deleted a file) did you try btrfs
> fi balance? I wonder if missing files simply "disappears" or not,
> because in the fact they are present as metadata information only. if
> not, then would be necessary to  write a small script which will check
> all the files and report missing/broken ones (or use aufs on top).
>
> When I use "-d single" option, then preffered way is fill the disc
> completelly and then continue with another disc. And you are right,
> there is no guarantee that some files wil not be spread over all three
> (or more) disc. (as I understand it from docs).
>
> On Mon, Mar 18, 2013 at 9:03 PM, Jan Beranek <jan233321@gmail.com> wrote:
>> Thank you for your test.
>>
>> I will do some tests also (later as now I do not have a space for it) - when
>> you disconnected one disc (or deleted a file) did you try btrfs fi balance?
>> I wonder if missing files simply "disappears" or not, because in the fact
>> they are present as metadata information only. if not, then would be
>> necessary to  write a small script which will check all the files and report
>> missing/broken ones (or use aufs on top).
>>
>> When I use "-d single" option, then preffered way is fill the disc
>> completelly and then continue with another disc. And you are right, there is
>> no guarantee that some files wil not be spread over all three (or more)
>> disc. (as I understand it from docs).
>>
>>
>> On Mon, Mar 18, 2013 at 8:24 PM, cwillu <cwillu@cwillu.com> wrote:
>>>
>>> On Mon, Mar 18, 2013 at 12:32 PM, Jan Beranek <jan233321@gmail.com> wrote:
>>> > Hi all,
>>> > I'm preparing a strorage pool for large data with quite low importance
>>> > - there will be at least 3 hdd in "-d single" and "-m raid1"
>>> > configuration.
>>> >
>>> > mkfs.btrfs -d single -m raid1 /dev/sda /dev/sdb /dec/sdc
>>> >
>>> > What happen if one hdd fails? Do I lost everything from all three
>>> > discs or only data from one disc? (if from only one disc, then is it
>>> > acceptable otherwise not...)
>>>
>>> I just finished doing some testing to check:  It will work, kinda sorta.
>>>
>>> You'll be forced to mount read-only, and any reads of file extents
>>> that existed on the missing disk will return an io error.  As I
>>> understand it, single doesn't force files to be on a single disk,
>>> instead it _doesn't_ force them to be _several_ disks; the implication
>>> being that a large file (say, a 4gb movie) may still end up with
>>> pieces on each disk.
>>
>>
>>
>>
>> --
>> S pozdravem
>>
>> Jan Beránek
>
>
>
> --
> S pozdravem
>
> Jan Beránek
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Michael Johnson - MJ
