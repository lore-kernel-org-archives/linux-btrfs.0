Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:51500 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750848Ab2JAUQa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Oct 2012 16:16:30 -0400
Received: by iagy32 with SMTP id y32so494862iag.19
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Oct 2012 13:16:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAG1y0sf=dN_p4BWHa5h=BjXnC7U+5D=01XEa1iFFzKdJJTFmyg@mail.gmail.com>
References: <1349098002.208.YahooMailNeo@web31801.mail.mud.yahoo.com>
	<50699A40.2030603@yahoo.com.br>
	<CAG1y0sf=dN_p4BWHa5h=BjXnC7U+5D=01XEa1iFFzKdJJTFmyg@mail.gmail.com>
Date: Mon, 1 Oct 2012 22:16:29 +0200
Message-ID: <CAFvQSYTySBdZrZkbp_SBPUzr_he=a5FM+caSyADoUt2DiADdvw@mail.gmail.com>
Subject: Re: Tunning - cache write (database)
From: Clemens Eisserer <linuxhippy@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I suggest you start by reading
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18827.html
>
> After that, PROBABLY start your database by preloading libeatmydata to
> disable fsync completely.

Which will cure the sympthoms, not the issue itself - I remember the
same advice was given for Reiser4 back then ;)
Usually for non-toy use-cases data is too valueable to just disable fsync.

- Clemens

2012/10/1 Fajar A. Nugraha <list@fajar.net>:
> On Mon, Oct 1, 2012 at 8:27 PM, Cesar Inacio Martins
> <cesar_inacio_martins@yahoo.com.br> wrote:
>
>> My problem:
>> * Using btrfs + compression , flush of 60 MB/s take 4 minutes....
>> (on this 4 minutes they keep constatly I/O of +- 4MB/s no disks)
>> (flush from Informix database)
>
>
>> * OpenSuse 12.1 64bits, running over VmWare ESXi 5
>> * Btrfs version : btrfsprogs-0.19-43.1.2.x86_64
>> * Kernel : Linux jdivm06 3.1.10-1.16-desktop #1 SMP PREEMPT Wed Jun 27
>
>
>> My question, what I believed will help to avoid this long flush :
>> * Have some way to force this flush all in memory cache and then use the
>> btrfs background process to flush to disk ...
>>   Security and recover aren't a priority for now, because this is part of a
>> database bulkload ...after finish , integrity will be desirable (not a
>> obligation, since this is a test environment)
>>
>> For now, performance is the mainly requirement...
>
>
> I suggest you start by reading
> http://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg18827.html
>
> After that, PROBABLY start your database by preloading libeatmydata to
> disable fsync completely.
>
> On a side note, zfs has "sync" property, which when set to "disabled",
> have pretty much the same effect as libeatmydata.
>
> --
> Fajar
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
