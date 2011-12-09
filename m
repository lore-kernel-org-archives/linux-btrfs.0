From: =?ISO-8859-1?Q?Ricardo_B=E1nffy?= <rbanffy@gmail.com>
Subject: Re: Filesystem acting up during balance
Date: Fri, 9 Dec 2011 01:27:45 -0200
Message-ID: <CA+NZatKxzWHSh3=2KZjjygB_ja9M2WbJnb4G_eHL3zocJJ=dCg@mail.gmail.com>
References: <CA+NZatJO2U8PhQC_xK9O0uAb9jbVTpfNwuPj-14rffbXhBfu2Q@mail.gmail.com>
 <20111208153529.GK8971@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	=?ISO-8859-1?Q?Ricardo_B=E1nffy?= <rbanffy@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111208153529.GK8971@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Dec  9 01:05:38 adams kernel: [  165.328507] usb 1-2.1: new high speed
USB device number 7 using ehci_hcd
Dec  9 01:05:38 adams mtp-probe: checking bus 1, device 7:
"/sys/devices/pci0000:00/0000:00:1d.7/usb1/1-2/1-2.1"
Dec  9 01:05:39 adams mtp-probe: bus: 1, device: 7 was not an MTP devic=
e
Dec  9 01:05:39 adams kernel: [  165.680162] scsi3 : usb-storage 1-2.1:=
1.0
Dec  9 01:05:39 adams kernel: [  165.700232] usbcore: registered new
interface driver ums-cypress
Dec  9 01:05:50 adams kernel: [  177.392345] scsi 3:0:0:0:
Direct-Access     ST340083 2A               0000 PQ: 0 ANSI: 0
Dec  9 01:05:51 adams kernel: [  177.564955] sd 3:0:0:0: Attached scsi
generic sg2 type 0
Dec  9 01:05:51 adams kernel: [  177.571190] sd 3:0:0:0: [sdc]
781422768 512-byte logical blocks: (400 GB/372 GiB)
Dec  9 01:05:51 adams kernel: [  177.572543] sd 3:0:0:0: [sdc] Write
Protect is off
Dec  9 01:05:51 adams kernel: [  177.572558] sd 3:0:0:0: [sdc] Mode
Sense: 27 00 00 00
Dec  9 01:05:51 adams kernel: [  177.573533] sd 3:0:0:0: [sdc] No
Caching mode page present
Dec  9 01:05:51 adams kernel: [  177.573551] sd 3:0:0:0: [sdc]
Assuming drive cache: write through
Dec  9 01:05:51 adams kernel: [  177.576904] sd 3:0:0:0: [sdc] No
Caching mode page present
Dec  9 01:05:51 adams kernel: [  177.576920] sd 3:0:0:0: [sdc]
Assuming drive cache: write through
Dec  9 01:06:21 adams kernel: [  207.912535] usb 1-2.1: reset high
speed USB device number 7 using ehci_hcd
Dec  9 01:06:52 adams kernel: [  238.888406] usb 1-2.1: reset high
speed USB device number 7 using ehci_hcd

This is as far as it would go now. I'll attempt the freezer trick with
the drive later, but only when I can dd it into other drive. I'll have
to do some shopping before I can do that.

The drive is experiencing mechanical failure, which is probably what
caused the corruption during the balance in the first place and
explains the erratic behavior. I won't turn it on again until I can
attempt imaging it. Once I have the image, we can attempt a file
recovery on that. I am not very afraid for the data on the disk -
there probably isn't anything non-replaceable there - but this is a
disaster recovery scenario worth rehearsing. As BtrFS becomes more
popular (I have a lot of stuff on it) mishaps like mine will become
more common and I have no intention of being caught off-guard a second
time.

Thanks for the help.

2011/12/8 Chris Mason <chris.mason@oracle.com>:
> On Thu, Dec 08, 2011 at 09:12:34AM -0200, Ricardo B=E1nffy wrote:
>> Hi folks.
>>
>> Last night one of the USB attached disks malfunctioned during a
>> balance. I strongly suspect the drive will die soon. A couple hours
>> later, with the drive cold, I got a
>>
>> Dec =A08 07:34:49 adams kernel: [84890.433235] device label quatroce=
ntao
>> devid 1 transid 1659 /dev/sde1
>> Dec =A08 07:34:49 adams kernel: [84890.460448] btrfs: open_ctree fai=
led
>>
>> I ran btrfsck on it and got
>>
>> root@adams:~# btrfsck /dev/sde1
>> found 396558811136 bytes used err is 0
>> total csum bytes: 385961240
>> total tree bytes: 1334501376
>> total fs tree bytes: 756809728
>> btree space waste bytes: 346120636
>> file data blocks allocated: 396065329152
>> =A0referenced 396065329152
>> Btrfs Btrfs v0.19
>>
>> But, when I tried to mount it, I got the much feared:
>>
>> root@adams:~# mount /dev/sde1 /mnt
>> mount: wrong fs type, bad option, bad superblock on /dev/sde1,
>> =A0 =A0 =A0 =A0missing codepage or helper program, or other error
>> =A0 =A0 =A0 =A0In some cases useful info is found in syslog - try
>> =A0 =A0 =A0 =A0dmesg | tail =A0or so
>>
>> Running Ubuntu 11.04 here.
>>
>> Now would be a terrific time to have a "salvage broken filesystem"
>> utiliy so I could move the data to another disk. Are we there yet?
>
> But the btrfsck passes, so something else must be going on here. =A0C=
ould
> you please send the full kernel dmesg output after the mount?
>
> -chris
>



--=20
Ricardo B=E1nffy
http://www.dieblinkenlights.com
http://twitter.com/rbanffy
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
