From: "Yan, Zheng " <yanzheng@21cn.com>
Subject: Re: Incorrect disk space reporting
Date: Tue, 15 Sep 2009 12:51:38 +0800
Message-ID: <3d0408630909142151y71024345wf1d00afc944e3946@mail.gmail.com>
References: <615c05430909141957m65cc0b30jfda5bd04e23dd6a3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs list <linux-btrfs@vger.kernel.org>
To: Michel Alexandre Salim <michael.silvanus@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <615c05430909141957m65cc0b30jfda5bd04e23dd6a3@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

2009/9/15 Michel Alexandre Salim <michael.silvanus@gmail.com>:
> I have btrfs /home partitions on two machines, a laptop with Fedora
> 11.91 (Rawhide) x86_64, and a netbook with the same OS, i686 (32-bit)=
=2E
> Both with kernel 2.6.31-2.fc12 and btrfs-progs 0.19.
>
> /home directories are both converted from ext4.
>
> On the netbook, everything is fine; on the laptop, I thought
> everything was fine until I ran a program installer that checks the
> amount of disk space. To my surprise, I then noticed that it is as
> follows:
>
> $ df -h /home
> /dev/mapper/system-home 212G -64Z -99G 100% /home
>
> Doing btrfsck on the partition does not produce anything out of ordin=
ary:
>
> # btrfsck /dev/mapper/system-home
> found 163919360000 bytes used err is 0
> total csum bytes: 158147320
> total tree bytes: 1976504320
> total fs tree bytes: 1623146496
> btree space waste bytes: 540904631
> file data blocks allocated: 215433904128
> =A0referenced 161871007744
> Btrfs Btrfs v0.19
>
> The same laptop has been used to format an external hard drive as
> Btrfs, and the reported disk space on that drive is fine as well.
> Deleting ext2_saved/image does not change the result reported by df.
>
> Any more data I could provide? I'd rather not image the drive as it i=
s
> huge (and contains some personal data). I could, of course, backup,
> create a fresh filesystem, and restore, but would prefer to not do
> that if this problem needs troubleshooting.
>

This bug has already been fixed in btrfs-progs-unstable tree. The bug
only affects fstatfs(2)

Yan, Zheng
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
