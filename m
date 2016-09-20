Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f47.google.com ([209.85.215.47]:34242 "EHLO
        mail-lf0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752978AbcITJKy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Sep 2016 05:10:54 -0400
Received: by mail-lf0-f47.google.com with SMTP id y6so7903452lff.1
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Sep 2016 02:10:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEtw4r2XDvYUVRC5x=dcQbF8k3L5-7VcAHojhDPZP15+nvpuRQ@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <20160920065827.GO7138@carfax.org.uk> <CAEtw4r16f10PPsVw6r5t0KP-gJbSmKEYP-zt-s5De9kSBpZEqg@mail.gmail.com>
 <6596b749c3c4b37dc1db8c3a766be491@admin.virtall.com> <CAEtw4r1NW8Yg9KnGEuUtSe-NYVP-burkB0mDOdKLWsWQ4vy1rw@mail.gmail.com>
 <CAEtw4r1FYDkUxoOW-hrngBX5XD+AydiPY8B1eQv8a=dmA9B8eQ@mail.gmail.com>
 <20160920084838.GQ7138@carfax.org.uk> <CAEtw4r2XDvYUVRC5x=dcQbF8k3L5-7VcAHojhDPZP15+nvpuRQ@mail.gmail.com>
From: Peter Becker <floyd.net@gmail.com>
Date: Tue, 20 Sep 2016 11:10:51 +0200
Message-ID: <CAEtw4r0XzqUFhV5phiSH5+53eCq2S2EzQm7rJR+y-vjWYWpn+A@mail.gmail.com>
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
To: Hugo Mills <hugo@carfax.org.uk>, Peter Becker <floyd.net@gmail.com>,
        Tomasz Chmielewski <mangoo@wpkg.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Output from my nightly balance script for my 15 TB Raid 1 btrfs pool
(3x 3TB + 1x 6TB) with ~100 snapshots:

Before balance of /media/RAID
Data, RAID1: total=5.57TiB, used=5.45TiB
System, RAID1: total=32.00MiB, used=832.00KiB
Metadata, RAID1: total=7.00GiB, used=6.03GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
Filesystem      Size  Used Avail Use% Mounted on
/dev/sde        7.6T  6.1T  1.5T  81% /media/RAID
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=1
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=5
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=10
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=20
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=30
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=40
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x1, state 0x0, force is off
  DATA (flags 0x2): balancing, usage=50
Done, had to relocate 0 out of 5710 chunks
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=1
  SYSTEM (flags 0x2): balancing, usage=1
Done, had to relocate 0 out of 5710 chunks
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=5
  SYSTEM (flags 0x2): balancing, usage=5
Done, had to relocate 1 out of 5710 chunks
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=10
  SYSTEM (flags 0x2): balancing, usage=10
Done, had to relocate 1 out of 5710 chunks
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=20
  SYSTEM (flags 0x2): balancing, usage=20
Done, had to relocate 1 out of 5710 chunks
Dumping filters: flags 0x6, state 0x0, force is off
  METADATA (flags 0x2): balancing, usage=30
  SYSTEM (flags 0x2): balancing, usage=30
Done, had to relocate 1 out of 5710 chunks
After balance of /media/RAID
Data, RAID1: total=5.57TiB, used=5.45TiB
System, RAID1: total=32.00MiB, used=832.00KiB
Metadata, RAID1: total=7.00GiB, used=6.03GiB
GlobalReserve, single: total=512.00MiB, used=0.00B
Filesystem      Size  Used Avail Use% Mounted on
/dev/sde        7.6T  6.1T  1.5T  81% /media/RAID


Its effective reduce the internal fragmentation (to 0,12 TB data and
~1GB metadata).

2016-09-20 10:59 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
> 2016-09-20 10:48 GMT+02:00 Hugo Mills <hugo@carfax.org.uk>:
>> On Tue, Sep 20, 2016 at 10:34:49AM +0200, Peter Becker wrote:
>>> More details on the issue and a complete explantion you can find here:
>>>
>>> http://marc.merlins.org/perso/btrfs/post_2014-05-04_Fixing-Btrfs-Filesystem-Full-Problems.html
>>> and
>>> (Help! I ran out of disk space! )
>>> https://btrfs.wiki.kernel.org/index.php/FAQ#Help.21_I_ran_out_of_disk_space.21
>>>
>>> And an explantion for the "dlimit" solution:
>>
>>    It's not "dlimit". It's "d" with option "limit". You could just as
>> easily write -dusage=99,limit=10 or -dlimit=10,usage=99 (although
>> those aren't the options I'd pick... see below).
>>
>>> Quote From: Uncommon solutions for BTRFS
>>> (http://blog.schmorp.de/2015-10-08-smr-archive-drives-fast-now.html)
>>>
>>> > For my purposes, I define internal fragmentation as space allocated but not usable by the filesystem. In BTRFS, each time you delete files, the space used by those files cannot be reused for new files automatically.
>>> > It's not a hard requirement to do this maintenance regularly, but doing it regularly spares you waiting for hours when the disk is full and you need to wait for a balance clean up command - and of course also reduces the number of > times you get unexpected disk full errors. As a side note, this can also be useful to prolong the life of your SSD because it allows the SSD to reuse space not needed by the filesystem (although there is a trade-off, frequent balancing is bad, no balancing is bad, the sweet spot is somewhere in between).
>>>
>>> 2016-09-20 10:20 GMT+02:00 Peter Becker <floyd.net@gmail.com>:
>>> > Normaly total and used should deviate us a few gb.
>>> > depend on your write workload you should run
>>> >
>>> > btrfs balance start -dusage=60 /mnt
>>> >
>>> > every week to avoid "ENOSPC"
>>> >
>>> > if you use newer btrfs-progs who supper balance limit filters you should run
>>> >
>>> > btrfs balance start -dusage=99 -dlimit=10 /mnt
>>> >
>>> > every 3 hours.
>>
>>    These two options both feel horrible to me. Particularly the second
>> option, which is going to result in huge write load on the FS, and is
>> almost certainly going to be unnecessary most of the time.
>
> I take this from kdave's btrfs maintence scripts and this works for me
> since one year. (https://github.com/kdave/btrfsmaintenance)
>
>>    My recommendation would be to check at regular intervals (daily,
>> say) whether the used value is equal to the size value in btrfs fi
>> show. If it is (and only if), then you should run a balance with no
>> usage= option, and with limit=<n>, for some relatively small value of
>> <n> (3, say). That will give you some unallocated space that the FS
>> can take for metadata should it need it, which is all that's required
>> to avoid early ENOSPC.
>
> With no usage-option, how to avoid balance full blocks? -dusage=99
> only balance blocks with empty space.
>
>>    If you regularly find that your usage patterns result in large
>> numbers of empty or near-empty block groups (i.e. lots of headroom in
>> data shown by btrfs fi df), then a regular (but probably less
>> frequent) balance with something like usage=5 should keep that down.
>>
>>> > This will balance 2 Blocks (dlimit=10; corresponds to 10 gb) with are
>>
>>    No, it will balance 10 complete block groups, not 10 GiB. Depending
>> on the RAID configuration, that could be a very large amount of data
>> indeed. (For example, an 8-disk RAID-10 would be rewriting up to 80
>> GiB of data with that command).
>
> Thanks for this clarification.
