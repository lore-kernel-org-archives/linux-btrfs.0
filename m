Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from pecan2-mail.exetel.com.au ([220.233.0.71]:54140 "EHLO
	smtp.po.exetel.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363AbaKDD1k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 3 Nov 2014 22:27:40 -0500
From: Paul Jones <paul@pauljones.id.au>
To: Anand Jain <Anand.Jain@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: btrfs check - Couldn't open file system
Date: Tue, 4 Nov 2014 03:27:34 +0000
Message-ID: <B7F2379062E32745A8651FBDB20F64593F397B93@Server.waterlogic.com.au>
References: <B7F2379062E32745A8651FBDB20F64593F39764B@Server.waterlogic.com.au>
 <54584403.1080501@oracle.com>
In-Reply-To: <54584403.1080501@oracle.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for the help.
I tried btrfs-progs 3.16, same results.

IWT-VM ~ # blkid
/dev/sdb1: LABEL="Fast" UUID="c41dc6db-6f00-4d60-a2f7-acbceb25e4e7" UUID_SUB="0d26e72e-3848-455f-a250-56b442aa3bec" TYPE="btrfs" PARTUUID="000f11d6-01"
/dev/sdb2: LABEL="Root" UUID="61f6ce80-6d05-414f-9f0f-3d540fa82f2e" UUID_SUB="cb941fed-b0f5-4a3c-8407-919f8de730b2" TYPE="btrfs" PARTUUID="000f11d6-02"
/dev/sdd1: LABEL="Backup" UUID="92162be2-e52f-42fe-a9fd-da4f26c6abd1" UUID_SUB="988edf3f-616a-482d-a29a-dfd0d61185f8" TYPE="btrfs" PARTUUID="000963fc-01"
/dev/sdc1: LABEL="Backup" UUID="92162be2-e52f-42fe-a9fd-da4f26c6abd1" UUID_SUB="3be06b82-6e5a-4f3b-a01c-19a0ae75711e" TYPE="btrfs" PARTLABEL="Linux filesystem" PARTUUID="1128e68b-15ff-4279-b7a2-dfd4410d2c77"
/dev/sdf1: LABEL="Backup" UUID="92162be2-e52f-42fe-a9fd-da4f26c6abd1" UUID_SUB="c4573cea-cede-4143-a649-2cc3d97549a5" TYPE="btrfs" PARTLABEL="Linux filesystem" PARTUUID="4faf614b-8748-4464-b828-c26d1f477ca0"
/dev/sde3: LABEL="Backup" UUID="92162be2-e52f-42fe-a9fd-da4f26c6abd1" UUID_SUB="cfbc161b-8a80-4f8b-85d8-48703a1670ea" TYPE="btrfs" PARTLABEL="Backup" PARTUUID="f8626199-38c0-490e-851d-24230d374ce2"
/dev/sdg3: LABEL="Backup" UUID="92162be2-e52f-42fe-a9fd-da4f26c6abd1" UUID_SUB="6e395f0f-47d0-4fec-b509-19d6f8ff076d" TYPE="btrfs" PTTYPE="dos" PARTLABEL="Backup" PARTUUID="588303d8-5af0-48c6-8d85-7ef778c04783"
/dev/sdh1: LABEL="Fast" UUID="c41dc6db-6f00-4d60-a2f7-acbceb25e4e7" UUID_SUB="e513f51a-0014-4332-a3ea-a1296b22618d" TYPE="btrfs" PARTLABEL="Fast" PARTUUID="348b71c0-3353-46f9-a777-f63c68fdc934"
/dev/sdh2: LABEL="Swap2" UUID="10fd61ac-c911-4d0b-8b2e-b72b845fec28" TYPE="swap" PARTLABEL="Swap" PARTUUID="a09a4bd5-a098-4c6d-a668-627175cdd574"
/dev/sdi1: LABEL="Fast" UUID="c41dc6db-6f00-4d60-a2f7-acbceb25e4e7" UUID_SUB="2b8930e5-2fb9-4bb0-a67c-aa12aaea1640" TYPE="btrfs" PARTUUID="492b4f1e-71a8-4002-baeb-e17e584bd032"
/dev/sdi2: LABEL="Swap1" UUID="8f22117a-9cd7-4a50-8f92-b10ed2e890e3" TYPE="swap" PARTLABEL="Swap" PARTUUID="a09a4bd5-a098-4c6d-a668-627175cdd574"
/dev/sdi3: LABEL="Root" UUID="61f6ce80-6d05-414f-9f0f-3d540fa82f2e" UUID_SUB="36f3b7ca-70fd-4188-91c6-87bbb4914ffb" TYPE="btrfs" PARTUUID="cbdc9b38-d8a5-4b2a-9050-bdfc6d9ee1f1"
/dev/sr0: UUID="2011-12-21-00-52-16-00" LABEL="DA 5.0 (2)" TYPE="iso9660"
/dev/sdj1: LABEL="Data" UUID="89181f84-bace-43f8-9534-693f99c4d033" UUID_SUB="2c35cfb9-e7c5-4258-8a66-0eabe763e1d9" TYPE="btrfs" PARTUUID="c193216e-01"
/dev/sda1: LABEL="Data" UUID="89181f84-bace-43f8-9534-693f99c4d033" UUID_SUB="c0dcd706-cffc-41ce-a633-3fa501b8ddd3" TYPE="btrfs" PARTUUID="ad3ee8a5-01"
/dev/sde1: PARTLABEL="Grub" PARTUUID="79155d93-6922-462e-be91-fbc35eb16051"
/dev/sde2: PARTUUID="0d4f7267-afe9-45af-a833-f4d618aedbf9"
/dev/sdg1: PARTLABEL="Grub" PARTUUID="79155d93-6922-462e-be91-fbc35eb16051"
/dev/sdg2: PARTUUID="d9e177f6-2b38-4e9f-8c5c-96c0f5234f46"



-----Original Message-----
From: Anand Jain [mailto:Anand.Jain@oracle.com] 
Sent: Tuesday, 4 November 2014 2:12 PM
To: Paul Jones; linux-btrfs@vger.kernel.org
Subject: Re: btrfs check - Couldn't open file system


  very strange. I have no clue, yet. also bit concerned if this
  turns out to be a real issue. hope you could help to narrow down.

  can you send `blkid` output from your system.
And
  can you go back to 3.16 and check if you have the same issue.

thanks, anand


> IWT-VM ~ # uname -a
> Linux IWT-VM 3.17.2-gentoo #1 SMP Mon Nov 3 15:46:50 AEDT 2014 x86_64 
> Intel(R) Xeon(R) CPU E5-2620 0 @ 2.00GHz GenuineIntel GNU/Linux IWT-VM 
> ~ # mount
> /dev/sdb2 on / type btrfs 
> (rw,noatime,compress=zlib,ssd,noacl,space_cache)
> /dev/sdh1 on /media/fast type btrfs (rw,noatime,ssd,noacl,space_cache)
> /dev/sdg3 on /media/backup type btrfs 
> (rw,noatime,compress=zlib,noacl,space_cache)
> /dev/sda1 on /media/data type btrfs 
> (rw,noatime,compress=zlib,noacl,space_cache)
> IWT-VM ~ # btrfs fi sh
> Label: 'Root'  uuid: 61f6ce80-6d05-414f-9f0f-3d540fa82f2e
>          Total devices 2 FS bytes used 6.58GiB
>          devid    4 size 60.00GiB used 18.03GiB path /dev/sdb2
>          devid    5 size 59.93GiB used 18.03GiB path /dev/sdi3
>
> Label: 'Fast'  uuid: c41dc6db-6f00-4d60-a2f7-acbceb25e4e7
>          Total devices 3 FS bytes used 396.85GiB
>          devid    1 size 471.93GiB used 416.02GiB path /dev/sdh1
>          devid    2 size 412.00GiB used 356.01GiB path /dev/sdi1
>          devid    3 size 163.57GiB used 108.01GiB path /dev/sdb1
>
> Label: 'Backup'  uuid: 92162be2-e52f-42fe-a9fd-da4f26c6abd1
>          Total devices 5 FS bytes used 2.74TiB
>          devid    6 size 891.50GiB used 822.00GiB path /dev/sdg3
>          devid    8 size 698.64GiB used 629.00GiB path /dev/sdd1
>          devid    9 size 891.51GiB used 821.03GiB path /dev/sde3
>          devid   10 size 2.73TiB used 2.66TiB path /dev/sdc1
>          devid   11 size 931.51GiB used 924.00GiB path /dev/sdf1
>
> Label: 'Data'  uuid: 89181f84-bace-43f8-9534-693f99c4d033
>          Total devices 2 FS bytes used 42.50GiB
>          devid    1 size 279.46GiB used 211.03GiB path /dev/sda1
>          devid    2 size 279.46GiB used 211.03GiB path /dev/sdj1
>
> Btrfs v3.17
> IWT-VM ~ # umount /media/backup
> umount: /media/backup: not mounted
> IWT-VM ~ # btrfs check /dev/sdg3
> Couldn't open file system
> IWT-VM ~ # btrfs check /dev/sdd1
> Couldn't open file system
> IWT-VM ~ # btrfs check /dev/sde3
> Couldn't open file system
> IWT-VM ~ # btrfs check /dev/sda1
> Checking filesystem on /dev/sda1
> UUID: 89181f84-bace-43f8-9534-693f99c4d033
> checking extents
> checking free space cache
> checking fs roots
> checking csums
> checking root refs
> found 38060448123 bytes used err is 0
> total csum bytes: 44401072
> total tree bytes: 110723072
> total fs tree bytes: 50872320
> total extent tree bytes: 9994240
> btree space waste bytes: 12145264
> file data blocks allocated: 45618331648
>   referenced 48120782848
> Btrfs v3.17
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" 
> in the body of a message to majordomo@vger.kernel.org More majordomo 
> info at  http://vger.kernel.org/majordomo-info.html
>
