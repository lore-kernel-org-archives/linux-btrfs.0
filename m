Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f41.google.com ([209.85.213.41]:39557 "EHLO
        mail-vk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727058AbeH1Ckr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Aug 2018 22:40:47 -0400
Received: by mail-vk0-f41.google.com with SMTP id e139-v6so327014vkf.6
        for <linux-btrfs@vger.kernel.org>; Mon, 27 Aug 2018 15:52:06 -0700 (PDT)
MIME-Version: 1.0
From: Cerem Cem ASLAN <ceremcem@ceremcem.net>
Date: Tue, 28 Aug 2018 01:51:54 +0300
Message-ID: <CAN4oSBdfDVGmG8L2vS9h9McEs5aSuP5RfTGREB2ZhGwmAg4JhA@mail.gmail.com>
Subject: DRDY errors are not consistent with scrub results
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

I'm getting DRDY ERR messages which causes system crash on the server:

# tail -n 40 /var/log/kern.log.1
Aug 24 21:04:55 aea3 kernel: [  939.228059] lxc-bridge: port
5(vethI7JDHN) entered disabled state
Aug 24 21:04:55 aea3 kernel: [  939.300602] eth0: renamed from vethQ5Y2OF
Aug 24 21:04:55 aea3 kernel: [  939.328245] IPv6: ADDRCONF(NETDEV_UP):
eth0: link is not ready
Aug 24 21:04:55 aea3 kernel: [  939.328453] IPv6:
ADDRCONF(NETDEV_CHANGE): eth0: link becomes ready
Aug 24 21:04:55 aea3 kernel: [  939.328474] IPv6:
ADDRCONF(NETDEV_CHANGE): vethI7JDHN: link becomes ready
Aug 24 21:04:55 aea3 kernel: [  939.328491] lxc-bridge: port
5(vethI7JDHN) entered blocking state
Aug 24 21:04:55 aea3 kernel: [  939.328493] lxc-bridge: port
5(vethI7JDHN) entered forwarding state
Aug 24 21:04:59 aea3 kernel: [  943.085647] cgroup: cgroup2: unknown
option "nsdelegate"
Aug 24 21:16:15 aea3 kernel: [ 1619.400016] perf: interrupt took too
long (2506 > 2500), lowering kernel.perf_event_max_sample_rate to
79750
Aug 24 21:17:11 aea3 kernel: [ 1675.515815] perf: interrupt took too
long (3137 > 3132), lowering kernel.perf_event_max_sample_rate to
63750
Aug 24 21:17:13 aea3 kernel: [ 1677.080837] cgroup: cgroup2: unknown
option "nsdelegate"
Aug 25 22:38:31 aea3 kernel: [92955.512098] usb 4-2: USB disconnect,
device number 2
Aug 26 02:14:21 aea3 kernel: [105906.035038] lxc-bridge: port
4(vethCTKU4K) entered disabled state
Aug 26 02:15:30 aea3 kernel: [105974.107521] lxc-bridge: port
4(vethO59BPD) entered disabled state
Aug 26 02:15:30 aea3 kernel: [105974.109991] device vethO59BPD left
promiscuous mode
Aug 26 02:15:30 aea3 kernel: [105974.109995] lxc-bridge: port
4(vethO59BPD) entered disabled state
Aug 26 02:15:30 aea3 kernel: [105974.710490] lxc-bridge: port
4(vethBAYODL) entered blocking state
Aug 26 02:15:30 aea3 kernel: [105974.710493] lxc-bridge: port
4(vethBAYODL) entered disabled state
Aug 26 02:15:30 aea3 kernel: [105974.710545] device vethBAYODL entered
promiscuous mode
Aug 26 02:15:30 aea3 kernel: [105974.710598] IPv6:
ADDRCONF(NETDEV_UP): vethBAYODL: link is not ready
Aug 26 02:15:30 aea3 kernel: [105974.710600] lxc-bridge: port
4(vethBAYODL) entered blocking state
Aug 26 02:15:30 aea3 kernel: [105974.710601] lxc-bridge: port
4(vethBAYODL) entered forwarding state
Aug 26 02:16:35 aea3 kernel: [106039.674089] BTRFS: device fsid
5b844c7a-0cbd-40a7-a8e3-6bc636aba033 devid 1 transid 984 /dev/dm-3
Aug 26 02:17:21 aea3 kernel: [106085.352453] ata4.00: failed command: READ DMA
Aug 26 02:17:21 aea3 kernel: [106085.352901] ata4.00: status: { DRDY ERR }
Aug 26 02:18:56 aea3 kernel: [106180.648062] ata4.00: exception Emask
0x0 SAct 0x0 SErr 0x0 action 0x0
Aug 26 02:18:56 aea3 kernel: [106180.648333] ata4.00: BMDMA stat 0x25
Aug 26 02:18:56 aea3 kernel: [106180.648515] ata4.00: failed command: READ DMA
Aug 26 02:18:56 aea3 kernel: [106180.648706] ata4.00: cmd
c8/00:08:80:9c:bb/00:00:00:00:00/e3 tag 0 dma 4096 in
Aug 26 02:18:56 aea3 kernel: [106180.648706]          res
51/40:00:80:9c:bb/00:00:00:00:00/03 Emask 0x9 (media error)
Aug 26 02:18:56 aea3 kernel: [106180.649380] ata4.00: status: { DRDY ERR }
Aug 26 02:18:56 aea3 kernel: [106180.649743] ata4.00: error: { UNC }
Aug 26 02:18:56 aea3 kernel: [106180.779311] ata4.00: configured for UDMA/133
Aug 26 02:18:56 aea3 kernel: [106180.779331] sd 3:0:0:0: [sda] tag#0
FAILED Result: hostbyte=DID_OK driverbyte=DRIVER_SENSE
Aug 26 02:18:56 aea3 kernel: [106180.779335] sd 3:0:0:0: [sda] tag#0
Sense Key : Medium Error [current]
Aug 26 02:18:56 aea3 kernel: [106180.779339] sd 3:0:0:0: [sda] tag#0
Add. Sense: Unrecovered read error - auto reallocate failed
Aug 26 02:18:56 aea3 kernel: [106180.779343] sd 3:0:0:0: [sda] tag#0
CDB: Read(10) 28 00 03 bb 9c 80 00 00 08 00
Aug 26 02:18:56 aea3 kernel: [106180.779346] blk_update_request: I/O
error, dev sda, sector 62626944
Aug 26 02:18:56 aea3 kernel: [106180.779703] BTRFS error (device
dm-2): bdev /dev/mapper/master-root errs: wr 0, rd 40, flush 0,
corrupt 0, gen 0
Aug 26 02:18:56 aea3 kernel: [106180.779936] ata4: EH complete


I always saw these DRDY errors whenever I experience physical hard
drive errors, so I expect `btrfs scrub` show some kind of similar
errors but it doesn't:

btrfs scrub status /mnt/peynir/
scrub status for 8827cb0e-52d7-4f99-90fd-a975cafbfa46
scrub started at Tue Aug 28 00:43:55 2018 and finished after 00:02:07
total bytes scrubbed: 12.45GiB with 0 errors

I took new snapshots for both root and the LXC containers and nothing
gone wrong. To be confident, I reformat the swap partition (which I
saw some messages about swap partition in the crash screen).

I'm not sure how to proceed at the moment. Taking succesfull backups
made me think that everything might be okay but I'm not sure if I
should continue trusting the drive or not. What additional checks
should I perform?
