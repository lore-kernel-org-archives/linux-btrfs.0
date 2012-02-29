From: Travis Shivers <ttshivers@gmail.com>
Subject: Re: Btrfs Storage Array Corrupted
Date: Wed, 29 Feb 2012 17:11:24 -0600
Message-ID: <CAPeorG-rC6_bM+vX0Jyap74TdRr7cgQjBfb_PBvNHDz-yyQkWw@mail.gmail.com>
References: <CAPeorG-1EtMAu9XzSNqMW-=QwhN-_bZorLXy9Pr5N+J-LKPzTg@mail.gmail.com>
 <4F4D8259.2090209@oracle.com> <20120229025027.GB15383@shiny>
 <CAPeorG_-z-UuVrzUhLucMnPg5QxUcQKh4r23ut6fOLObxL4C8A@mail.gmail.com>
 <CAE5mzvixYURzdNX3snjjJESUNUBz316YjzDxfZe6-Q2TGBMYww@mail.gmail.com>
 <CAPeorG9E0SDXqoa7VeUASxAbtBf+voQVRgfZ_FtOb3d6nbe-ZQ@mail.gmail.com>
 <20120229135926.GB5054@shiny> <CAPeorG9u6Z-Z5QnxAc5QB3ZzrR17+3Y2t-UQFd8v_aqN-rVwTA@mail.gmail.com>
 <20120229221414.GS5054@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Chris Mason <chris.mason@oracle.com>,
	Travis Shivers <ttshivers@gmail.com>,
	cwillu <cwillu@cwillu.com>, Gurudas Pai <gurudas.pai@oracle.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120229221414.GS5054@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Thank you all for helping. My btrfs array consists of 4 disks: 2 (2
TB) disks and 2(500 GB) disks. Since I have disks of different sizes,
I have the array being mirrored so that there are two copies of a file
on two separate disks. The data and metadata are mirrored.

I originally made the array by using this command:

# mkfs.btrfs -m raid1 -d raid1 /dev/sd[abcd]
(The drives were originally those letters)


All of the disks sit in an external 4 bay ESATA enclosure going into a
PCI-E RAID card set up as JBOD, so I can use btrfs' software
mirroring. This is the enclosure that I have:
http://www.newegg.com/Product/Product.aspx?Item=3DN82E16816132029

The corruption was unexpected. I am not entirely sure what caused it,
but a few days before the corruption, there were several power
outages. I do not think that the problem is with the actual hard drive
hardware since they are fairly new (6 months old) and they pass all
SMART tests. After a reboot, the btrfs array refused to mount and
started giving off errors. I do weekly scrubs, balances, and
defragmentation.

Here is what btrfs filesystem show says:

# btrfs filesystem show
Label: none  uuid: 2c11a326-5630-484e-9f1d-9dab777a1028
        Total devices 4 FS bytes used 1.08TB
        devid    1 size 1.82TB used 1.08TB path /dev/sdf
        devid    2 size 1.82TB used 1.08TB path /dev/sdg
        devid    3 size 465.76GB used 8.00MB path /dev/sdh
        devid    4 size 465.76GB used 8.00MB path /dev/sdi

Btrfs Btrfs v0.19

These are my normal mount line for the array in /etc/fstab

UUID=3D2c11a326-5630-484e-9f1d-9dab777a1028 /mnt/main btrfs
noatime,nodiratime,compress=3Dlzo,space_cache,inode_cache 0 1


On Wed, Feb 29, 2012 at 4:14 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> On Wed, Feb 29, 2012 at 03:57:19PM -0600, Travis Shivers wrote:
>> Here is the output from the commands:
>>
>> # ./btrfs-debug-tree -R /dev/sdh
>> failed to read /dev/sr0: No medium found
>> failed to read /dev/sde: No medium found
>> failed to read /dev/sdd: No medium found
>> failed to read /dev/sdc: No medium found
>> failed to read /dev/sdb: No medium found
>> failed to read /dev/sda: No medium found
>> parent transid verify failed on 5568194695168 wanted 43477 found 431=
51
>
> So far all the blocks that have come up look like they are in the ext=
ent
> allocation tree. =A0This helps because it is the easiest to recover.
>
> I can also make a patch for you against 3.3-rc that skips reading it
> entirely, which should make it possible to copy things off.
>
> But before I do that, could you describe the raid array? =A0Was it
> mirrored or raid10? =A0What exactly happened when it stopped working?
>
> -chris
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
