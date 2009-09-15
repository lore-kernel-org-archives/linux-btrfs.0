From: Michel Alexandre Salim <michael.silvanus@gmail.com>
Subject: Incorrect disk space reporting
Date: Mon, 14 Sep 2009 22:57:50 -0400
Message-ID: <615c05430909141957m65cc0b30jfda5bd04e23dd6a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

I have btrfs /home partitions on two machines, a laptop with Fedora
11.91 (Rawhide) x86_64, and a netbook with the same OS, i686 (32-bit).
Both with kernel 2.6.31-2.fc12 and btrfs-progs 0.19.

/home directories are both converted from ext4.

On the netbook, everything is fine; on the laptop, I thought
everything was fine until I ran a program installer that checks the
amount of disk space. To my surprise, I then noticed that it is as
follows:

$ df -h /home
/dev/mapper/system-home 212G -64Z -99G 100% /home

Doing btrfsck on the partition does not produce anything out of ordinary:

# btrfsck /dev/mapper/system-home
found 163919360000 bytes used err is 0
total csum bytes: 158147320
total tree bytes: 1976504320
total fs tree bytes: 1623146496
btree space waste bytes: 540904631
file data blocks allocated: 215433904128
 referenced 161871007744
Btrfs Btrfs v0.19

The same laptop has been used to format an external hard drive as
Btrfs, and the reported disk space on that drive is fine as well.
Deleting ext2_saved/image does not change the result reported by df.

Any more data I could provide? I'd rather not image the drive as it is
huge (and contains some personal data). I could, of course, backup,
create a fresh filesystem, and restore, but would prefer to not do
that if this problem needs troubleshooting.

Thanks,

-- 
Michel Alexandre Salim
