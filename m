Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:24116 "EHLO smtp3-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751943AbdJCPp4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Oct 2017 11:45:56 -0400
Date: Tue, 3 Oct 2017 17:45:54 +0200 (CEST)
From: fred.larive@free.fr
To: "Hugo Mills - hugo@carfax.org.uk"
        <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>
Cc: linux-btrfs@vger.kernel.org, btrfs fredo <btrfs.fredo@xoxy.net>
Message-ID: <762341433.435173804.1507045554405.JavaMail.root@zimbra65-e11.priv.proxad.net>
In-Reply-To: <20171003105405.GC3293@carfax.org.uk>
Subject: Re: Lost about 3TB
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,


>   What does "btrfs sub list -a /RAID01/" say?
Nothing (no lines displayed)

>   Also "grep /RAID01/ /proc/self/mountinfo"?
Nothing (no lines displayed)


Also server has been rebooted many times and no process has left "deleted open files" on the volume (lsof...).


Fred.


----- Mail original -----
De: "Hugo Mills - hugo@carfax.org.uk" <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>
À: "btrfs fredo" <btrfs.fredo@xoxy.net>
Cc: linux-btrfs@vger.kernel.org
Envoyé: Mardi 3 Octobre 2017 12:54:05
Objet: Re: Lost about 3TB

On Tue, Oct 03, 2017 at 12:44:29PM +0200, btrfs.fredo@xoxy.net wrote:
> Hi,
> 
> I can't figure out were 3TB on a 36 TB BTRFS volume (on LVM) are gone !
> 
> I know BTRFS can be tricky when speaking about space usage when using many physical drives in a RAID setup, but my conf is a very simple BTRFS volume without RAID(single Data type) using the whole disk (perhaps did I do something wrong with the LVM setup ?).
> 
> My BTRFS volume is mounted on /RAID01/.
> 
> There's only one folder in /RAID01/ shared with Samba, Windows also see a total of 28 TB used.
> 
> It only contains 443 files (big backup files created by Veeam), most of the file size is greater than 1GB and be be up to 5TB.
> 
> ######> du -hs /RAID01/
> 28T     /RAID01/
> 
> If I sum up the result of : ######> find . -printf '%s\n'
> I also find 28TB.
> 
> I extracted btrfs binary from rpm version v4.9.1 and used ######> btrfs fi du
> on each file and the result is 28TB.

   The conclusion here is that there are things that aren't being
