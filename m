From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: version
Date: 24 Jan 2011 22:39:00 +0100
Message-ID: <BeTmYH9T1uB@helmut.hullen.de>
References: <201101242214.19318.johannes.hirte@fem.tu-ilmenau.de>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201101242214.19318.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Johannes,

Du meintest am 24.01.11:

>> My other problem: where has the ENOSPC problem be cured? Is it a
>> kernel problem?

> Which one? And yes, ENOSPC is kernel related.

The problem:

I create 1 btrfs device with 2 TByte
I add another device with 40 GByte

I fill the btrfs "device" with 30 GByte and then run "balance".

That results in


# btrfs filesystem show
Label: none  uuid: 121ae2ed-f572-43e6-8855-cd66ad534401
	Total devices 2 FS bytes used 94.68GB
	devid    2 size 37.27GB used 37.00GB path /dev/sdf
	devid    1 size 1.82TB used 63.04GB path /dev/sde

Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 1.15TB
	devid    1 size 1.81TB used 591.14GB path /dev/sde2
	*** Some devices missing

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D4.00GB, used=3D2.00GB
Data: total=3D94.01GB, used=3D92.58GB
System, DUP: total=3D8.00MB, used=3D16.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, DUP: total=3D1.00GB, used=3D111.87MB
Metadata: total=3D8.00MB, used=3D0.00

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sde     btrfs   1992597264  99396500 1891304076   5% /mnt/btr

# fdisk -l

# btrfs filesystem show
Label: none  uuid: 121ae2ed-f572-43e6-8855-cd66ad534401
	Total devices 2 FS bytes used 93.68GB
	devid    2 size 37.27GB used 36.12GB path /dev/sdf
	devid    1 size 1.82TB used 93.16GB path /dev/sde

Label: 'MM2'  uuid: ad7c0668-316c-4a79-ba00-3b505b9d99b4
	Total devices 2 FS bytes used 1.15TB
	devid    1 size 1.81TB used 591.14GB path /dev/sde2
	*** Some devices missing

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D64.00GB, used=3D31.90GB
Data: total=3D63.01GB, used=3D61.67GB
System, DUP: total=3D8.00MB, used=3D20.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D128.00MB, used=3D104.71MB
Metadata, DUP: total=3D1.00GB, used=3D6.15MB
Metadata: total=3D8.00MB, used=3D0.00

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sde     btrfs   1992597264  98348716 1892087652   5% /mnt/btr

# ---------------------------------------------------

Regard the difference between "df" and "btrfs filesystem df".

When I copy some more files then the system tells "no space left on ...=
"

Yesterday I've run a similar experiment with 40 and 8 GByte - same bad =
=20
behaviour:


# btrfs filesystem show
Label: none  uuid: da2f178e-a364-4494-a9e5-a7762ed81d10
	Total devices 2 FS bytes used 3.83GB
	devid    1 size 7.51GB used 6.13GB path /dev/sdb
	devid    2 size 37.27GB used 6.13GB path /dev/sdc

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D12.00GB, used=3D3.83GB
System, RAID1: total=3D8.00MB, used=3D4.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D128.00MB, used=3D4.47MB

# df -t btrfs
Dateisystem   Typ    1K-Bl=F6cke   Benutzt Verf=FCgbar Ben% Eingeh=E4ng=
t auf
/dev/sdb     btrfs    46963224   4021964  42667804   9% /mnt/btr


Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
