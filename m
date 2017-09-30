Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16-i6.italiaonline.it ([213.209.14.16]:48867 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752157AbdI3LkY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 30 Sep 2017 07:40:24 -0400
Reply-To: kreijack@inwind.it
Subject: Re: Can't remove device -> I/O error
To: DocMAX <docmax1978@gmail.com>, linux-btrfs@vger.kernel.org
References: <CACJO8mcmabFc1CdhVr+Xj=NH1h2zy5eMOeD-8+UGkXODH34rVQ@mail.gmail.com>
 <3b9a14cb-a88c-4604-6d36-d2706796acfd@libero.it>
 <cc58b693-a7f9-5373-0fdd-542e691de936@gmail.com>
 <1a111a09-b421-baf7-800b-f24dcdc84a82@inwind.it>
 <7d9687eb-8322-9a75-a4ce-80eb64e7a0ed@gmail.com>
 <a6b8c59a-dd64-daba-353a-b3299e977148@inwind.it>
 <7592946d-234c-5e34-b24c-19cac802fe39@gmail.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <a374571f-a9ac-458d-31a7-8c07787aaeb3@inwind.it>
Date: Sat, 30 Sep 2017 13:40:21 +0200
MIME-Version: 1.0
In-Reply-To: <7592946d-234c-5e34-b24c-19cac802fe39@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/30/2017 12:40 PM, DocMAX wrote:
> I removed with "echo" command and also physically.
> 
> Both quit with I/O error.

Below the step which I used to simulate (in a virtual machine) your issue:

### created the filesystem, and populated it (with about 500MB)
$ sudo mkfs.btrfs --force -d RAID5 -m RAID1 /dev/vd[bcd] /dev/sda
btrfs-progs v4.7.3
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (10.00GiB) ...
Label:              (null)
UUID:               
Node size:          16384
Sector size:        4096
Filesystem size:    40.00GiB
Block group profiles:
  Data:             RAID5             3.00GiB
  Metadata:         RAID1             1.00GiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, raid56, skinny-metadata
Number of devices:  4
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/vdb
    2    10.00GiB  /dev/vdc
    3    10.00GiB  /dev/vdd
    4    10.00GiB  /dev/sda

ghigo@emulato:~$ sudo mount /dev/sda /mnt/btrfs1
ghigo@emulato:~$ sudo cp -rfa /lib/modules/ /mnt/btrfs1/
ghigo@emulato:~$ sudo umount /mnt/btrfs1/

###### remove the device, note that after this step /dev/sda is unreacheble
###### both from userspace and kernel space

ghigo@emulato:~$ sudo -i
root@emulato:~# echo 1 >/sys/block/sda/device/delete 
root@emulato:~# logout

###### mount the filesystem in "degraded mode" and delete the missing device
######

ghigo@emulato:~$ sudo mount -o degraded /dev/vdb /mnt/btrfs1
ghigo@emulato:~$ sudo btrfs dev us /mnt/btrfs1/
/dev/sda, ID: 4
   Device size:               0.00B
   Device slack:           16.00EiB
   Data,RAID5:              1.00GiB
   System,RAID1:            8.00MiB
   Unallocated:             8.99GiB

/dev/vdb, ID: 1
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             8.00GiB

/dev/vdc, ID: 2
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             8.00GiB

/dev/vdd, ID: 3
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   System,RAID1:            8.00MiB
   Unallocated:             8.99GiB

ghigo@emulato:~$ sudo btrfs dev del missing /mnt/btrfs1/

$ sudo btrfs fi us /mnt/btrfs1/
WARNING: RAID56 detected, not implemented
Overall:
    Device size:		  30.00GiB
    Device allocated:		   2.06GiB
    Device unallocated:		  27.94GiB
    Device missing:		     0.00B
    Used:			  47.97MiB
    Free (estimated):		     0.00B	(min: 8.00EiB)
    Data ratio:			      0.00
    Metadata ratio:		      2.00
    Global reserve:		  16.00MiB	(used: 0.00B)

Data,RAID5: Size:2.00GiB, Used:1.54GiB
   /dev/vdb	   1.00GiB
   /dev/vdc	   1.00GiB
   /dev/vdd	   1.00GiB

Metadata,RAID1: Size:1.00GiB, Used:23.97MiB
   /dev/vdb	   1.00GiB
   /dev/vdc	   1.00GiB

System,RAID1: Size:32.00MiB, Used:16.00KiB
   /dev/vdc	  32.00MiB
   /dev/vdd	  32.00MiB

Unallocated:
   /dev/vdb	   8.00GiB
   /dev/vdc	   7.97GiB
   /dev/vdd	   8.97GiB


And I don't have any error in dmesg;

I made another test: I remove the device without "umount/mount -o degrade"

# create the filesystem and populate with about 1Gb of data

$ sudo mkfs.btrfs --force -d RAID5 -m RAID1 /dev/vd[bcd] /dev/sda
btrfs-progs v4.7.3
See http://btrfs.wiki.kernel.org for more information.

Performing full device TRIM (10.00GiB) ...
Label:              (null)
UUID:               
Node size:          16384
Sector size:        4096
Filesystem size:    40.00GiB
Block group profiles:
  Data:             RAID5             3.00GiB
  Metadata:         RAID1             1.00GiB
  System:           RAID1             8.00MiB
SSD detected:       no
Incompat features:  extref, raid56, skinny-metadata
Number of devices:  4
Devices:
   ID        SIZE  PATH
    1    10.00GiB  /dev/vdb
    2    10.00GiB  /dev/vdc
    3    10.00GiB  /dev/vdd
    4    10.00GiB  /dev/sda

ghigo@emulato:~$ sudo mount /dev/vdb /mnt/btrfs1
ghigo@emulato:~$ sudo cp -rfa /lib/modules/ /mnt/btrfs1/

ghigo@emulato:~$ df -h
Filesystem      Size  Used Avail Use% Mounted on
udev            1.5G     0  1.5G   0% /dev
tmpfs           302M  4.3M  297M   2% /run
/dev/vda         99G  4.5G   89G   5% /
tmpfs           1.5G     0  1.5G   0% /dev/shm
tmpfs           5.0M     0  5.0M   0% /run/lock
tmpfs           1.5G     0  1.5G   0% /sys/fs/cgroup
tmpfs           302M     0  302M   0% /run/user/1000
/dev/vdb         40G  1.7G   36G   5% /mnt/btrfs1
ghigo@emulato:~$ sudo btrfs fi df /mnt/btrfs1/
Data, RAID5: total=3.00GiB, used=1.54GiB
System, RAID1: total=8.00MiB, used=16.00KiB
Metadata, RAID1: total=1.00GiB, used=22.72MiB
GlobalReserve, single: total=16.00MiB, used=0.00B

#### remove the device /dev/sda ( id == 4)
#### note because /dev/sda doesn't exist anymore, I had to pass the id
#### of the device instead the path in "btrfs dev del..."

ghigo@emulato:~$ sudo -i
root@emulato:~# echo 1 >/sys/block/sda/device/delete 

root@emulato:~# btrfs dev us /mnt/btrfs1/
/dev/sda, ID: 4
   Device size:               0.00B
   Device slack:           16.00EiB
   Data,RAID5:              1.00GiB
   Metadata,RAID1:        256.00MiB
   System,RAID1:           32.00MiB
   Unallocated:             8.72GiB

/dev/vdb, ID: 1
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             8.00GiB

/dev/vdc, ID: 2
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   Metadata,RAID1:          1.00GiB
   Unallocated:             8.00GiB

/dev/vdd, ID: 3
   Device size:            10.00GiB
   Device slack:              0.00B
   Data,RAID5:              1.00GiB
   Metadata,RAID1:        256.00MiB
   System,RAID1:           32.00MiB
   Unallocated:             8.72GiB

root@emulato:~# btrfs dev del 4 /mnt/btrfs1/

In the dmesg *few* errors where present, but the process was successfully and the I was able to perform a scrub process without any issue




root@emulato:~# btrfs scrub start /mnt/btrfs1/
scrub started on /mnt/btrfs1/, fsid 9b13bdf1-539f-4529-bbc7-f392a072ee5c (pid=689)
[....]
root@emulato:~# btrfs scrub status /mnt/btrfs1/
scrub status for 9b13bdf1-539f-4529-bbc7-f392a072ee5c
	scrub started at Sat Sep 30 13:30:35 2017 and finished after 00:00:14
	total bytes scrubbed: 1.59GiB with 0 errors


In both the case the device delete phase was done in few seconds (about 30-60 secon for 1GB of data). It was in a emulated environment, but I suppose that also on the bare metal it will be quite quick.

BR
G.Baroncelli

> 
> 
> 
> Am 30.09.2017 um 09:16 schrieb Goffredo Baroncelli:
>> On 09/30/2017 01:06 AM, DocMAX wrote:
>>>>> Did you removed the disk before mounting (physically or doing echo 1 >/sys/block/xxx/device/delete)? Which steps you performed ?
>>> - removed drive physically
>>>
>>> - mounted degraded mode
>>>
>>> - btrfs dev del -> same i/o error
>>>
>> Did you switch off the machine ? If not, before mounting in degraded mode, do "echo 1 >/sys/block/xxx/device/delete". After the monting do a btrfs dev del missing
>>
>>
>>
>>
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
