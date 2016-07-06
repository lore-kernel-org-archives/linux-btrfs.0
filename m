Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36187 "EHLO
	mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751793AbcGFS3q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 6 Jul 2016 14:29:46 -0400
Received: by mail-qt0-f178.google.com with SMTP id w59so121004588qtd.3
        for <linux-btrfs@vger.kernel.org>; Wed, 06 Jul 2016 11:29:45 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRd-=RYAVWJBoVKPLU3-jx0T1oQgmhJwBM01j9zpFsUvg@mail.gmail.com>
References: <CAJCQCtRQBGNeCyENzTPT=yiqs3Tcc=aD8v6usKNtTnvyOd0uqw@mail.gmail.com>
 <20160705212706.719397fc@jupiter.sol.kaishome.de> <CAJCQCtRyvC6J=KJSVYRd1sOWPoVm69tA--3U8kAVdDynkziwNA@mail.gmail.com>
 <CAJCQCtS7OgKKzstJDz52Sd6+SJygDzoVzMhvwHqGxFmihr6Aqg@mail.gmail.com>
 <CAA91j0VbaRpt46tYf_oqd7fRuRn_ev-=Zxf_Bwiwd=TUHR+2Ow@mail.gmail.com>
 <CAJCQCtSZ=7v5PgD4mYKhayg03UfVqCV0ADBSjTsFDHiVcdxAjw@mail.gmail.com>
 <44c18e92-69b4-1409-1bf3-b1d08f6f84db@gmail.com> <CAJCQCtRd-=RYAVWJBoVKPLU3-jx0T1oQgmhJwBM01j9zpFsUvg@mail.gmail.com>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Date: Wed, 6 Jul 2016 21:29:44 +0300
Message-ID: <CAA91j0WN85uzYJWbUCXjWWyzg2JS_5or8dHh4PRvpgu3U6LeJA@mail.gmail.com>
Subject: Re: 64-btrfs.rules and degraded boot
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Kai Krakow <hurikhan77@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 6, 2016 at 9:23 PM, Chris Murphy <lists@colorremedies.com> wrote:
>>> [root@f24s ~]# btrfs fi show
>>> warning, device 2 is missing
>>> Label: none  uuid: 96240fd9-ea76-47e7-8cf4-05d3570ccfd7
>>>     Total devices 3 FS bytes used 2.26GiB
>>>     devid    3 size 50.00GiB used 3.01GiB path /dev/mapper/VG-3
>>>     *** Some devices missing
>>>
>>> [root@f24s ~]# btrfs device ready /dev/mapper/VG-3
>>> [root@f24s ~]#
>>
>> You won't get any output from it regardless, you have to check the return
>> code as it's intended to be a tool for scripts and such.
>
> How do I check the return code? When I use strace, no matter what I'm getting
>
> +++ exited with 0 +++
>
> I see both 'brfs device ready' and the udev btrfs builtin test are
> calling BTRFS_IOC_DEVICES_READY so, it looks like udev is not using
> user space tools to check but rather a btrfs ioctl.

Correct. It is possible that ioctl returns correct result only the
very first time; notice that in your example btrfs had seen all other
devices at least once while at boot it is really the case of other
devices missing so far.

Which returns us to the question - how we can reliably query kernel
about mountability of filesystem.

> So clearly that
> works or I wouldn't have stalled boots when all devices aren't
> present.
>
> --
> Chris Murphy
