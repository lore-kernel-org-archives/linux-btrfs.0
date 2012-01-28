From: Nikolaus Rath <Nikolaus@rath.org>
Subject: blocked tasks right after mounting (was: Hang when trying to access fs)
Date: Sat, 28 Jan 2012 10:23:53 -0500
Message-ID: <87zkd73l6e.fsf@vostro.rath.org>
References: <874nvf50bm.fsf@vostro.rath.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <874nvf50bm.fsf@vostro.rath.org> (Nikolaus Rath's message of
	"Sat, 28 Jan 2012 10:11:25 -0500")
List-ID: <linux-btrfs.vger.kernel.org>

Nikolaus Rath <Nikolaus@rath.org> writes:
> Hello,
>
> When trying to rsync to btrfs, the process just hangs. dmesg output
> alternates between:
[...]

I guess I should also mention that this is reproducible, and I don't
even need to run rsync. Simply mounting the file system produces a
similar warning soon afterwards:

[  678.316046] usb 1-4: new high speed USB device number 7 using ehci_h=
cd
[  678.448928] usb 1-4: New USB device found, idVendor=3D152d, idProduc=
t=3D2509
[  678.448931] usb 1-4: New USB device strings: Mfr=3D10, Product=3D11,=
 SerialNumber=3D3
[  678.448933] usb 1-4: Product: Usb production
[  678.448934] usb 1-4: Manufacturer: Jmicron Corp.
[  678.448936] usb 1-4: SerialNumber: 00A123456789
[  678.450429] scsi7 : usb-storage 1-4:1.0
[  681.372710] scsi 7:0:0:0: Direct-Access     WDC WD50 01AALS-00L3B2  =
  0000 PQ: 0 ANSI: 2 CCS
[  681.658185] sd 7:0:0:0: [sdg] 976773168 512-byte logical blocks: (50=
0 GB/465 GiB)
[  681.658925] sd 7:0:0:0: [sdg] Write Protect is off
[  681.658929] sd 7:0:0:0: [sdg] Mode Sense: 28 00 00 00
[  681.659675] sd 7:0:0:0: [sdg] No Caching mode page present
[  681.659679] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[  681.662049] sd 7:0:0:0: [sdg] No Caching mode page present
[  681.662052] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[  681.670316]  sdg: sdg1
[  681.673554] sd 7:0:0:0: [sdg] No Caching mode page present
[  681.673558] sd 7:0:0:0: [sdg] Assuming drive cache: write through
[  681.673562] sd 7:0:0:0: [sdg] Attached SCSI disk
[  791.512475] Btrfs loaded
[  791.513625] device label Videos devid 1 transid 142 /dev/mapper/udis=
ks-luks-uuid-7adf0c16-c741-485e-86dd-8a209fe4ce85-uid1000
[  791.567843] btrfs: disk space caching is enabled
[  960.456073] INFO: task sync:4930 blocked for more than 120 seconds.
[  960.456077] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disab=
les this message.
[  960.456080] sync            D ffff8800bfc92f40     0  4930      1 0x=
00000000
[  960.456085]  ffff88009f4d5790 0000000000000082 0000000000000000 ffff=
8800bbf080c0
[  960.456089]  0000000000012f40 ffff88009f4d7fd8 ffff88009f4d7fd8 ffff=
88009f4d5790
[  960.456094]  0000000000000246 000000018132de1c ffff880091d342f0 ffff=
88008686ae80
[  960.456098] Call Trace:
[  960.456117]  [<ffffffffa05aed19>] ? wait_current_trans.isra.22+0xae/=
0xdd [btrfs]
[  960.456123]  [<ffffffff8105ec6b>] ? add_wait_queue+0x3c/0x3c
[  960.456137]  [<ffffffffa05aff82>] ? start_transaction+0x231/0x246 [b=
trfs]
[  960.456141]  [<ffffffff81114543>] ? __sync_filesystem+0x6e/0x6e
[  960.456150]  [<ffffffffa0594357>] ? btrfs_sync_fs+0x79/0x95 [btrfs]
[  960.456153]  [<ffffffff8111452b>] ? __sync_filesystem+0x56/0x6e
[  960.456157]  [<ffffffff810f6578>] ? iterate_supers+0x5e/0xab
[  960.456160]  [<ffffffff811145cd>] ? sys_sync+0x3d/0x52
[  960.456164]  [<ffffffff81332e12>] ? system_call_fastpath+0x16/0x1b


Best,

   -Nikolaus

--=20
 =C2=BBTime flies like an arrow, fruit flies like a Banana.=C2=AB

  PGP fingerprint: 5B93 61F8 4EA2 E279 ABF6  02CF A9AD B7F8 AE4E 425C
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
