Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:35157 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751823AbbIOTNK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 15:13:10 -0400
Received: by ioiz6 with SMTP id z6so208749795ioi.2
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Sep 2015 12:13:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <55F86B8D.9050605@gmail.com>
References: <CALq_kZHBx8hR_6kfwYgJChdK2RKw1+up07pGGYe+RRGOb2rhKA@mail.gmail.com>
 <55F8643F.5070701@gmail.com> <CALq_kZGHM2D7-XhrMbkhik2Hn=CWJGPBjbGrJWqS32k7nQEZ3g@mail.gmail.com>
 <55F86784.6060707@gmail.com> <CALq_kZEf9q9Lrbk32qKhdeuE4B=X2nah9Db9YmD6Y5Xk_Fg32w@mail.gmail.com>
 <55F86B8D.9050605@gmail.com>
From: Tyler Williams <williams.tlr@gmail.com>
Date: Tue, 15 Sep 2015 13:12:29 -0600
Message-ID: <CALq_kZEw+_Og9fuj5d8AncB1Qz+zKue4KV8ZqOivH-9W4iEBKw@mail.gmail.com>
Subject: Re: btrfs kernel warning
To: Austin S Hemmelgarn <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Fantastic. Thanks a ton

On Tue, Sep 15, 2015 at 1:03 PM, Austin S Hemmelgarn
<ahferroin7@gmail.com> wrote:
> On 2015-09-15 14:53, Tyler Williams wrote:
>>
>> I'll give that a shot. This will be a lame questions, but what address
>> to I need to reply to for these messages to make it to the mailing
>> list? It looks like I'm replying to you instead of to the mailing list
>> itself. Thanks
>
> It's not a lame question at all, it's a very sensible one.
> The easy option is to use 'Reply All' or 'Reply List' if your e-mail client
> supports it.  For some rather stupid reason, some mail clients don't support
> this properly, in which case you have to use the regular Reply button and
> add in the rest of the To and Cc addresses from the original mail (and then
> optionally complain to the developers of your e-mail client that it doesn't
> support functionality that's been standard since before the year 2000).
>
>> On Tue, Sep 15, 2015 at 12:46 PM, Austin S Hemmelgarn
>> <ahferroin7@gmail.com> wrote:
>>>
>>> On 2015-09-15 14:42, Tyler Williams wrote:
>>>>
>>>>
>>>> So I only had qgroups enabled because at some point it seemed like it
>>>> gave me the size of individual snapshots. Would it be likely that if I
>>>> just removed qgroups from that volume that would prevent that message
>>>> in the future?
>>>>
>>> Maybe, I'm not entirely certain if disabling qgroups on a volume removes
>>> the
>>> qgroup metadata, and if the metadata is still there, it might still cause
>>> issues.  It's worth trying though because it shouldn't make anything
>>> worse
>>> than it already is.
>>>
>>>> On Tue, Sep 15, 2015 at 12:32 PM, Austin S Hemmelgarn
>>>> <ahferroin7@gmail.com> wrote:
>>>>>
>>>>>
>>>>> On 2015-09-15 14:13, Tyler Williams wrote:
>>>>>>
>>>>>>
>>>>>>
>>>>>> I've received several kernel warnings over the last few weeks. I
>>>>>> checked on the #BTRFS irc channel and it was suggested that I post the
>>>>>> relevant information here to see if this was something that I should
>>>>>> be worried about.
>>>>>>
>>>>>>
>>>>>> [root@tawilliams ~]# uname -a
>>>>>> Linux tawilliams.williamstlr.net 4.1.6-201.fc22.x86_64 #1 SMP Fri Sep
>>>>>> 4 17:49:24 UTC 2015 x86_64 x86_64 x86_64 GNU/Linux
>>>>>>
>>>>>>
>>>>>> [root@tawilliams ~]# btrfs --version
>>>>>> btrfs-progs v4.1
>>>>>>
>>>>>>
>>>>>> [root@tawilliams ~]# btrfs fi sh
>>>>>> Label: 'fedora'  uuid: 1e37c117-d493-4d3e-a585-46b90de16569
>>>>>>            Total devices 1 FS bytes used 3.70GiB
>>>>>>            devid    1 size 47.31GiB used 6.04GiB path /dev/sda4
>>>>>>
>>>>>> Label: none  uuid: f9b38a56-44d4-4974-9640-95341bd8ae6a
>>>>>>            Total devices 1 FS bytes used 424.23GiB
>>>>>>            devid    1 size 931.51GiB used 428.04GiB path /dev/sdc1
>>>>>>
>>>>>> Label: none  uuid: 5266d71b-1d75-4b28-accc-95187f2d65a4
>>>>>>            Total devices 1 FS bytes used 889.09GiB
>>>>>>            devid    1 size 931.50GiB used 892.03GiB path /dev/sdb2
>>>>>>
>>>>>> Label: 'tawilliams'  uuid: 142b1866-f5e1-48b0-acd3-401e8eb4d219
>>>>>>            Total devices 2 FS bytes used 1.10TiB
>>>>>>            devid    1 size 1.82TiB used 1.16TiB path /dev/sdb1
>>>>>>            devid    2 size 1.82TiB used 1.16TiB path /dev/sde
>>>>>>
>>>>>> Label: 'fedora-server'  uuid: a5a82150-7ff3-43d4-a86b-a7f9d2df3737
>>>>>>            Total devices 1 FS bytes used 27.09GiB
>>>>>>            devid    1 size 47.51GiB used 38.81GiB path /dev/sdd3
>>>>>>
>>>>>> btrfs-progs v4.1
>>>>>>
>>>>>> [root@tawilliams ~]# btrfs fi df /media/btrfs-raid1/
>>>>>> Data, RAID1: total=1.16TiB, used=1.10TiB
>>>>>> System, RAID1: total=32.00MiB, used=208.00KiB
>>>>>> Metadata, RAID1: total=5.00GiB, used=3.86GiB
>>>>>> GlobalReserve, single: total=512.00MiB, used=0.00B
>>>>>>
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: ------------[ cut
>>>>>> here ]------------
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: WARNING: CPU: 0
>>>>>> PID: 544 at fs/btrfs/qgroup.c:1028
>>>>>> __qgroup_excl_accounting+0x1cf/0x260 [btrfs]()
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Modules linked in:
>>>>>> nf_conntrack_netbios_ns nf_conntrack_broadcast ip6t_rpfilter
>>>>>> ip6t_REJECT nf_reject_ipv6 xt_conntrack ebtable_nat ebtable_broute
>>>>>> bridg
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: CPU: 0 PID: 544
>>>>>> Comm: btrfs-cleaner Not tainted 4.1.6-201.fc22.x86_64 #1
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Hardware name:
>>>>>> Microsoft Corporation Virtual Machine/Virtual Machine, BIOS Hyper-V
>>>>>> UEFI Release v1.0 11/26/2012
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>>>>> 000000005a7148da ffff8800383f7b38 ffffffff81799a6d
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>>>>> 0000000000000000 ffff8800383f7b78 ffffffff810a165a
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:  0000000000000000
>>>>>> ffff880036e71048 ffff880022079960 ffffffffffffc000
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: Call Trace:
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff81799a6d>] dump_stack+0x45/0x57
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff810a165a>] warn_slowpath_common+0x8a/0xc0
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff810a178a>] warn_slowpath_null+0x1a/0x20
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa01341af>] __qgroup_excl_accounting+0x1cf/0x260 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa01372ec>] btrfs_delayed_qgroup_accounting+0x2dc/0xc70
>>>>>> [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00b6a67>] ? walk_up_proc+0xd7/0x500 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00ba85f>] btrfs_run_delayed_refs.part.68+0x20f/0x280
>>>>>> [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00ba8e5>] btrfs_run_delayed_refs+0x15/0x30 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00cb68a>] btrfs_should_end_transaction+0x5a/0x60 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00b8c85>] btrfs_drop_snapshot+0x455/0x8a0 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa01276cc>] ? btrfs_kill_all_delayed_nodes+0x5c/0x110 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00df11f>] ? btrfs_run_defrag_inodes+0x29f/0x360 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00cbb82>] btrfs_clean_one_deleted_snapshot+0xb2/0x110
>>>>>> [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00c3dc5>] cleaner_kthread+0xb5/0x1b0 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffffa00c3d10>] ? check_leaf+0x380/0x380 [btrfs]
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff810c0bf8>] kthread+0xd8/0xf0
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff810c0b20>] ? kthread_worker_fn+0x180/0x180
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff817a0422>] ret_from_fork+0x42/0x70
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel:
>>>>>> [<ffffffff810c0b20>] ? kthread_worker_fn+0x180/0x180
>>>>>> Sep 15 10:45:16 tawilliams.williamstlr.net kernel: ---[ end trace
>>>>>> e8c2f252933902d6 ]---
>>>>>
>>>>>
>>>>>
>>>>> While I can't provide any advice as to whether this is something to be
>>>>> worried about or not, I would like to point out that even in recent
>>>>> kernel
>>>>> versions, there are multiple known issues in the qgroup code.  I don't
>>>>> think
>>>>> there's anything currently known on 4.1.6 that has the possibility of
>>>>> eating
>>>>> your data, but I am by no means an expert on this particular subject (I
>>>>> don't use quotas on most of my systems, and for those that I do, I just
>>>>> use
>>>>> separate thinly-provisioned partitions for the individual quota users
>>>>> (which
>>>>> in turn makes things much easier for everyone involved)).
>>>>>
>>>>>
>>>
>>>
>
>
