Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37952 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933345AbcDLTBn (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 15:01:43 -0400
Received: by mail-wm0-f53.google.com with SMTP id u206so40421582wme.1
        for <linux-btrfs@vger.kernel.org>; Tue, 12 Apr 2016 12:01:42 -0700 (PDT)
Received: from [192.168.2.105] (p4FD979C9.dip0.t-ipconnect.de. [79.217.121.201])
        by smtp.googlemail.com with ESMTPSA id jk1sm34791508wjb.27.2016.04.12.12.01.40
        for <linux-btrfs@vger.kernel.org>
        (version=TLSv1/SSLv3 cipher=OTHER);
        Tue, 12 Apr 2016 12:01:40 -0700 (PDT)
Subject: Re: enospace regression in 4.4
References: <570CCCFB.5000104@googlemail.com>
 <570D19D9.8030702@googlemail.com>
 <CAPmG0jbOTFvQ83Qrf=ut5YiGUBtkhGMDr1nQdicB+MsVbwE2Qg@mail.gmail.com>
From: Julian Taylor <jtaylor.debian@googlemail.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <570D4612.2080000@googlemail.com>
Date: Tue, 12 Apr 2016 21:01:38 +0200
MIME-Version: 1.0
In-Reply-To: <CAPmG0jbOTFvQ83Qrf=ut5YiGUBtkhGMDr1nQdicB+MsVbwE2Qg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12.04.2016 20:09, Henk Slager wrote:
> On Tue, Apr 12, 2016 at 5:52 PM, Julian Taylor
> <jtaylor.debian@googlemail.com> wrote:
>> smaller testcase that shows the immediate enospc after fallocate -> rm,
>> though I don't know if it is really related to the full filesystem
>> bugging out as the balance does work if you wait a few seconds after the
>> balance.
>> But this sequence of commands did work in 4.2.
>>
>>  $ sudo btrfs fi show /dev/mapper/lvm-testing
>> Label: none  uuid: 25889ba9-a957-415a-83b0-e34a62cb3212
>>         Total devices 1 FS bytes used 225.18MiB
>>         devid    1 size 5.00GiB used 788.00MiB path /dev/mapper/lvm-testing
>>
>>  $ fallocate -l 4.4G test.dat
>>  $ rm -f test.dat
>>  $ sudo btrfs fi balance start -dusage=0 .
>> ERROR: error during balancing '.': No space left on device
>> There may be more info in syslog - try dmesg | tail
> 
> It seems that kernel 4.4.6 waits longer with de-allocating empty
> chunks and the balance kicks in at a time when the 5 GiB is still
> completely filled with chunks. As balance needs uncallocated space (on
> device level, how much depends on profiles), this error can be
> expected.

hm ok, I'll put a sleep in the script then.
fallocate; rm; fallocate seems to work so its probably ok in normal usage.


> 
>> On 04/12/2016 12:24 PM, Julian Taylor wrote:
>>> hi,
>>> I have a system with two filesystems which are both affected by the
>>> notorious enospace bug when there is plenty of unallocated space
>>> available. The system is a raid0 on two 900 GiB disks and an iscsi
>>> single/dup 1.4TiB.
>>> To deal with the problem I use a cronjob that uses fallocate to give me
>>> an advance notice on the issue so I can apply the only workaround that
>>> works for me, which is shrink the fs to the minimum and grow it again.
>>> This has worked fine for a couple of month.
>>>
>>> I now updated from 4.2 to 4.4.6 and it appears my cronjob actually
>>> triggers an immediate enospc in the balance after removing the
>>> fallocated file and the shrink/resize workaround does not work anymore.
> 
> The filesystem itself is not resized AFAIU, correct?

btrfs resize -XG /mount
so resize filesystem but not the underlying device.

Actually the system just went into enospc again with unallocated free
even after the revert to 4.2 and the shrink trick doesn't want to work
anymore either ...
Though the 4.2 running now is not the same where the shrink workaround
work. I'll have to check the changelog to see if there are btrfs related
changes in it.


> 
> You could shrink a file-system by a few GiB's (without changing the
> size of the underlying device), so that once it really gets filled up
> and hits enospc, you resize to max again and delete files or snapshot
> or something. Of course no option for a 24/7 unattended system, but
> maybe for a client laptop as testing.
> 

that us basically what I have been doing, I used the cronjob to see when
the enospc issue occurred and then resize shrink to fix it. It was
relatively rare, I had to do it maybe every two month.

But now for some reason that trick doesn't work anymore either, I can
shrink it by 200G and resize it back to max and it still complains about
no free space. So now I'm at a loss on how to keep this system working.
