From: Nik Markovic <nmarkovi.navteq@gmail.com>
Subject: Consistent crash with cp reflink on large files
Date: Mon, 12 Dec 2011 14:15:07 -0600
Message-ID: <CAB3q875f4HFCaR9=yk0iCy7HF55tpt65q2+-fCuNbkSFHrey_A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
To: miaox@cn.fujitsu.com, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hi All,

I have been encountering consistent btrfs filesystem crashes when
using cp =96reflink=3Dalways on a large file and modifying it. I believ=
e
that the test file needs to be fairly large as I was not able to
reproduce with smaller files. The filesystem size is 45GB and file
size is 10GB.

Thanks,
Nik

---- Trace:
[240213.884228] ------------[ cut here ]------------
[240213.884232] kernel BUG at
/build/buildd/linux-3.0.0/fs/btrfs/delayed-inode.c:1693!
[240213.884235] invalid opcode: 0000 [#1] SMP
[240213.884237] Modules linked in: bnep rfcomm bluetooth vboxnetadp
vboxnetflt vboxdrv binfmt_misc nfsd nfs lockd fscache auth_rpcgss
nfs_acl sunrpc vesafb snd_hda_codec_analog snd_usb_audio
snd_usbmidi_lib joydev snd_hda_intel snd_hda_codec snd_hwdep snd_pcm
snd_seq_midi snd_rawmidi snd_seq_midi_event dell_wmi sparse_keymap
ppdev snd_seq snd_timer snd_seq_device nvidia(P) dcdbas wmi parport_pc
psmouse snd serio_raw soundcore snd_page_alloc i7core_edac edac_core
lp parport usbhid hid firewire_ohci firewire_core crc_itu_t tg3 btrfs
zlib_deflate libcrc32c
[240213.884266]
[240213.884269] Pid: 4703, comm: cp Tainted: P
3.0.0-13-generic #22-Ubuntu Dell Inc. Precision WorkStation T3500
/0XPDFK
[240213.884273] EIP: 0060:[<f8164ca0>] EFLAGS: 00010286 CPU: 0
[240213.884289] EIP is at btrfs_delayed_update_inode+0x100/0x110 [btrfs=
]
[240213.884291] EAX: ffffffe4 EBX: eb555e08 ECX: 00018000 EDX: 00018000
[240213.884293] ESI: eb4d8db0 EDI: eb41089c EBP: f1e0dde8 ESP: f1e0ddc8
[240213.884295]  DS: 007b ES: 007b FS: 00d8 GS: 00e0 SS: 0068
[240213.884297] Process cp (pid: 4703, ti=3Df1e0c000 task=3Deba03fc0
task.ti=3Df1e0c000)
[240213.884299] Stack:
[240213.884300]  00018000 00000000 00018000 edd74800 eb555e34 eb41089c
edd74800 00000000
[240213.884305]  f1e0de10 f81202a8 00000001 00000000 eb40c11c f6b18150
eb4d8db0 eb41089c
[240213.884309]  edd74800 00000000 f1e0df04 f8148e16 067ff000 00000001
02599000 00000000
[240213.884314] Call Trace:
[240213.884328]  [<f81202a8>] btrfs_update_inode+0x58/0x170 [btrfs]
[240213.884342]  [<f8148e16>] btrfs_ioctl_clone+0x936/0xc60 [btrfs]
[240213.884357]  [<f814cb30>] btrfs_ioctl+0x570/0x5e0 [btrfs]
[240213.884371]  [<f814c5c0>] ? btrfs_ioctl_trans_end+0x60/0x60 [btrfs]
[240213.884375]  [<c11380ea>] file_ioctl+0x4a/0x150
[240213.884377]  [<c11384ba>] do_vfs_ioctl+0x2ca/0x2d0
[240213.884380]  [<c113852f>] sys_ioctl+0x6f/0x80
[240213.884383]  [<c152cc24>] syscall_call+0x7/0xb
[240213.884385] Code: 46 24 89 0c 24 81 c2 b0 00 00 00 89 4d e8 e8 28
27 fa ff 8b 4d e8 85 c0 75 11 89 4b 08 c7 43 0c 00 00 00 00 e9 49 ff
ff ff 66 90 <0f> 0b 8d b4 26 00 00 00 00 8d bc 27 00 00 00 00 55 89 e5
53 3e
[240213.884411] EIP: [<f8164ca0>]
btrfs_delayed_update_inode+0x100/0x110 [btrfs] SS:ESP 0068:f1e0ddc8
[240213.884500] ---[ end trace 81327a383209814e ]---

System: 3.0.0-13-generic #22-Ubuntu SMP, 32-bit,
http://www.dell.com/us/business/p/precision-t3500/pd, Xeon W3503,
--- other info
sudo hdparm -I /dev/sda

/dev/sda:

ATA device, with non-removable media
	Model Number:       WDC WD2500AAJS-75M0A0
	Serial Number:      WD-WMAV2W142610
	Firmware Revision:  02.03E02
	Transport:          Serial, SATA 1.0a, SATA II Extensions, SATA Rev 2.=
5
Standards:
	Supported: 8 7 6 5
	Likely used: 8
Configuration:
	Logical		max	current
	cylinders	16383	16383
	heads		16	16
	sectors/track	63	63
	--
	CHS current addressable sectors:   16514064
	LBA    user addressable sectors:  268435455
	LBA48  user addressable sectors:  488281250
	Logical/Physical Sector size:           512 bytes
	device size with M =3D 1024*1024:      238418 MBytes
	device size with M =3D 1000*1000:      250000 MBytes (250 GB)
	cache/buffer size  =3D 8192 KBytes
Capabilities:
	LBA, IORDY(can be disabled)
	Queue depth: 32
	Standby timer values: spec'd by Standard, with device specific minimum
	R/W multiple sector transfer: Max =3D 16	Current =3D 8
	Recommended acoustic management value: 128, current value: 128
	DMA: mdma0 mdma1 mdma2 udma0 udma1 udma2 udma3 udma4 udma5 *udma6
	     Cycle time: min=3D120ns recommended=3D120ns
	PIO: pio0 pio1 pio2 pio3 pio4
	     Cycle time: no flow control=3D120ns  IORDY flow control=3D120ns
Commands/features:
	Enabled	Supported:
	   *	SMART feature set
	    	Security Mode feature set
	   *	Power Management feature set
	   *	Write cache
	   *	Look-ahead
	   *	Host Protected Area feature set
	   *	WRITE_BUFFER command
	   *	READ_BUFFER command
	   *	NOP cmd
	   *	DOWNLOAD_MICROCODE
	    	Power-Up In Standby feature set
	   *	SET_FEATURES required to spinup after power up
	    	SET_MAX security extension
	   *	Automatic Acoustic Management feature set
	   *	48-bit Address feature set
	   *	Device Configuration Overlay feature set
	   *	Mandatory FLUSH_CACHE
	   *	FLUSH_CACHE_EXT
	   *	SMART error logging
	   *	SMART self-test
	   *	General Purpose Logging feature set
	   *	64-bit World wide name
	   *	Segmented DOWNLOAD_MICROCODE
	   *	Gen1 signaling speed (1.5Gb/s)
	   *	Gen2 signaling speed (3.0Gb/s)
	   *	Native Command Queueing (NCQ)
	   *	Host-initiated interface power management
	   *	Phy event counters
	    	DMA Setup Auto-Activate optimization
	    	Device-initiated interface power management
	   *	Software settings preservation
	   *	SMART Command Transport (SCT) feature set
	   *	SCT Long Sector Access (AC1)
	   *	SCT LBA Segment Access (AC2)
	   *	SCT Features Control (AC4)
	   *	SCT Data Tables (AC5)
	    	unknown 206[12] (vendor specific)
	    	unknown 206[13] (vendor specific)
Security:
	Master password revision code =3D 65534
		supported
	not	enabled
	not	locked
		frozen
	not	expired: security count
		supported: enhanced erase
	56min for SECURITY ERASE UNIT. 56min for ENHANCED SECURITY ERASE UNIT.
Logical Unit WWN Device Identifier: 50014ee05791e0e0
	NAA		: 5
	IEEE OUI	: 0014ee
	Unique ID	: 05791e0e0
Checksum: correct


Here is the script that you can use to try reproduce. On my system it
crashes within less than 100 iterations.

#!/bin/bash

#$1 is a directory on a btrfs filesystem

src=3D$1/test/src
dst=3D$1/test/dst
srcfile=3D$src/test.tar
dstfile=3D$dst/test.tar

mkdir -p $src
mkdir -p $dst

filesize=3D100MB

#build a 10GB file from a smaller download. You can twaek filesize and
the loop below for lower bandwidth
if [ ! -f $srcfile ]; then
	cd $src
	if [ ! -f $srcfile.dl ]; then
		wget http://download.thinkbroadband.com/${filesize}.zip
--output-document=3D$srcfile.dl
	fi
	rm -rf tarbase
	mkdir tarbase
	for  i in {1..100}; do
		cp --reflink=3Dalways $srcfile.dl tarbase/$i.dl
	done
	tar -cvf $srcfile tarbase
	rm -rf tarbase
fi

cat <<END > $src/FileTest.java
import java.io.IOException;
import java.io.RandomAccessFile;
public class FileTest {
    public static void main(String args[]) throws IOException {
        RandomAccessFile f =3D new RandomAccessFile(args[0], "rws");

        f.seek(50000);
        f.writeBytes("DEADBEEF");
        f.close();
    }
}
END

cd $src
javac FileTest.java

for i in {1..100000}; do
	echo -n "$i."
	cp --reflink=3Dalways $srcfile $dstfile
	java FileTest $dstfile-$i.tst
	sleep 1
	rm $dstfile-$i.tst
done
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
