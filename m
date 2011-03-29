From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: How to remove a device on a RAID-1 before replacing it?
Date: 29 Mar 2011 22:45:00 +0200
Message-ID: <BilctUzD1uB@helmut.hullen.de>
References: <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=SiesmPbkwoCHSpxDaLK_S8EcZEbBBtVFZUV_j@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, cwillu,

Du meintest am 29.03.11:

>> I have a disk with a SMART failure. =A0It still works but I assume
>> it'll fail sooner or later.
>>
>> I want to remove it from my btrfs volume, replace it, and add the
>> new one. =A0But the obvious command doesn't work:

[...]


> There's no "nice" way to remove a failing disk in btrfs right now
> ("btrfs dev delete" is more of a online management thing to politely
> remove a perfectly functional disk you'd like to use for something
> else.)

Nice hope, but even "btrfs device delete /dev/sdxn /mnt/btr" doesn't  =20
work well.

I've tried it, with kernel 2.6.38.1 ...

# mkfs.btrfs -L SCSI -m raid0 /dev/sda1
# mount LABEL=3DSCSI /mnt/btr

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 1 FS bytes used 28.00KB
	devid    1 size 4.04GB used 20.00MB path /dev/sda1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D8.00MB, used=3D0.00
System: total=3D4.00MB, used=3D8.00KB
Metadata: total=3D8.00MB, used=3D20.00KB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs     4232556        28   4220224   1% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
#------------------------------------------------------------
# btrfs device add /dev/sdc1 /mnt/btr

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 2 FS bytes used 28.00KB
	devid    1 size 4.04GB used 433.31MB path /dev/sda1
	devid    2 size 8.54GB used 0.00 path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D421.31MB, used=3D0.00
System: total=3D4.00MB, used=3D4.00KB
Metadata: total=3D8.00MB, used=3D24.00KB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs    13189632        28  13176256   1% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
#------------------------------------------------------------
# 2 GByte kopiert

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 2 FS bytes used 2.10GB
	devid    1 size 4.04GB used 433.31MB path /dev/sda1
	devid    2 size 8.54GB used 2.25GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D2.41GB, used=3D2.10GB
System: total=3D4.00MB, used=3D4.00KB
Metadata: total=3D264.00MB, used=3D2.79MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs    13189632   2202740  10714232  18% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
#------------------------------------------------------------
# 7 GByte kopiert

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 2 FS bytes used 9.03GB
	devid    1 size 4.04GB used 1.42GB path /dev/sda1
	devid    2 size 8.54GB used 8.25GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D9.41GB, used=3D9.02GB
System: total=3D4.00MB, used=3D4.00KB
Metadata: total=3D264.00MB, used=3D11.80MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs    13189632   9467164   3459032  74% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
#------------------------------------------------------------
# btrfs device add /dev/sdb1 /mnt/btr

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 3 FS bytes used 9.12GB
	devid    3 size 136.73GB used 0.00 path /dev/sdb1
	devid    1 size 4.04GB used 1.42GB path /dev/sda1
	devid    2 size 8.54GB used 8.25GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data: total=3D9.41GB, used=3D9.10GB
System: total=3D4.00MB, used=3D4.00KB
Metadata: total=3D264.00MB, used=3D11.91MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs   156562592   9559000 146739216   7% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
/dev/sdb
   1            2048       286747966   136.7 GiB   0700  Linux/Windows =
data
#------------------------------------------------------------
# btrfs filesystem balance /mnt/btr

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 3 FS bytes used 9.11GB
	devid    3 size 136.73GB used 10.61GB path /dev/sdb1
	devid    1 size 4.04GB used 3.70GB path /dev/sda1
	devid    2 size 8.54GB used 8.08GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D21.89GB, used=3D9.10GB
System: total=3D4.00MB, used=3D4.00KB
Metadata, RAID0: total=3D511.88MB, used=3D10.15MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs   156562592   9557196  14370128  40% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
/dev/sdb
   1            2048       286747966   136.7 GiB   0700  Linux/Windows =
data
#------------------------------------------------------------
# 8 GByte kopiert

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 3 FS bytes used 17.02GB
	devid    3 size 136.73GB used 10.61GB path /dev/sdb1
	devid    1 size 4.04GB used 3.70GB path /dev/sda1
	devid    2 size 8.54GB used 8.08GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D21.89GB, used=3D17.00GB
System: total=3D4.00MB, used=3D4.00KB
Metadata, RAID0: total=3D511.88MB, used=3D18.66MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs   156562592  17850436   6085608  75% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
/dev/sdb
   1            2048       286747966   136.7 GiB   0700  Linux/Windows =
data
#------------------------------------------------------------
# btrfs filesystem balance /mnt/btr

# btrfs filesystem show
Label: 'SCSI'  uuid: 4d834705-5a65-4d1f-a8a0-a5ea9348db50
	Total devices 3 FS bytes used 17.08GB
	devid    3 size 136.73GB used 9.08GB path /dev/sdb1
	devid    1 size 4.04GB used 2.09GB path /dev/sda1
	devid    2 size 8.54GB used 8.08GB path /dev/sdc1

Btrfs Btrfs v0.19

# btrfs filesystem df /mnt/btr
Data, RAID0: total=3D19.00GB, used=3D17.06GB
System: total=3D4.00MB, used=3D4.00KB
Metadata, RAID0: total=3D255.94MB, used=3D18.51MB

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sda1    btrfs   156562592  17911352   6118356  75% /mnt/btr

# gdisk -l
/dev/sda
   1            2048         8467166   4.0 GiB     0700  Linux/Windows =
data
/dev/sdc
   1            2048        17916206   8.5 GiB     0700  Linux/Windows =
data
/dev/sdb
   1            2048       286747966   136.7 GiB   0700  Linux/Windows =
data
#------------------------------------------------------------



and then follows the problem I've told last year: "no space left on =20
device ...". In this special case: even not enough place for deleting =20
one partition.

Trying "btrfs device delete ..." without previous "balance" leads to

# btrfs device delete /dev/sdc1 /mnt/btr
# endet mit "error removing the device '/dev/sdc1'"


Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
