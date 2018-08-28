Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lj1-f182.google.com ([209.85.208.182]:44814 "EHLO
        mail-lj1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725198AbeH1E1S (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 28 Aug 2018 00:27:18 -0400
Received: by mail-lj1-f182.google.com with SMTP id q127-v6so624723ljq.11
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 17:38:16 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
References: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
 <CAJCQCtSq5K90gpfGQN8JhqQddBg62m8EG_bFuWN5XyzdNStDfw@mail.gmail.com> <CAN4oSBeHwnsm5Ecz1hAQLk6s6utHfn5XeR8xMhnZpmT-sb-_iw@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 27 Aug 2018 18:38:14 -0600
Message-ID: <CAJCQCtQ=CiB5cY8RL4tzps21d=umjzNM=BKjdUBCc7WiP0QF9A@mail.gmail.com>
Subject: Re: DRDY errors are not consistent with scrub results
To: Cerem Cem ASLAN <ceremcem@ceremcem.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 27, 2018 at 6:05 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
> Note that I've directly received this reply, not by mail list. I'm not
> sure this is intended or not.

I intended to do Reply to All but somehow this doesn't always work out
between the user and Gmail, I'm just gonna assume gmail is being an
asshole again.


> Chris Murphy <lists@colorremedies.com>, 28 Ağu 2018 Sal, 02:25
> tarihinde şunu yazdı:
>>
>> On Mon, Aug 27, 2018 at 4:51 PM, Cerem Cem ASLAN <ceremcem@ceremcem.net> wrote:
>> > Hi,
>> >
>> > I'm getting DRDY ERR messages which causes system crash on the server:
>> >
>> > # tail -n 40 /var/log/kern.log.1
>> > Aug 24 21:04:55 aea3 kernel: [  939.228059] lxc-bridge: port
>> > 5(vethI7JDHN) entered disabled state
>> > Aug 24 21:04:55 aea3 kernel: [  939.300602] eth0: renamed from vethQ5Y2OF
>> > Aug 24 21:04:55 aea3 kernel: [  939.328245] IPv6: ADDRCONF(NETDEV_UP):
>> > eth0: link is not ready
>> > Aug 24 21:04:55 aea3 kernel: [  939.328453] IPv6:
>> > ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
>> > Aug 24 21:04:55 aea3 kernel: [  939.328474] IPv6:
>> > ADDRCONF(NETDEV_CHANGE): vethI7JDHN: link becomes ready
>> > Aug 24 21:04:55 aea3 kernel: [  939.328491] lxc-bridge: port
>> > 5(vethI7JDHN) entered blocking state
>> > Aug 24 21:04:55 aea3 kernel: [  939.328493] lxc-bridge: port
>> > 5(vethI7JDHN) entered forwarding state
>> > Aug 24 21:04:59 aea3 kernel: [  943.085647] cgroup: cgroup2: unknown
>> > option "nsdelegate"
>> > Aug 24 21:16:15 aea3 kernel: [ 1619.400016] perf: interrupt took too
>> > long (2506 > 2500), lowering kernel.perf_event_max_sample_rate to
>> > 79750
>> > Aug 24 21:17:11 aea3 kernel: [ 1675.515815] perf: interrupt took too
>> > long (3137 > 3132), lowering kernel.perf_event_max_sample_rate to
>> > 63750
>> > Aug 24 21:17:13 aea3 kernel: [ 1677.080837] cgroup: cgroup2: unknown
>> > option "nsdelegate"
>> > Aug 25 22:38:31 aea3 kernel: [92955.512098] usb 4-2: USB disconnect,
>> > device number 2
>> > Aug 26 02:14:21 aea3 kernel: [105906.035038] lxc-bridge: port
>> > 4(vethCTKU4K) entered disabled state
>> > Aug 26 02:15:30 aea3 kernel: [105974.107521] lxc-bridge: port
>> > 4(vethO59BPD) entered disabled state
>> > Aug 26 02:15:30 aea3 kernel: [105974.109991] device vethO59BPD left
>> > promiscuous mode
>> > Aug 26 02:15:30 aea3 kernel: [105974.109995] lxc-bridge: port
>> > 4(vethO59BPD) entered disabled state
>> > Aug 26 02:15:30 aea3 kernel: [105974.710490] lxc-bridge: port
>> > 4(vethBAYODL) entered blocking state
>> > Aug 26 02:15:30 aea3 kernel: [105974.710493] lxc-bridge: port
>> > 4(vethBAYODL) entered disabled state
>> > Aug 26 02:15:30 aea3 kernel: [105974.710545] device vethBAYODL entered
>> > promiscuous mode
>> > Aug 26 02:15:30 aea3 kernel: [105974.710598] IPv6:
>> > ADDRCONF(NETDEV_UP): vethBAYODL: link is not ready
>> > Aug 26 02:15:30 aea3 kernel: [105974.710600] lxc-bridge: port
>> > 4(vethBAYODL) entered blocking state
>> > Aug 26 02:15:30 aea3 kernel: [105974.710601] lxc-bridge: port
>> > 4(vethBAYODL) entered forwarding state
>> > Aug 26 02:16:35 aea3 kernel: [106039.674089] BTRFS: device fsid
>> > 5b844c7a-0cbd-40a7-a8e3-6bc636aba033 devid 1 transid 984 /dev/dm-3
>> > Aug 26 02:17:21 aea3 kernel: [106085.352453] ata4.00: failed command: READ DMA
>> > Aug 26 02:17:21 aea3 kernel: [106085.352901] ata4.00: status: { DRDY ERR }
>> > Aug 26 02:18:56 aea3 kernel: [106180.648062] ata4.00: exception Emask
>> > 0x0 SAct 0x0 SErr 0x0 action 0x0
>> > Aug 26 02:18:56 aea3 kernel: [106180.648333] ata4.00: BMDMA stat 0x25
>> > Aug 26 02:18:56 aea3 kernel: [106180.648515] ata4.00: failed command: READ DMA
>> > Aug 26 02:18:56 aea3 kernel: [106180.648706] ata4.00: cmd
>> > c8/00:08:80:9c:bb/00:00:00:00:00/e3 tag 0 dma 4096 in
>> > Aug 26 02:18:56 aea3 kernel: [106180.648706]          res
>> > 51/40:00:80:9c:bb/00:00:00:00:00/03 Emask 0x9 (media error)
>> > Aug 26 02:18:56 aea3 kernel: [106180.649380] ata4.00: status: { DRDY ERR }
>> > Aug 26 02:18:56 aea3 kernel: [106180.649743] ata4.00: error: { UNC }
>>
>> Classic case of uncorrectable read error due to sector failure.
>>
>>
>>
>> > Aug 26 02:18:56 aea3 kernel: [106180.779311] ata4.00: configured for UDMA/133
>> > Aug 26 02:18:56 aea3 kernel: [106180.779331] sd 3:0:0:0: [sda] tag#0
>> > FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
>> > Aug 26 02:18:56 aea3 kernel: [106180.779335] sd 3:0:0:0: [sda] tag#0
>> > Sense Key : Medium Error [current]
>> > Aug 26 02:18:56 aea3 kernel: [106180.779339] sd 3:0:0:0: [sda] tag#0
>> > Add. Sense: Unrecovered read error - auto reallocate failed
>> > Aug 26 02:18:56 aea3 kernel: [106180.779343] sd 3:0:0:0: [sda] tag#0
>> > CDB: Read(10) 28 00 03 bb 9c 80 00 00 08 00
>> > Aug 26 02:18:56 aea3 kernel: [106180.779346] blk_update_request: I/O
>> > error, dev sda, sector 62626944
>>
>> And the drive has reported the physical sector that's failing.
>>
>>
>>
>> > Aug 26 02:18:56 aea3 kernel: [106180.779703] BTRFS error (device
>> > dm-2): bdev /dev/mapper/master-root errs: wr 0, rd 40, flush 0,
>> > corrupt 0, gen 0
>> > Aug 26 02:18:56 aea3 kernel: [106180.779936] ata4: EH complete
>>
>> And Btrfs reports it as a read error. Is this a single drive setup?
>
> Yes, this is a single drive setup.
>
>> And what's the profile for metadata and data?
>
> sudo btrfs fi usage /mnt/peynir/
> [sudo] password for aea:
> Overall:
>     Device size:                 931.32GiB
>     Device allocated:             16.08GiB
>     Device unallocated:          915.24GiB
>     Device missing:                  0.00B
>     Used:                         12.53GiB
>     Free (estimated):            915.81GiB      (min: 458.19GiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:               43.94MiB      (used: 2.45MiB)
>
> Data,single: Size:12.01GiB, Used:11.43GiB
>    /dev/mapper/master-root        12.01GiB
>
> Metadata,single: Size:8.00MiB, Used:0.00B
>    /dev/mapper/master-root         8.00MiB
>
> Metadata,DUP: Size:2.00GiB, Used:562.08MiB
>    /dev/mapper/master-root         4.00GiB
>
> System,single: Size:4.00MiB, Used:0.00B
>    /dev/mapper/master-root         4.00MiB
>
> System,DUP: Size:32.00MiB, Used:16.00KiB
>    /dev/mapper/master-root        64.00MiB
>
> Unallocated:
>    /dev/mapper/master-root       915.24GiB


OK this looks like it maybe was created a while ago, it has these
empty single chunk items that was common a while back. There is a low
risk to clean it up, but I still advise backup first:

'btrfs balance start -mconvert=dup <mountpoint>'

OK so DUP metadata means that you have two copies. So either the
previous email lacks a complete dmesg showing that Btrfs tried to do a
fix up on metadata, or it was reading data and since there's no copy
it fails.


>
>
> Only if the
>> data/metadata on this sector is DUP or raid1 or raid56 can Btrfs
>> automatically fix it up. If there's only one copy, whatever is on that
>> sector is lost, if this is a persistent error. But maybe it's
>> transient.
>>
>> What do you get for
>>
>> sudo smartctl -x /dev/sda
>
> https://gist.github.com/ceremcem/55a219f4c46781c1d4d58e0659500c96
>
>>
>> That'll show stats on bad sectors, and also if the drive supports SCT
>> ERC and what the settings are.
>>
>
> I think the drive screams for help.


Yep.

>5 Reallocated_Sector_Ct PO--CK 070 051 036 - 40472

That's a lot. If the drive is under warranty I'd aggressively try to
get it replaced.

>187 Reported_Uncorrect -O--CK 001 001 000 - 4548

That's too many. It might be by now there are no more reserve sectors
left so remapping isn't possible if there are this many uncorrectable.


>197 Current_Pending_Sector -O--C- 070 069 000 - 5000
>198 Offline_Uncorrectable ----C- 070 069 000 - 5000

Same.



>SCT Error Recovery Control command not supported


OK too bad, no way to increase the recovery time and give it more of a
chance to recover the data.

So yeah, make a backup and get the drive replaced.



>
>>
>> >
>> >
>> > I always saw these DRDY errors whenever I experience physical hard
>> > drive errors, so I expect `btrfs scrub` show some kind of similar
>> > errors but it doesn't:
>> >
>> > btrfs scrub status /mnt/peynir/
>> > scrub status for 8827cb0e-52d7-4f99-90fd-a975cafbfa46
>> > scrub started at Tue Aug 28 00:43:55 2018 and finished after 00:02:07
>> > total bytes scrubbed: 12.45GiB with 0 errors
>>
>> Well that suggests this is a transient problem. Make sure you have
>> backups, drive could be dying or maybe it'll stay in this state for a
>> while longer.
>
> I've very good set of backups, so when the drive dies it won't hurt at
> all. But expecting a possible decease of the hard drive will make it
> easier to get over.


I would consider this drive usable only for educational and
experimentation purposes at this point; real world Btrfs disaster
testing ;-)



>
>>
>>
>> >
>> > I took new snapshots for both root and the LXC containers and nothing
>> > gone wrong. To be confident, I reformat the swap partition (which I
>> > saw some messages about swap partition in the crash screen).
>> >
>> > I'm not sure how to proceed at the moment. Taking succesfull backups
>> > made me think that everything might be okay but I'm not sure if I
>> > should continue trusting the drive or not. What additional checks
>> > should I perform?
>>
>> What you could do is a full balance. This will read everything like a
>> scrub, and then write it back out. So in theory, if the write hits the
>> transient sector the firmware will determine whether the sector needs
>> remapping or not.
>
> I've started a full balance job right now.


With this many sectors pending, I suspect it will fail spectacularly.
But it's a great test in a way. I mean, the block layer might complain
about failed writes, and on any failed write for rootfs by any file
system, it should just fall over and probably not gracefully. But it
might be educational.





-- 
Chris Murphy