found by these processes. This is usually in the form of dot-files
(but I think you've covered that case in what you did above) or
snapshots/subvolumes outside the subvol you've mounted.

   What does "btrfs sub list -a /RAID01/" say?
   Also "grep /RAID01/ /proc/self/mountinfo"?

   There are other possibilities for missing space, but let's cover
the obvious ones first.

   Hugo.

> OS : CentOS Linux release 7.3.1611 (Core)
> btrfs-progs v4.4.1
> 
> 
> ######> ssm list
> 
> -------------------------------------------------------------------------
> Device        Free      Used      Total  Pool                 Mount point
> -------------------------------------------------------------------------
> /dev/sda                       36.39 TB                       PARTITIONED
> /dev/sda1                     200.00 MB                       /boot/efi
> /dev/sda2                       1.00 GB                       /boot
> /dev/sda3  0.00 KB  36.32 TB   36.32 TB  lvm_pool
> /dev/sda4  0.00 KB  54.00 GB   54.00 GB  cl_xxx-xxxamrepo-01
> -------------------------------------------------------------------------
> -------------------------------------------------------------------
> Pool                    Type   Devices     Free      Used     Total
> -------------------------------------------------------------------
> cl_xxx-xxxamrepo-01     lvm    1        0.00 KB  54.00 GB  54.00 GB
> lvm_pool                lvm    1        0.00 KB  36.32 TB  36.32 TB
> btrfs_lvm_pool-lvol001  btrfs  1        4.84 TB  36.32 TB  36.32 TB
> -------------------------------------------------------------------
> ---------------------------------------------------------------------------------------------------------------------
> Volume                         Pool                    Volume size  FS        FS size       Free  Type    Mount point
> ---------------------------------------------------------------------------------------------------------------------
> /dev/cl_xxx-xxxamrepo-01/root  cl_xxx-xxxamrepo-01        50.00 GB  xfs      49.97 GB   48.50 GB  linear  /
> /dev/cl_xxx-xxxamrepo-01/swap  cl_xxx-xxxamrepo-01         4.00 GB                                linear
> /dev/lvm_pool/lvol001          lvm_pool                   36.32 TB                                linear  /RAID01
> btrfs_lvm_pool-lvol001         btrfs_lvm_pool-lvol001     36.32 TB  btrfs    36.32 TB    4.84 TB  btrfs   /RAID01
> /dev/sda1                                                200.00 MB  vfat                          part    /boot/efi
> /dev/sda2                                                  1.00 GB  xfs    1015.00 MB  882.54 MB  part    /boot
> ---------------------------------------------------------------------------------------------------------------------
> 
> 
> ######> btrfs fi sh
> 
> Label: none  uuid: df7ce232-056a-4c27-bde4-6f785d5d9f68
>         Total devices 1 FS bytes used 31.48TiB
>         devid    1 size 36.32TiB used 31.66TiB path /dev/mapper/lvm_pool-lvol001
> 
> 
> 
> ######> btrfs fi df /RAID01/
> 
> Data, single: total=31.58TiB, used=31.44TiB
> System, DUP: total=8.00MiB, used=3.67MiB
> Metadata, DUP: total=38.00GiB, used=35.37GiB
> GlobalReserve, single: total=512.00MiB, used=0.00B
> 
> 
> 
> I tried to repair it :
> 
> 
> ######> btrfs check --repair -p /dev/mapper/lvm_pool-lvol001
> 
> enabling repair mode
> Checking filesystem on /dev/mapper/lvm_pool-lvol001
> UUID: df7ce232-056a-4c27-bde4-6f785d5d9f68
> checking extents
> Fixed 0 roots.
> cache and super generation don't match, space cache will be invalidated
> checking fs roots
> checking csums
> checking root refs
> found 34600611349019 bytes used err is 0
> total csum bytes: 33752513152
> total tree bytes: 38037848064
> total fs tree bytes: 583942144
> total extent tree bytes: 653754368
> btree space waste bytes: 2197658704
> file data blocks allocated: 183716661284864 ?? what's this ??
>  referenced 30095956975616 = 27.3 TB !!
> 
> 
> 
> Tried the "new usage" display but the problem is the same : 31 TB used but total file size is 28TB
> 
> Overall:
>     Device size:                  36.32TiB
>     Device allocated:             31.65TiB
>     Device unallocated:            4.67TiB
>     Device missing:                  0.00B
>     Used:                         31.52TiB
>     Free (estimated):              4.80TiB      (min: 2.46TiB)
>     Data ratio:                       1.00
>     Metadata ratio:                   2.00
>     Global reserve:              512.00MiB      (used: 0.00B)
> 
> Data,single: Size:31.58TiB, Used:31.45TiB
>    /dev/mapper/lvm_pool-lvol001   31.58TiB
> 
> Metadata,DUP: Size:38.00GiB, Used:35.37GiB
>    /dev/mapper/lvm_pool-lvol001   76.00GiB
> 
> System,DUP: Size:8.00MiB, Used:3.69MiB
>    /dev/mapper/lvm_pool-lvol001   16.00MiB
> 
> Unallocated:
>    /dev/mapper/lvm_pool-lvol001    4.67TiB
> The only btrfs tool speaking about 28TB is btrfs check (but I'm not sure if it's bytes because it speaks about "referenced blocks" and I don't understand the meaning of "file data blocks allocated")
> Code:
> file data blocks allocated: 183716661284864 ?? what's this ??
>  referenced 30095956975616 = 27.3 TB !!
> 
> 
> 
> I also used the verbose option of https://github.com/knorrie/btrfs-heatmap/ to sum up the total size of all DATA EXTENT and found 32TB.
> 
> I did scrub, balance up to -dusage=90 (and also dusage=0) and ended up with 32TB used.
> No snasphots nor subvolumes nor TB hidden under the mount point after unmounting the BTRFS volume  
> 
> 
> What did I do wrong or am I missing ?
> 
> Thanks in advance.
> Frederic Larive.
> 

-- 
Hugo Mills             | Beware geeks bearing GIFs
hugo@... carfax.org.uk |
http://carfax.org.uk/  |
PGP: E2AB1DE4          |
