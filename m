Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f44.google.com ([209.85.218.44]:34263 "EHLO
        mail-oi0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751522AbcJJVAF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Oct 2016 17:00:05 -0400
Received: by mail-oi0-f44.google.com with SMTP id t73so1859099oie.1
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Oct 2016 13:59:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5cde01d2230f$fa1e3150$ee5a93f0$@com>
References: <5cde01d2230f$fa1e3150$ee5a93f0$@com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 10 Oct 2016 14:59:11 -0600
Message-ID: <CAJCQCtQ0SCZi36RG32NiHVYJRz8gHCtfhWYEqM93y2twX4C4JA@mail.gmail.com>
Subject: Re: raid6 file system in a bad state
To: "Jason D. Michaelson" <jasondmichaelson@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 10, 2016 at 10:04 AM, Jason D. Michaelson
<jasondmichaelson@gmail.com> wrote:

> One of the disks had a write problem, unbeknownst to me, which caused the
> entire pool and its subvolumes to remount read only.

Can you be more specific about the write problem? What are the
messages from the logs about these write problems and is that problem
now fixed?




>
> When this problem occurred I was on debian jessie kernel 3.16.something.
> Following list advice I upgraded to the latest in jessie-backports, 4.7.5.
> My git clone of btrfs-progs is at commit
> 81f4d96f3d6368dc4e5edf7e3cb9d19bb4d00c4f
>
> Not knowing the cause of the problem, I unmounted and attempted to remount,
> which failed, with the following coming from dmesg:
>
> [308063.610960] BTRFS info (device sda): allowing degraded mounts
> [308063.610972] BTRFS info (device sda): disk space caching is enabled
> [308063.723461] BTRFS error (device sda): parent transid verify failed on
> 5752357961728 wanted 161562 found 159746
> [308063.815224] BTRFS info (device sda): bdev /dev/sdh errs: wr 261, rd 1,
> flush 87, corrupt 0, gen 0
> [308063.849613] BTRFS error (device sda): parent transid verify failed on
> 5752642420736 wanted 161562 found 159786
> [308063.881024] BTRFS error (device sda): parent transid verify failed on
> 5752472338432 wanted 161562 found 159751
> [308063.940225] BTRFS error (device sda): parent transid verify failed on
> 5752478842880 wanted 161562 found 159752
> [308063.979517] BTRFS error (device sda): parent transid verify failed on
> 5752543526912 wanted 161562 found 159764
> [308064.012479] BTRFS error (device sda): parent transid verify failed on
> 5752513036288 wanted 161562 found 159764
> [308064.049169] BTRFS error (device sda): parent transid verify failed on
> 5752642617344 wanted 161562 found 159786
> [308064.080507] BTRFS error (device sda): parent transid verify failed on
> 5752642650112 wanted 161562 found 159786
> [308064.138951] BTRFS error (device sda): parent transid verify failed on
> 5752610603008 wanted 161562 found 159783
> [308064.164326] BTRFS error (device sda): bad tree block start
> 5918360357649457268 5752610603008
> [308064.173752] BTRFS error (device sda): bad tree block start
> 5567295971165396096 5752610603008
> [308064.182026] BTRFS error (device sda): failed to read block groups: -5
> [308064.234174] BTRFS: open_ctree failed

Sometimes it will be more tolerant with mount -o degraded,ro.



> /dev/sdh is the disc that had the write error
>


> [232578.796809] mpt2sas_cm0: log_info(0x31080000): originator(PL),
> code(0x08), sub_code(0x0000)
> [232578.796838] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
> 55 61 f0 00 00 00 40 00 00
> [232578.796845] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
> [232578.796850] mpt2sas_cm0:
> enclosure_logical_id(0x50030442523a2033),slot(2)
> [232578.796856] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
> smid(36)
> [232578.796860] mpt2sas_cm0:    request_len(32768), underflow(32768),
> resid(0)
> [232578.796864] mpt2sas_cm0:    tag(0), transfer_count(32768),
> sc->result(0x00000000)
> [232578.796869] mpt2sas_cm0:    scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [232578.796874] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
> count(18)
> [232578.797129] sd 0:0:8:0: [sdh] tag#4 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [232578.797138] sd 0:0:8:0: [sdh] tag#4 Sense Key : Medium Error [current]
> [232578.797146] sd 0:0:8:0: [sdh] tag#4 Add. Sense: Unrecovered read error
> [232578.797154] sd 0:0:8:0: [sdh] tag#4 CDB: Read(16) 88 00 00 00 00 00 34
> 55 61 f0 00 00 00 40 00 00
> [232578.797160] blk_update_request: critical medium error, dev sdh, sector
> 878010888

Each one of these complains about a read error and a different LBA is reported.

These should get fixed automatically by Btrfs since kernel 3.19. The
problem is that you were using 3.16 so they were left to accumulate.
3.16 kernel needed a full balance to fix these.




> [232581.663794] mpt2sas_cm0: log_info(0x31080000): originator(PL),
> code(0x08), sub_code(0x0000)
> [232581.663823] sd 0:0:8:0: [sdh] tag#1 CDB: Read(16) 88 00 00 00 00 00 34
> 55 62 30 00 00 00 80 00 00
> [232581.663830] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
> [232581.663835] mpt2sas_cm0:
> enclosure_logical_id(0x50030442523a2033),slot(2)
> [232581.663841] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
> smid(62)
> [232581.663845] mpt2sas_cm0:    request_len(65536), underflow(65536),
> resid(65536)
> [232581.663849] mpt2sas_cm0:    tag(0), transfer_count(0),
> sc->result(0x00000000)
> [232581.663854] mpt2sas_cm0:    scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [232581.663859] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
> count(18)
> [232581.663918] sd 0:0:8:0: [sdh] tag#1 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [232581.663937] sd 0:0:8:0: [sdh] tag#1 Sense Key : Medium Error [current]
> [232581.663951] sd 0:0:8:0: [sdh] tag#1 Add. Sense: Unrecovered read error
> [232581.663960] sd 0:0:8:0: [sdh] tag#1 CDB: Read(16) 88 00 00 00 00 00 34
> 55 62 30 00 00 00 80 00 00
> [232581.663967] blk_update_request: critical medium error, dev sdh, sector
> 878010928
> [232584.622191] sd 0:0:8:0: [sdh] tag#0 CDB: Read(16) 88 00 00 00 00 00 34
> 55 62 08 00 00 00 08 00 00
> [232584.622207] mpt2sas_cm0:    sas_address(0x50030480002e5946), phy(6)
> [232584.622213] mpt2sas_cm0:
> enclosure_logical_id(0x50030442523a2033),slot(2)
> [232584.622219] mpt2sas_cm0:    handle(0x0012), ioc_status(success)(0x0000),
> smid(55)
> [232584.622224] mpt2sas_cm0:    request_len(4096), underflow(4096),
> resid(4096)
> [232584.622228] mpt2sas_cm0:    tag(0), transfer_count(0),
> sc->result(0x00000000)
> [232584.622233] mpt2sas_cm0:    scsi_status(check condition)(0x02),
> scsi_state(autosense valid )(0x01)
> [232584.622237] mpt2sas_cm0:    [sense_key,asc,ascq]: [0x03,0x11,0x00],
> count(18)
> [232584.622272] sd 0:0:8:0: [sdh] tag#0 FAILED Result: hostbyte=DID_OK
> driverbyte=DRIVER_SENSE
> [232584.622282] sd 0:0:8:0: [sdh] tag#0 Sense Key : Medium Error [current]
> [232584.622295] sd 0:0:8:0: [sdh] tag#0 Add. Sense: Unrecovered read error
> [232584.622304] sd 0:0:8:0: [sdh] tag#0 CDB: Read(16) 88 00 00 00 00 00 34
> 55 62 08 00 00 00 08 00 00
> [232584.622311] blk_update_request: critical medium error, dev sdh, sector
> 878010888
> [232584.630625] Buffer I/O error on dev sdh, logical block 109751361, async
> page read
>
>
> rather than moving on but that's neither here nor there, since the disc
> really can't be trusted as it is.

You don't have to, that's Btrfs problem. What's confusing to me is
that interspersed with these read errors, there are no Btrfs messages.
I'm expecting Btrfs to do something about the read error if those
sectors are in a Btrfs volume. Either Btrfs should say whether it's
fixing the problem, in either case. But I see nothing.






>
> btrfs check produces this output:
>
> root@castor:~/btrfs-progs# ./btrfs check --readonly /dev/sda
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> parent transid verify failed on 5752357961728 wanted 161562 found 159746
> checksum verify failed on 5752357961728 found B5CA97C0 wanted 51292A76
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> checksum verify failed on 5752357961728 found 8582246F wanted B53BE280
> bytenr mismatch, want=5752357961728, have=56504706479104
> Couldn't setup extent tree
> ERROR: cannot open file system

Seems like there should be more to the story than just one bad drive
or it'd be possible to mount minus the bad drive. Maybe sdh is
spitting out spurious data. Have you tried physically removing
/dev/sdh and then doing a degraded mount?

An entire syslog, journalctl, or dmesg might be helpful rather than excerpts.



> Like I said, the vast majority of what's on this disc is either BluRay ISOs
> that I can re-rip, stuff I don't care about recovering, or stuff that I can
> always re-mirror if I have to. Given that I'm well versed in C programming,
> I'd much rather devote my time to working with the code to resolve whatever
> problem may be happening here than re-acquiring or re-ripping what's on that
> pool.
>
> Since it took somewhere near an hour and a half to get to that SIGBUS in
> gdb, I've left my session open for anyone who may have ideas to chime in.
> Just let me know what information you need!

That part I can't help out with.


-- 
Chris Murphy
