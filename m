Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp4-g21.free.fr ([212.27.42.4]:7060 "EHLO smtp4-g21.free.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751696AbdJDMni (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Oct 2017 08:43:38 -0400
Date: Wed, 4 Oct 2017 14:43:36 +0200 (CEST)
From: fred.larive@free.fr
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "Hugo Mills - hugo@carfax.org.uk"
        <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>,
        linux-btrfs@vger.kernel.org, btrfs fredo <btrfs.fredo@xoxy.net>
Message-ID: <1056011246.439226457.1507121016352.JavaMail.root@zimbra65-e11.priv.proxad.net>
In-Reply-To: <20171003160004.GD3293@carfax.org.uk>
Subject: Re: Lost about 3TB
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

thanks all for your fast support.

I did some stats about fragmentation (I didn't do it before because, I wrongly thought it was nearly the same as chunk balance).
As Timofey suspected I have some big files (5TB) heavily fragmented.

The software writting in these files is a backup software called Veeam, working at block level of virtual machines : it create an image of the virtual disk and the incremental backup only takes care about newly changed blocks.
But we use it each month to "synthetically" create monthly backup restore point.

So yes, most of write is sparse write of small blocks, this server is over a WAN link and Veeam is incredbly robust allowing us to break a backup job and continue it later (but taking in account new source blocks) without resending the whole file, the result is then fragmented (I traced it during restore job and can see that it is able to find needed blocks on every received disks images even in broken ones !).

To sum up :
Each files extent average size is 15MB, but at least 30MB (up to 60MB) since I balanced the volume.
But I have four 5TB files with average extent size being between 3 to 7 MB split over about 1 to 2 million extents.

I tried defrag on some 30000 extents files dividing the extent number by two and freeing some used space.

I'm now defragging the whole volume with "-t 128M", permitting to free 200GB in one hour.

I think you hit my problem.
I'll keep you in touch, I think tomorrow.
Thank's again.

Fred.

----- Mail original -----
De: "Hugo Mills" <hugo@carfax.org.uk>
À: "fred larive" <fred.larive@free.fr>
Cc: "Hugo Mills - hugo@carfax.org.uk" <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>, linux-btrfs@vger.kernel.org, "btrfs fredo" <btrfs.fredo@xoxy.net>
Envoyé: Mardi 3 Octobre 2017 18:00:04
Objet: Re: Lost about 3TB

On Tue, Oct 03, 2017 at 05:45:54PM +0200, fred.larive@free.fr wrote:
> Hi,
> 
> 
> >   What does "btrfs sub list -a /RAID01/" say?
> Nothing (no lines displayed)
> 
> >   Also "grep /RAID01/ /proc/self/mountinfo"?
> Nothing (no lines displayed)
> 
> 
> Also server has been rebooted many times and no process has left "deleted open files" on the volume (lsof...).

   OK. The second command (the grep) was incorrect -- I should have
omitted the slashes. However, it doesn't matter too much, because the
first command indicates that you don't have any subvolumes or
snapshots anyway.

   This means that you're probably looking at the kind of issue
Timofey mentioned in his mail, where writes into the middle of an
existing extent don't free up the overwritten data. This is most
likely to happen on database or VM files, but could happen on others,
depending on the application and how it uses files.

   Since you don't seem to have any snapshots, I _think_ you can deal
with the issue most easily by defragmenting the affected files. It's
worth just getting a second opinion on this one before you try it for
the whole FS. I'm not 100% sure about what defrag will do in this
case, and there are some people round here who have investigated the
behaviour of partially-overwritten extents in more detail than I have.

   Hugo.

> Fred.
> 
> 
> ----- Mail original -----
> De: "Hugo Mills - hugo@carfax.org.uk" <btrfs.fredo.d1c3ddb588.hugo#carfax.org.uk@ob.0sg.net>
> À: "btrfs fredo" <btrfs.fredo@xoxy.net>
> Cc: linux-btrfs@vger.kernel.org
> Envoyé: Mardi 3 Octobre 2017 12:54:05
> Objet: Re: Lost about 3TB
> 
> On Tue, Oct 03, 2017 at 12:44:29PM +0200, btrfs.fredo@xoxy.net wrote:
> > Hi,
> > 
> > I can't figure out were 3TB on a 36 TB BTRFS volume (on LVM) are gone !
> > 
> > I know BTRFS can be tricky when speaking about space usage when using many physical drives in a RAID setup, but my conf is a very simple BTRFS volume without RAID(single Data type) using the whole disk (perhaps did I do something wrong with the LVM setup ?).
> > 
> > My BTRFS volume is mounted on /RAID01/.
> > 
> > There's only one folder in /RAID01/ shared with Samba, Windows also see a total of 28 TB used.
> > 
> > It only contains 443 files (big backup files created by Veeam), most of the file size is greater than 1GB and be be up to 5TB.
> > 
> > ######> du -hs /RAID01/
> > 28T     /RAID01/
> > 
> > If I sum up the result of : ######> find . -printf '%s\n'
> > I also find 28TB.
> > 
> > I extracted btrfs binary from rpm version v4.9.1 and used ######> btrfs fi du
> > on each file and the result is 28TB.
> 
>    The conclusion here is that there are things that aren't being
> found by these processes. This is usually in the form of dot-files
> (but I think you've covered that case in what you did above) or
> snapshots/subvolumes outside the subvol you've mounted.
> 
>    What does "btrfs sub list -a /RAID01/" say?
>    Also "grep /RAID01/ /proc/self/mountinfo"?
> 
>    There are other possibilities for missing space, but let's cover
> the obvious ones first.
> 
>    Hugo.
> 
> > OS : CentOS Linux release 7.3.1611 (Core)
> > btrfs-progs v4.4.1
> > 
> > 
> > ######> ssm list
> > 
> > -------------------------------------------------------------------------
> > Device        Free      Used      Total  Pool                 Mount point
> > -------------------------------------------------------------------------
> > /dev/sda                       36.39 TB                       PARTITIONED
> > /dev/sda1                     200.00 MB                       /boot/efi
> > /dev/sda2                       1.00 GB                       /boot
> > /dev/sda3  0.00 KB  36.32 TB   36.32 TB  lvm_pool
> > /dev/sda4  0.00 KB  54.00 GB   54.00 GB  cl_xxx-xxxamrepo-01
> > -------------------------------------------------------------------------
> > -------------------------------------------------------------------
> > Pool                    Type   Devices     Free      Used     Total
> > -------------------------------------------------------------------
> > cl_xxx-xxxamrepo-01     lvm    1        0.00 KB  54.00 GB  54.00 GB
> > lvm_pool                lvm    1        0.00 KB  36.32 TB  36.32 TB
> > btrfs_lvm_pool-lvol001  btrfs  1        4.84 TB  36.32 TB  36.32 TB
> > -------------------------------------------------------------------
> > ---------------------------------------------------------------------------------------------------------------------
> > Volume                         Pool                    Volume size  FS        FS size       Free  Type    Mount point
> > ---------------------------------------------------------------------------------------------------------------------
> > /dev/cl_xxx-xxxamrepo-01/root  cl_xxx-xxxamrepo-01        50.00 GB  xfs      49.97 GB   48.50 GB  linear  /
> > /dev/cl_xxx-xxxamrepo-01/swap  cl_xxx-xxxamrepo-01         4.00 GB                                linear
> > /dev/lvm_pool/lvol001          lvm_pool                   36.32 TB                                linear  /RAID01
> > btrfs_lvm_pool-lvol001         btrfs_lvm_pool-lvol001     36.32 TB  btrfs    36.32 TB    4.84 TB  btrfs   /RAID01
> > /dev/sda1                                                200.00 MB  vfat                          part    /boot/efi
> > /dev/sda2                                                  1.00 GB  xfs    1015.00 MB  882.54 MB  part    /boot
> > ---------------------------------------------------------------------------------------------------------------------
> > 
> > 
> > ######> btrfs fi sh
> > 
> > Label: none  uuid: df7ce232-056a-4c27-bde4-6f785d5d9f68
> >         Total devices 1 FS bytes used 31.48TiB
> >         devid    1 size 36.32TiB used 31.66TiB path /dev/mapper/lvm_pool-lvol001
> > 
> > 
> > 
> > ######> btrfs fi df /RAID01/
> > 
> > Data, single: total=31.58TiB, used=31.44TiB
> > System, DUP: total=8.00MiB, used=3.67MiB
> > Metadata, DUP: total=38.00GiB, used=35.37GiB
> > GlobalReserve, single: total=512.00MiB, used=0.00B
> > 
> > 
> > 
> > I tried to repair it :
> > 
> > 
> > ######> btrfs check --repair -p /dev/mapper/lvm_pool-lvol001
> > 
> > enabling repair mode
> > Checking filesystem on /dev/mapper/lvm_pool-lvol001
> > UUID: df7ce232-056a-4c27-bde4-6f785d5d9f68
> > checking extents
> > Fixed 0 roots.
> > cache and super generation don't match, space cache will be invalidated
> > checking fs roots
> > checking csums
> > checking root refs
> > found 34600611349019 bytes used err is 0
> > total csum bytes: 33752513152
> > total tree bytes: 38037848064
> > total fs tree bytes: 583942144
> > total extent tree bytes: 653754368
> > btree space waste bytes: 2197658704
> > file data blocks allocated: 183716661284864 ?? what's this ??
> >  referenced 30095956975616 = 27.3 TB !!
> > 
> > 
> > 
> > Tried the "new usage" display but the problem is the same : 31 TB used but total file size is 28TB
> > 
> > Overall:
> >     Device size:                  36.32TiB
> >     Device allocated:             31.65TiB
> >     Device unallocated:            4.67TiB
> >     Device missing:                  0.00B
> >     Used:                         31.52TiB
> >     Free (estimated):              4.80TiB      (min: 2.46TiB)
> >     Data ratio:                       1.00
> >     Metadata ratio:                   2.00
> >     Global reserve:              512.00MiB      (used: 0.00B)
> > 
> > Data,single: Size:31.58TiB, Used:31.45TiB
> >    /dev/mapper/lvm_pool-lvol001   31.58TiB
> > 
> > Metadata,DUP: Size:38.00GiB, Used:35.37GiB
> >    /dev/mapper/lvm_pool-lvol001   76.00GiB
> > 
> > System,DUP: Size:8.00MiB, Used:3.69MiB
> >    /dev/mapper/lvm_pool-lvol001   16.00MiB
> > 
> > Unallocated:
> >    /dev/mapper/lvm_pool-lvol001    4.67TiB
> > The only btrfs tool speaking about 28TB is btrfs check (but I'm not sure if it's bytes because it speaks about "referenced blocks" and I don't understand the meaning of "file data blocks allocated")
> > Code:
> > file data blocks allocated: 183716661284864 ?? what's this ??
> >  referenced 30095956975616 = 27.3 TB !!
> > 
> > 
> > 
> > I also used the verbose option of https://github.com/knorrie/btrfs-heatmap/ to sum up the total size of all DATA EXTENT and found 32TB.
> > 
> > I did scrub, balance up to -dusage=90 (and also dusage=0) and ended up with 32TB used.
> > No snasphots nor subvolumes nor TB hidden under the mount point after unmounting the BTRFS volume  
> > 
> > 
> > What did I do wrong or am I missing ?
> > 
> > Thanks in advance.
> > Frederic Larive.
> > 
> 

-- 
Hugo Mills             | Well, sir, the floor is yours. But remember, the
hugo@... carfax.org.uk | roof is ours!
http://carfax.org.uk/  |
PGP: E2AB1DE4          |                                             The Goons
