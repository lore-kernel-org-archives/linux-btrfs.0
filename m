From: "Helmut Hullen" <Hullen@t-online.de>
Subject: Re: wrong values in "df" and "btrfs filesystem df"
Date: 09 Apr 2011 14:28:00 +0200
Message-ID: <BjW+whfD1uB@helmut.hullen.de>
References: <20110409091141.GE5301@carfax.org.uk>
Reply-To: helmut@hullen.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110409091141.GE5301@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Hallo, Hugo,

Du meintest am 09.04.11:

>>   df /srv/MM
>>   btrfs filesystem df /srv/MM
>>
>> show some completely wrong values:
>>
>> # df /srv/MM
>>
>> Filesystem           1K-blocks      Used Available Use% Mounted on
>> /dev/sdd1            5846053400 1593436456 2898463184  36% /srv/MM
>>
>> # btrfs filesystem df /srv/MM
>>
>> Data, RAID0: total=3D1.67TB, used=3D1.48TB
>> System, RAID1: total=3D16.00MB, used=3D112.00KB
>> System: total=3D4.00MB, used=3D0.00
>> Metadata, RAID1: total=3D3.75GB, used=3D2.26GB
>>
>> # btrfs-show
>>
>> Label: MMedia  uuid: 120b036a-883f-46aa-bd9a-cb6a1897c8d2
>> 	Total devices 3 FS bytes used 1.48TB
>> 	devid    3 size 1.81TB used 573.76GB path /dev/sdb1
>> 	devid    2 size 1.81TB used 573.77GB path /dev/sde1
>> 	devid    1 size 1.82TB used 570.01GB path /dev/sdd1
>>
>> Btrfs Btrfs v0.19
>>
>> ------------------------------------------------
>>
>> "df" shows an "Available" value which isn't related to any real
>> value.

>    I _think_ that value is the amount of space not allocated to any
> block group. If that's so, then Available (from df) plus the three
> "total" values (from btrfs fi df) should equal the size value from
> df.

I'm not convinced - sorry.

"used" plus "available" should be nearly the same value as the "total" =
=20
in "df"; in my example 1.6 TB + 2.9 TB is far away from the total of 5.=
8 =20
TB (here: Tera =3D 10^9).

>    The total value in the output of "btrfs fi df" is the total space
> allocated to block groups. As the filesystem needs more space, it
> will allocate more block groups from the available raw storage pool,
> and the number will go up.

>    This is explained on the wiki at [1].

I've studied the page - the data shown there looks to be consistent. =20
Especially: "used" plus "avail" =3D "size"

-------------------------------------

The data seems (mostly) to be consistent on a new array of disks/=20
partitions. But when I work with "device add" and "device delete" then
there are holes.

Another machine:

/dev/sda about 140 GB
/dev/sdb about 140 GB
/dev/sdc about  70 GB

# mkfs.btrfs -L SCSI -d raid0 -m raid1 /dev/sdb1 /dev/sdc1
# mit 70 GByte gef=FCllt

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1    btrfs   214058944  73956996  65522124  54% /mnt/SCSI

# btrfs filesystem show
Label: 'SCSI'  uuid: 1932d11d-021a-4054-8429-db25a0204221
	Total devices 2 FS bytes used 70.43GB
	devid    1 size 136.73GB used 37.03GB path /dev/sdb1
	devid    2 size 67.41GB used 37.01GB path /dev/sdc1

# btrfs filesystem df /mnt/SCSI
Data, RAID0: total=3D72.00GB, used=3D70.33GB
Data: total=3D8.00MB, used=3D0.00
System, RAID1: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D1.00GB, used=3D104.78MB
Metadata: total=3D8.00MB, used=3D0.00

#------------------------------------------------------------
# btrfs device add /dev/sda1 /mnt/SCSI

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1    btrfs   356234160  84177056 200667344  30% /mnt/SCSI

# btrfs filesystem show
Label: 'SCSI'  uuid: 1932d11d-021a-4054-8429-db25a0204221
	Total devices 3 FS bytes used 80.16GB
	devid    1 size 136.73GB used 42.03GB path /dev/sdb1
	devid    3 size 135.59GB used 0.00 path /dev/sda1
	devid    2 size 67.41GB used 42.01GB path /dev/sdc1

# btrfs filesystem df /mnt/SCSI
Data, RAID0: total=3D82.00GB, used=3D80.04GB
Data: total=3D8.00MB, used=3D0.00
System, RAID1: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D1.00GB, used=3D119.54MB
Metadata: total=3D8.00MB, used=3D0.00

#------------------------------------------------------------
# btrfs fi balance /mnt/SCSI

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1    btrfs   356234160  84125344 228211536  27% /mnt/SCSI

# btrfs filesystem show
Label: 'SCSI'  uuid: 1932d11d-021a-4054-8429-db25a0204221
	Total devices 3 FS bytes used 80.14GB
	devid    1 size 136.73GB used 28.28GB path /dev/sdb1
	devid    3 size 135.59GB used 27.00GB path /dev/sda1
	devid    2 size 67.41GB used 29.01GB path /dev/sdc1

# btrfs filesystem df /mnt/SCSI
Data, RAID0: total=3D81.00GB, used=3D80.04GB
Data: total=3D8.00MB, used=3D0.00
System, RAID1: total=3D8.00MB, used=3D12.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D1.25GB, used=3D94.29MB
Metadata: total=3D8.00MB, used=3D0.00

#------------------------------------------------------------
# btrfs device delete /dev/sdc1 /mnt/SCSI
# umount /mnt/SCSI
# mount LABEL=3DSCSI /mnt/SCSI

# df -t btrfs
=46ilesystem    Type   1K-blocks      Used Available Use% Mounted on
/dev/sdb1    btrfs   285548192 232024076  51758540  82% /mnt/SCSI

# btrfs filesystem show
Label: 'SCSI'  uuid: 1932d11d-021a-4054-8429-db25a0204221
	Total devices 2 FS bytes used 221.04GB
	devid    1 size 136.73GB used 111.51GB path /dev/sdb1
	devid    3 size 135.59GB used 111.51GB path /dev/sda1

# btrfs filesystem df /mnt/SCSI
Data, RAID0: total=3D222.00GB, used=3D220.80GB
System, RAID1: total=3D8.00MB, used=3D24.00KB
System: total=3D4.00MB, used=3D0.00
Metadata, RAID1: total=3D512.00MB, used=3D243.77MB

--------------------------------------------------------------

What "df" shows as "available" immediately after creation is wrong.
What it shows after "device add" is wrong.
What it shows after "balance" is wrong.
What it shows after "device delete" looks ok.

Ok - now I presume that sometimes "df" or/and the "btrfs" commands only=
 =20
show wrong values, but the system works with the right values (there is=
t =20
more free space than shown). But I fear that's not reliable.

--------------------------------

I also write scripts etc; I know since decades it's easy to make =20
mistakes, but sometimes it's hard work to find them.

Viele Gruesse!
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
