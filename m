Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60607 "EHLO mail.virtall.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933668AbcKMNyb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 13 Nov 2016 08:54:31 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sun, 13 Nov 2016 22:47:51 +0900
From: Tomasz Chmielewski <mangoo@wpkg.org>
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, chris@colorremedies.com
Subject: Re: how to understand "btrfs fi show" output? "No space left" issues
In-Reply-To: <CAJCQCtQ+uaMCCW81+ePF6scGsTu+MEu1arCQ0wTJhwS8EN8S=A@mail.gmail.com>
References: <566e9000fe30d5b8e0d7e73ebe1d44a0@admin.virtall.com>
 <CAJCQCtQ+uaMCCW81+ePF6scGsTu+MEu1arCQ0wTJhwS8EN8S=A@mail.gmail.com>
Message-ID: <42f3ae79cb143790dcf53213fe4b6705@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-09-21 11:51, Chris Murphy wrote:

> I'm coming into this late and realize most questions have been
> answered. But I take the position this is a bug, clearly there's
> enough space when df reports only 33% used, and therefore it's
> important to gather information about the file system in its current
> state so the devs can make decisions. Manually running balance is the
> correct work around, but it's bad Ux and should not be necessary (even
> though it's known to sometimes be necessary).
> 
> Anyway, in this case there is room in all chunks and GlobalReserve
> used is 0.00B. Metadata has a bit over a gigabyte of unused space in
> its allocated block groups. So at the moment I'm thinking it's a bug.
> The two things that'd be useful if you can reproduce this problem at
> some point, by NOT trying to prevent it again, are:
> 
> grep . -IR /sys/fs/btrfs/<fsuuid>/allocation/
> 
> <fsuuid> pick the UUID for the affected fs volume.
> 
> btrfs-debugfs found in btrfs-progs upstream as a python program but
> typically not packaged by distros
> https://github.com/kdave/btrfs-progs/blob/master/btrfs-debugfs
> 
> Takes the form:
> 
> sudo ./btrfs-debugfs -b <mountpoint>
> 
> It'll show you the percent each block group is actually being used so
> you can have a good idea what -dusage value to use (in your case) to
> free up space. That should help, but ultimately it's a work around,
> not a real fix. There shouldn't be enospc anyway.
> 
> So if it happens again, first capture the above two bits of
> information, and then if  you feel like testing kernel 4.8rc7 do that.
> It has a massive pile of enoscp related rework and I bet Josef would
> like to know if the problem reproduces with that kernel. As in, just
> change kernels, don't try to fix it with balance first.

OK, so it again came to a point where it's full when it's not.

Running 4.8.1 now for around 30 days.

Some btrfs utils output first:

# btrfs fi show /var/lib/lxd
Label: 'btrfs'  uuid: f5f30428-ec5b-4497-82de-6e20065e6f61
         Total devices 2 FS bytes used 182.93GiB
         devid    1 size 423.13GiB used 423.13GiB path /dev/sda3
         devid    2 size 423.13GiB used 423.13GiB path /dev/sdb3


# btrfs fi df /var/lib/lxd
Data, RAID1: total=415.09GiB, used=177.41GiB
System, RAID1: total=32.00MiB, used=80.00KiB
Metadata, RAID1: total=8.00GiB, used=5.52GiB
GlobalReserve, single: total=512.00MiB, used=0.00B


# btrfs fi usage /var/lib/lxd
Overall:
     Device size:                 846.25GiB
     Device allocated:            846.25GiB
     Device unallocated:            2.05MiB
     Device missing:                  0.00B
     Used:                        365.86GiB
     Free (estimated):            237.69GiB      (min: 237.69GiB)
     Data ratio:                       2.00
     Metadata ratio:                   2.00
     Global reserve:              512.00MiB      (used: 0.00B)

Data,RAID1: Size:415.09GiB, Used:177.41GiB
    /dev/sda3     415.09GiB
    /dev/sdb3     415.09GiB

Metadata,RAID1: Size:8.00GiB, Used:5.52GiB
    /dev/sda3       8.00GiB
    /dev/sdb3       8.00GiB

System,RAID1: Size:32.00MiB, Used:80.00KiB
    /dev/sda3      32.00MiB
    /dev/sdb3      32.00MiB

Unallocated:
    /dev/sda3       1.02MiB
    /dev/sdb3       1.02MiB


# df -h
/dev/sda3       424G  184G  238G  44% /var/lib/lxd



Finally, the output from both /sys/fs/btrfs/ and btrfs-debugfs:


# grep . -IR 
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/flags:2
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/raid1/used_bytes:81920
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/raid1/total_bytes:33554432
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/bytes_pinned:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/disk_total:67108864
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/bytes_may_use:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/bytes_readonly:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/bytes_used:81920
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/bytes_reserved:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/disk_used:163840
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/total_bytes_pinned:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/system/total_bytes:33554432
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/flags:4
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/raid1/used_bytes:5927518208
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/raid1/total_bytes:8589934592
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/bytes_pinned:2080768
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/disk_total:17179869184
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/bytes_may_use:634126336
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/bytes_readonly:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/bytes_used:5927518208
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/bytes_reserved:3457024
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/disk_used:11855036416
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/total_bytes_pinned:-21806088192
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/metadata/total_bytes:8589934592
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/global_rsv_size:536870912
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/flags:1
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/raid1/used_bytes:190489985024
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/raid1/total_bytes:445705420800
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/bytes_pinned:0
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/disk_total:891410841600
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/bytes_may_use:249856
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/bytes_readonly:196608
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/bytes_used:190489985024
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/bytes_reserved:4186112
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/disk_used:380979970048
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/total_bytes_pinned:6267325681664
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/data/total_bytes:445705420800
/sys/fs/btrfs/f5f30428-ec5b-4497-82de-6e20065e6f61/allocation/global_rsv_reserved:536870912


# python btrfs-debugfs -b /var/lib/lxd
block group offset 448853442560 len 1073741824 used 881926144 
chunk_objectid 256 flags 17 usage 0.82
block group offset 449927184384 len 1073741824 used 946565120 
chunk_objectid 256 flags 17 usage 0.88
block group offset 451000926208 len 1073741824 used 767254528 
chunk_objectid 256 flags 17 usage 0.71
block group offset 452074668032 len 1073741824 used 752488448 
chunk_objectid 256 flags 17 usage 0.70
block group offset 453148409856 len 1073741824 used 796258304 
chunk_objectid 256 flags 17 usage 0.74
block group offset 454222151680 len 1073741824 used 670818304 
chunk_objectid 256 flags 17 usage 0.62
block group offset 455295893504 len 1073741824 used 950624256 
chunk_objectid 256 flags 17 usage 0.89
block group offset 456369635328 len 1073741824 used 796438528 
chunk_objectid 256 flags 17 usage 0.74
block group offset 457443377152 len 1073741824 used 879132672 
chunk_objectid 256 flags 17 usage 0.82
block group offset 458517118976 len 1073741824 used 707289088 
chunk_objectid 256 flags 17 usage 0.66
block group offset 459590860800 len 1073741824 used 765911040 
chunk_objectid 256 flags 17 usage 0.71
block group offset 460664602624 len 1073741824 used 735580160 
chunk_objectid 256 flags 17 usage 0.69
block group offset 461738344448 len 1073741824 used 660029440 
chunk_objectid 256 flags 17 usage 0.61
block group offset 462812086272 len 1073741824 used 708149248 
chunk_objectid 256 flags 17 usage 0.66
block group offset 463885828096 len 1073741824 used 578334720 
chunk_objectid 256 flags 17 usage 0.54
block group offset 464959569920 len 1073741824 used 805920768 
chunk_objectid 256 flags 17 usage 0.75
block group offset 466033311744 len 1073741824 used 634789888 
chunk_objectid 256 flags 17 usage 0.59
block group offset 467107053568 len 1073741824 used 588206080 
chunk_objectid 256 flags 17 usage 0.55
block group offset 468180795392 len 1073741824 used 689471488 
chunk_objectid 256 flags 17 usage 0.64
block group offset 469254537216 len 1073741824 used 749441024 
chunk_objectid 256 flags 17 usage 0.70
block group offset 470328279040 len 1073741824 used 887029760 
chunk_objectid 256 flags 17 usage 0.83
block group offset 471402020864 len 1073741824 used 767094784 
chunk_objectid 256 flags 17 usage 0.71
block group offset 472475762688 len 1073741824 used 536039424 
chunk_objectid 256 flags 17 usage 0.50
block group offset 473549504512 len 1073741824 used 600018944 
chunk_objectid 256 flags 17 usage 0.56
block group offset 474623246336 len 1073741824 used 588034048 
chunk_objectid 256 flags 17 usage 0.55
block group offset 475696988160 len 1073741824 used 772034560 
chunk_objectid 256 flags 17 usage 0.72
block group offset 476770729984 len 1073741824 used 624271360 
chunk_objectid 256 flags 17 usage 0.58
block group offset 477844471808 len 1073741824 used 500379648 
chunk_objectid 256 flags 17 usage 0.47
block group offset 478918213632 len 1073741824 used 592740352 
chunk_objectid 256 flags 17 usage 0.55
block group offset 479991955456 len 1073741824 used 988463104 
chunk_objectid 256 flags 17 usage 0.92
block group offset 481065697280 len 1073741824 used 699994112 
chunk_objectid 256 flags 17 usage 0.65
block group offset 482139439104 len 1073741824 used 900386816 
chunk_objectid 256 flags 17 usage 0.84
block group offset 483213180928 len 1073741824 used 452935680 
chunk_objectid 256 flags 17 usage 0.42
block group offset 484286922752 len 1073741824 used 798748672 
chunk_objectid 256 flags 17 usage 0.74
block group offset 485360664576 len 1073741824 used 937799680 
chunk_objectid 256 flags 17 usage 0.87
block group offset 488581890048 len 1073741824 used 715972608 
chunk_objectid 256 flags 17 usage 0.67
block group offset 489655631872 len 1073741824 used 665128960 
chunk_objectid 256 flags 17 usage 0.62
block group offset 490729373696 len 1073741824 used 863653888 
chunk_objectid 256 flags 17 usage 0.80
block group offset 491803115520 len 1073741824 used 848773120 
chunk_objectid 256 flags 17 usage 0.79
block group offset 492876857344 len 1073741824 used 430964736 
chunk_objectid 256 flags 17 usage 0.40
block group offset 493950599168 len 1073741824 used 655376384 
chunk_objectid 256 flags 17 usage 0.61
block group offset 495024340992 len 1073741824 used 368988160 
chunk_objectid 256 flags 17 usage 0.34
block group offset 496098082816 len 1073741824 used 608452608 
chunk_objectid 256 flags 17 usage 0.57
block group offset 497171824640 len 1073741824 used 685191168 
chunk_objectid 256 flags 17 usage 0.64
block group offset 498245566464 len 1073741824 used 727654400 
chunk_objectid 256 flags 17 usage 0.68
block group offset 499319308288 len 1073741824 used 765272064 
chunk_objectid 256 flags 17 usage 0.71
block group offset 500393050112 len 1073741824 used 626692096 
chunk_objectid 256 flags 17 usage 0.58
block group offset 501466791936 len 1073741824 used 828809216 
chunk_objectid 256 flags 17 usage 0.77
block group offset 502540533760 len 1073741824 used 706023424 
chunk_objectid 256 flags 17 usage 0.66
block group offset 503614275584 len 1073741824 used 511291392 
chunk_objectid 256 flags 17 usage 0.48
block group offset 504688017408 len 1073741824 used 775815168 
chunk_objectid 256 flags 17 usage 0.72
block group offset 505761759232 len 1073741824 used 685989888 
chunk_objectid 256 flags 17 usage 0.64
block group offset 506835501056 len 1073741824 used 768802816 
chunk_objectid 256 flags 17 usage 0.72
block group offset 507909242880 len 1073741824 used 744599552 
chunk_objectid 256 flags 17 usage 0.69
block group offset 508982984704 len 1073741824 used 771915776 
chunk_objectid 256 flags 17 usage 0.72
block group offset 510056726528 len 1073741824 used 657874944 
chunk_objectid 256 flags 17 usage 0.61
block group offset 511130468352 len 1073741824 used 568332288 
chunk_objectid 256 flags 17 usage 0.53
block group offset 512204210176 len 1073741824 used 617943040 
chunk_objectid 256 flags 17 usage 0.58
block group offset 513277952000 len 1073741824 used 706453504 
chunk_objectid 256 flags 17 usage 0.66
block group offset 514351693824 len 1073741824 used 532373504 
chunk_objectid 256 flags 17 usage 0.50
block group offset 515425435648 len 1073741824 used 775159808 
chunk_objectid 256 flags 17 usage 0.72
block group offset 516499177472 len 1073741824 used 759848960 
chunk_objectid 256 flags 17 usage 0.71
block group offset 517572919296 len 1073741824 used 734322688 
chunk_objectid 256 flags 17 usage 0.68
block group offset 518646661120 len 1073741824 used 806400000 
chunk_objectid 256 flags 17 usage 0.75
block group offset 519720402944 len 1073741824 used 790986752 
chunk_objectid 256 flags 17 usage 0.74
block group offset 520794144768 len 1073741824 used 816947200 
chunk_objectid 256 flags 17 usage 0.76
block group offset 521867886592 len 1073741824 used 665403392 
chunk_objectid 256 flags 17 usage 0.62
block group offset 522941628416 len 1073741824 used 903057408 
chunk_objectid 256 flags 17 usage 0.84
block group offset 524015370240 len 1073741824 used 537620480 
chunk_objectid 256 flags 17 usage 0.50
block group offset 525089112064 len 1073741824 used 489861120 
chunk_objectid 256 flags 17 usage 0.46
block group offset 526162853888 len 1073741824 used 780853248 
chunk_objectid 256 flags 17 usage 0.73
block group offset 527236595712 len 1073741824 used 804679680 
chunk_objectid 256 flags 17 usage 0.75
block group offset 528310337536 len 1073741824 used 607768576 
chunk_objectid 256 flags 17 usage 0.57
block group offset 529384079360 len 1073741824 used 585670656 
chunk_objectid 256 flags 17 usage 0.55
block group offset 530457821184 len 1073741824 used 807866368 
chunk_objectid 256 flags 17 usage 0.75
block group offset 531531563008 len 1073741824 used 636223488 
chunk_objectid 256 flags 17 usage 0.59
block group offset 532605304832 len 1073741824 used 469962752 
chunk_objectid 256 flags 17 usage 0.44
block group offset 533679046656 len 1073741824 used 920293376 
chunk_objectid 256 flags 17 usage 0.86
block group offset 535826530304 len 1073741824 used 968335360 
chunk_objectid 256 flags 17 usage 0.90
block group offset 536900272128 len 1073741824 used 811327488 
chunk_objectid 256 flags 17 usage 0.76
block group offset 537974013952 len 1073741824 used 728002560 
chunk_objectid 256 flags 17 usage 0.68
block group offset 539047755776 len 1073741824 used 822849536 
chunk_objectid 256 flags 17 usage 0.77
block group offset 540121497600 len 1073741824 used 1041465344 
chunk_objectid 256 flags 17 usage 0.97
block group offset 541195239424 len 1073741824 used 911171584 
chunk_objectid 256 flags 17 usage 0.85
block group offset 542268981248 len 1073741824 used 640073728 
chunk_objectid 256 flags 17 usage 0.60
block group offset 543342723072 len 1073741824 used 891994112 
chunk_objectid 256 flags 17 usage 0.83
block group offset 544416464896 len 1073741824 used 835039232 
chunk_objectid 256 flags 17 usage 0.78
block group offset 545490206720 len 1073741824 used 830984192 
chunk_objectid 256 flags 17 usage 0.77
block group offset 546563948544 len 1073741824 used 870522880 
chunk_objectid 256 flags 17 usage 0.81
block group offset 547637690368 len 1073741824 used 752476160 
chunk_objectid 256 flags 17 usage 0.70
block group offset 548711432192 len 1073741824 used 726528000 
chunk_objectid 256 flags 17 usage 0.68
block group offset 549785174016 len 1073741824 used 782184448 
chunk_objectid 256 flags 17 usage 0.73
block group offset 550858915840 len 1073741824 used 1046855680 
chunk_objectid 256 flags 17 usage 0.97
block group offset 551932657664 len 1073741824 used 1041145856 
chunk_objectid 256 flags 17 usage 0.97
block group offset 553006399488 len 1073741824 used 921186304 
chunk_objectid 256 flags 17 usage 0.86
block group offset 555153883136 len 1073741824 used 874520576 
chunk_objectid 256 flags 17 usage 0.81
block group offset 556227624960 len 1073741824 used 535019520 
chunk_objectid 256 flags 17 usage 0.50
block group offset 557301366784 len 1073741824 used 608518144 
chunk_objectid 256 flags 17 usage 0.57
block group offset 558375108608 len 1073741824 used 813170688 
chunk_objectid 256 flags 17 usage 0.76
block group offset 559448850432 len 1073741824 used 559087616 
chunk_objectid 256 flags 17 usage 0.52
block group offset 560522592256 len 1073741824 used 530391040 
chunk_objectid 256 flags 17 usage 0.49
block group offset 561596334080 len 1073741824 used 626405376 
chunk_objectid 256 flags 17 usage 0.58
block group offset 562670075904 len 1073741824 used 506920960 
chunk_objectid 256 flags 17 usage 0.47
block group offset 563743817728 len 1073741824 used 427913216 
chunk_objectid 256 flags 17 usage 0.40
block group offset 564817559552 len 1073741824 used 579772416 
chunk_objectid 256 flags 17 usage 0.54
block group offset 565891301376 len 1073741824 used 573362176 
chunk_objectid 256 flags 17 usage 0.53
block group offset 566965043200 len 1073741824 used 360554496 
chunk_objectid 256 flags 17 usage 0.34
block group offset 568038785024 len 1073741824 used 407773184 
chunk_objectid 256 flags 17 usage 0.38
block group offset 569112526848 len 1073741824 used 489127936 
chunk_objectid 256 flags 17 usage 0.46
block group offset 570186268672 len 1073741824 used 985366528 
chunk_objectid 256 flags 17 usage 0.92
block group offset 571260010496 len 1073741824 used 1005277184 
chunk_objectid 256 flags 17 usage 0.94
block group offset 572333752320 len 1073741824 used 1036759040 
chunk_objectid 256 flags 17 usage 0.97
block group offset 573407494144 len 1073741824 used 816799744 
chunk_objectid 256 flags 17 usage 0.76
block group offset 574481235968 len 1073741824 used 1026777088 
chunk_objectid 256 flags 17 usage 0.96
block group offset 575554977792 len 1073741824 used 1046904832 
chunk_objectid 256 flags 17 usage 0.98
block group offset 576628719616 len 1073741824 used 957255680 
chunk_objectid 256 flags 17 usage 0.89
block group offset 577702461440 len 1073741824 used 1042501632 
chunk_objectid 256 flags 17 usage 0.97
block group offset 578776203264 len 1073741824 used 1011400704 
chunk_objectid 256 flags 17 usage 0.94
block group offset 579849945088 len 1073741824 used 1062154240 
chunk_objectid 256 flags 17 usage 0.99
block group offset 580923686912 len 1073741824 used 1030819840 
chunk_objectid 256 flags 17 usage 0.96
block group offset 581997428736 len 1073741824 used 1029595136 
chunk_objectid 256 flags 17 usage 0.96
block group offset 583071170560 len 1073741824 used 976089088 
chunk_objectid 256 flags 17 usage 0.91
block group offset 584144912384 len 1073741824 used 1067257856 
chunk_objectid 256 flags 17 usage 0.99
block group offset 585218654208 len 1073741824 used 1050005504 
chunk_objectid 256 flags 17 usage 0.98
block group offset 587366137856 len 1073741824 used 1061806080 
chunk_objectid 256 flags 17 usage 0.99
block group offset 588439879680 len 1073741824 used 1055633408 
chunk_objectid 256 flags 17 usage 0.98
block group offset 589513621504 len 1073741824 used 954552320 
chunk_objectid 256 flags 17 usage 0.89
block group offset 590587363328 len 1073741824 used 719753216 
chunk_objectid 256 flags 17 usage 0.67
block group offset 591661105152 len 1073741824 used 642084864 
chunk_objectid 256 flags 17 usage 0.60
block group offset 592734846976 len 1073741824 used 734101504 
chunk_objectid 256 flags 17 usage 0.68
block group offset 593808588800 len 1073741824 used 859447296 
chunk_objectid 256 flags 17 usage 0.80
block group offset 594882330624 len 1073741824 used 874569728 
chunk_objectid 256 flags 17 usage 0.81
block group offset 595956072448 len 1073741824 used 531771392 
chunk_objectid 256 flags 17 usage 0.50
block group offset 598137110528 len 1073741824 used 242356224 
chunk_objectid 256 flags 17 usage 0.23
block group offset 599210852352 len 1073741824 used 405417984 
chunk_objectid 256 flags 17 usage 0.38
block group offset 600284594176 len 1073741824 used 241131520 
chunk_objectid 256 flags 17 usage 0.22
block group offset 601358336000 len 1073741824 used 334790656 
chunk_objectid 256 flags 17 usage 0.31
block group offset 602432077824 len 1073741824 used 545705984 
chunk_objectid 256 flags 17 usage 0.51
block group offset 604579561472 len 1073741824 used 186368000 
chunk_objectid 256 flags 17 usage 0.17
block group offset 605653303296 len 1073741824 used 143708160 
chunk_objectid 256 flags 17 usage 0.13
block group offset 606727045120 len 1073741824 used 218497024 
chunk_objectid 256 flags 17 usage 0.20
block group offset 607800786944 len 1073741824 used 222019584 
chunk_objectid 256 flags 17 usage 0.21
block group offset 608874528768 len 1073741824 used 285859840 
chunk_objectid 256 flags 17 usage 0.27
block group offset 609948270592 len 1073741824 used 170098688 
chunk_objectid 256 flags 17 usage 0.16
block group offset 611022012416 len 1073741824 used 199045120 
chunk_objectid 256 flags 17 usage 0.19
block group offset 612095754240 len 1073741824 used 356483072 
chunk_objectid 256 flags 17 usage 0.33
block group offset 613169496064 len 1073741824 used 361803776 
chunk_objectid 256 flags 17 usage 0.34
block group offset 614243237888 len 1073741824 used 431054848 
chunk_objectid 256 flags 17 usage 0.40
block group offset 615316979712 len 1073741824 used 480305152 
chunk_objectid 256 flags 17 usage 0.45
block group offset 616390721536 len 1073741824 used 723636224 
chunk_objectid 256 flags 17 usage 0.67
block group offset 617464463360 len 1073741824 used 430026752 
chunk_objectid 256 flags 17 usage 0.40
block group offset 618538205184 len 1073741824 used 130674688 
chunk_objectid 256 flags 17 usage 0.12
block group offset 619611947008 len 1073741824 used 254525440 
chunk_objectid 256 flags 17 usage 0.24
block group offset 621759430656 len 1073741824 used 344932352 
chunk_objectid 256 flags 17 usage 0.32
block group offset 622833172480 len 1073741824 used 320720896 
chunk_objectid 256 flags 17 usage 0.30
block group offset 623906914304 len 1073741824 used 160923648 
chunk_objectid 256 flags 17 usage 0.15
block group offset 624980656128 len 1073741824 used 193396736 
chunk_objectid 256 flags 17 usage 0.18
block group offset 626054397952 len 1073741824 used 143958016 
chunk_objectid 256 flags 17 usage 0.13
block group offset 627128139776 len 1073741824 used 265129984 
chunk_objectid 256 flags 17 usage 0.25
block group offset 628201881600 len 1073741824 used 186269696 
chunk_objectid 256 flags 17 usage 0.17
block group offset 629275623424 len 1073741824 used 285048832 
chunk_objectid 256 flags 17 usage 0.27
block group offset 630349365248 len 1073741824 used 244420608 
chunk_objectid 256 flags 17 usage 0.23
block group offset 631423107072 len 1073741824 used 424706048 
chunk_objectid 256 flags 17 usage 0.40
block group offset 632496848896 len 1073741824 used 213065728 
chunk_objectid 256 flags 17 usage 0.20
block group offset 633570590720 len 1073741824 used 133292032 
chunk_objectid 256 flags 17 usage 0.12
block group offset 634644332544 len 1073741824 used 151572480 
chunk_objectid 256 flags 17 usage 0.14
block group offset 635718074368 len 1073741824 used 207876096 
chunk_objectid 256 flags 17 usage 0.19
block group offset 636791816192 len 1073741824 used 104755200 
chunk_objectid 256 flags 17 usage 0.10
block group offset 637865558016 len 1073741824 used 168980480 
chunk_objectid 256 flags 17 usage 0.16
block group offset 638939299840 len 1073741824 used 421982208 
chunk_objectid 256 flags 17 usage 0.39
block group offset 640013041664 len 1073741824 used 514052096 
chunk_objectid 256 flags 17 usage 0.48
block group offset 641086783488 len 1073741824 used 466907136 
chunk_objectid 256 flags 17 usage 0.43
block group offset 642160525312 len 1073741824 used 190926848 
chunk_objectid 256 flags 17 usage 0.18
block group offset 643234267136 len 1073741824 used 358051840 
chunk_objectid 256 flags 17 usage 0.33
block group offset 644308008960 len 1073741824 used 167735296 
chunk_objectid 256 flags 17 usage 0.16
block group offset 645381750784 len 1073741824 used 150282240 
chunk_objectid 256 flags 17 usage 0.14
block group offset 646455492608 len 1073741824 used 408072192 
chunk_objectid 256 flags 17 usage 0.38
block group offset 647529234432 len 1073741824 used 259457024 
chunk_objectid 256 flags 17 usage 0.24
block group offset 648602976256 len 1073741824 used 150667264 
chunk_objectid 256 flags 17 usage 0.14
block group offset 649676718080 len 1073741824 used 127299584 
chunk_objectid 256 flags 17 usage 0.12
block group offset 650750459904 len 1073741824 used 169029632 
chunk_objectid 256 flags 17 usage 0.16
block group offset 651824201728 len 1073741824 used 150265856 
chunk_objectid 256 flags 17 usage 0.14
block group offset 652897943552 len 1073741824 used 121843712 
chunk_objectid 256 flags 17 usage 0.11
block group offset 653971685376 len 1073741824 used 89858048 
chunk_objectid 256 flags 17 usage 0.08
block group offset 655045427200 len 1073741824 used 190758912 
chunk_objectid 256 flags 17 usage 0.18
block group offset 656119169024 len 1073741824 used 94527488 
chunk_objectid 256 flags 17 usage 0.09
block group offset 657192910848 len 1073741824 used 207470592 
chunk_objectid 256 flags 17 usage 0.19
block group offset 658266652672 len 1073741824 used 304144384 
chunk_objectid 256 flags 17 usage 0.28
block group offset 659340394496 len 1073741824 used 229654528 
chunk_objectid 256 flags 17 usage 0.21
block group offset 660414136320 len 1073741824 used 305963008 
chunk_objectid 256 flags 17 usage 0.28
block group offset 661487878144 len 1073741824 used 378400768 
chunk_objectid 256 flags 17 usage 0.35
block group offset 662561619968 len 1073741824 used 347668480 
chunk_objectid 256 flags 17 usage 0.32
block group offset 663635361792 len 1073741824 used 139902976 
chunk_objectid 256 flags 17 usage 0.13
block group offset 664709103616 len 1073741824 used 138940416 
chunk_objectid 256 flags 17 usage 0.13
block group offset 665782845440 len 1073741824 used 174080000 
chunk_objectid 256 flags 17 usage 0.16
block group offset 666856587264 len 1073741824 used 473141248 
chunk_objectid 256 flags 17 usage 0.44
block group offset 669004070912 len 1073741824 used 407285760 
chunk_objectid 256 flags 17 usage 0.38
block group offset 670077812736 len 1073741824 used 165851136 
chunk_objectid 256 flags 17 usage 0.15
block group offset 671151554560 len 1073741824 used 266952704 
chunk_objectid 256 flags 17 usage 0.25
block group offset 672225296384 len 1073741824 used 623517696 
chunk_objectid 256 flags 17 usage 0.58
block group offset 673299038208 len 1073741824 used 274513920 
chunk_objectid 256 flags 17 usage 0.26
block group offset 674372780032 len 1073741824 used 374349824 
chunk_objectid 256 flags 17 usage 0.35
block group offset 675446521856 len 1073741824 used 235655168 
chunk_objectid 256 flags 17 usage 0.22
block group offset 676520263680 len 1073741824 used 427499520 
chunk_objectid 256 flags 17 usage 0.40
block group offset 677594005504 len 1073741824 used 447488000 
chunk_objectid 256 flags 17 usage 0.42
block group offset 678667747328 len 1073741824 used 158400512 
chunk_objectid 256 flags 17 usage 0.15
block group offset 679741489152 len 1073741824 used 259739648 
chunk_objectid 256 flags 17 usage 0.24
block group offset 680815230976 len 1073741824 used 402739200 
chunk_objectid 256 flags 17 usage 0.38
block group offset 681888972800 len 1073741824 used 426950656 
chunk_objectid 256 flags 17 usage 0.40
block group offset 682962714624 len 1073741824 used 261332992 
chunk_objectid 256 flags 17 usage 0.24
block group offset 684036456448 len 1073741824 used 296292352 
chunk_objectid 256 flags 17 usage 0.28
block group offset 685110198272 len 1073741824 used 305135616 
chunk_objectid 256 flags 17 usage 0.28
block group offset 686183940096 len 1073741824 used 267231232 
chunk_objectid 256 flags 17 usage 0.25
block group offset 687257681920 len 1073741824 used 393064448 
chunk_objectid 256 flags 17 usage 0.37
block group offset 688331423744 len 1073741824 used 501518336 
chunk_objectid 256 flags 17 usage 0.47
block group offset 689405165568 len 1073741824 used 125394944 
chunk_objectid 256 flags 17 usage 0.12
block group offset 690478907392 len 1073741824 used 229621760 
chunk_objectid 256 flags 17 usage 0.21
block group offset 691552649216 len 1073741824 used 145514496 
chunk_objectid 256 flags 17 usage 0.14
block group offset 693700132864 len 1073741824 used 221028352 
chunk_objectid 256 flags 17 usage 0.21
block group offset 694773874688 len 1073741824 used 342937600 
chunk_objectid 256 flags 17 usage 0.32
block group offset 695847616512 len 1073741824 used 345280512 
chunk_objectid 256 flags 17 usage 0.32
block group offset 696921358336 len 1073741824 used 337960960 
chunk_objectid 256 flags 17 usage 0.31
block group offset 697995100160 len 1073741824 used 313036800 
chunk_objectid 256 flags 17 usage 0.29
block group offset 699068841984 len 1073741824 used 273776640 
chunk_objectid 256 flags 17 usage 0.25
block group offset 700142583808 len 1073741824 used 405180416 
chunk_objectid 256 flags 17 usage 0.38
block group offset 701216325632 len 1073741824 used 336728064 
chunk_objectid 256 flags 17 usage 0.31
block group offset 702290067456 len 1073741824 used 333320192 
chunk_objectid 256 flags 17 usage 0.31
block group offset 703363809280 len 1073741824 used 466243584 
chunk_objectid 256 flags 17 usage 0.43
block group offset 704437551104 len 1073741824 used 322740224 
chunk_objectid 256 flags 17 usage 0.30
block group offset 705511292928 len 1073741824 used 457408512 
chunk_objectid 256 flags 17 usage 0.43
block group offset 706585034752 len 1073741824 used 168890368 
chunk_objectid 256 flags 17 usage 0.16
block group offset 707658776576 len 1073741824 used 132284416 
chunk_objectid 256 flags 17 usage 0.12
block group offset 708732518400 len 1073741824 used 478806016 
chunk_objectid 256 flags 17 usage 0.45
block group offset 709806260224 len 1073741824 used 336908288 
chunk_objectid 256 flags 17 usage 0.31
block group offset 710880002048 len 1073741824 used 266715136 
chunk_objectid 256 flags 17 usage 0.25
block group offset 711953743872 len 1073741824 used 271204352 
chunk_objectid 256 flags 17 usage 0.25
block group offset 713027485696 len 1073741824 used 132100096 
chunk_objectid 256 flags 17 usage 0.12
block group offset 714101227520 len 1073741824 used 317091840 
chunk_objectid 256 flags 17 usage 0.30
block group offset 715174969344 len 1073741824 used 87367680 
chunk_objectid 256 flags 17 usage 0.08
block group offset 716248711168 len 1073741824 used 193900544 
chunk_objectid 256 flags 17 usage 0.18
block group offset 717322452992 len 1073741824 used 166481920 
chunk_objectid 256 flags 17 usage 0.16
block group offset 718396194816 len 1073741824 used 221421568 
chunk_objectid 256 flags 17 usage 0.21
block group offset 719469936640 len 1073741824 used 469008384 
chunk_objectid 256 flags 17 usage 0.44
block group offset 720543678464 len 1073741824 used 426827776 
chunk_objectid 256 flags 17 usage 0.40
block group offset 721617420288 len 1073741824 used 798978048 
chunk_objectid 256 flags 17 usage 0.74
block group offset 722691162112 len 1073741824 used 215871488 
chunk_objectid 256 flags 17 usage 0.20
block group offset 723764903936 len 1073741824 used 424648704 
chunk_objectid 256 flags 17 usage 0.40
block group offset 724838645760 len 1073741824 used 240074752 
chunk_objectid 256 flags 17 usage 0.22
block group offset 725912387584 len 1073741824 used 252444672 
chunk_objectid 256 flags 17 usage 0.24
block group offset 726986129408 len 1073741824 used 272539648 
chunk_objectid 256 flags 17 usage 0.25
block group offset 728059871232 len 1073741824 used 216961024 
chunk_objectid 256 flags 17 usage 0.20
block group offset 729133613056 len 1073741824 used 390696960 
chunk_objectid 256 flags 17 usage 0.36
block group offset 730207354880 len 1073741824 used 217100288 
chunk_objectid 256 flags 17 usage 0.20
block group offset 731281096704 len 1073741824 used 235958272 
chunk_objectid 256 flags 17 usage 0.22
block group offset 732354838528 len 1073741824 used 401571840 
chunk_objectid 256 flags 17 usage 0.37
block group offset 733428580352 len 1073741824 used 433233920 
chunk_objectid 256 flags 17 usage 0.40
block group offset 734502322176 len 1073741824 used 253677568 
chunk_objectid 256 flags 17 usage 0.24
block group offset 735576064000 len 1073741824 used 237318144 
chunk_objectid 256 flags 17 usage 0.22
block group offset 736649805824 len 1073741824 used 187981824 
chunk_objectid 256 flags 17 usage 0.18
block group offset 737723547648 len 1073741824 used 306151424 
chunk_objectid 256 flags 17 usage 0.29
block group offset 738797289472 len 1073741824 used 217128960 
chunk_objectid 256 flags 17 usage 0.20
block group offset 739871031296 len 1073741824 used 357068800 
chunk_objectid 256 flags 17 usage 0.33
block group offset 740944773120 len 1073741824 used 223764480 
chunk_objectid 256 flags 17 usage 0.21
block group offset 742018514944 len 1073741824 used 287920128 
chunk_objectid 256 flags 17 usage 0.27
block group offset 743092256768 len 1073741824 used 398491648 
chunk_objectid 256 flags 17 usage 0.37
block group offset 744165998592 len 1073741824 used 285138944 
chunk_objectid 256 flags 17 usage 0.27
block group offset 745239740416 len 1073741824 used 299122688 
chunk_objectid 256 flags 17 usage 0.28
block group offset 746313482240 len 1073741824 used 291512320 
chunk_objectid 256 flags 17 usage 0.27
block group offset 747387224064 len 1073741824 used 436502528 
chunk_objectid 256 flags 17 usage 0.41
block group offset 749534707712 len 1073741824 used 303312896 
chunk_objectid 256 flags 17 usage 0.28
block group offset 750608449536 len 1073741824 used 235028480 
chunk_objectid 256 flags 17 usage 0.22
block group offset 751682191360 len 1073741824 used 321982464 
chunk_objectid 256 flags 17 usage 0.30
block group offset 752755933184 len 1073741824 used 235728896 
chunk_objectid 256 flags 17 usage 0.22
block group offset 753829675008 len 1073741824 used 286490624 
chunk_objectid 256 flags 17 usage 0.27
block group offset 754903416832 len 1073741824 used 129347584 
chunk_objectid 256 flags 17 usage 0.12
block group offset 755977158656 len 1073741824 used 399921152 
chunk_objectid 256 flags 17 usage 0.37
block group offset 758124642304 len 1073741824 used 406171648 
chunk_objectid 256 flags 17 usage 0.38
block group offset 759198384128 len 1073741824 used 98414592 
chunk_objectid 256 flags 17 usage 0.09
block group offset 760272125952 len 1073741824 used 341929984 
chunk_objectid 256 flags 17 usage 0.32
block group offset 761345867776 len 1073741824 used 379543552 
chunk_objectid 256 flags 17 usage 0.35
block group offset 762419609600 len 1073741824 used 401068032 
chunk_objectid 256 flags 17 usage 0.37
block group offset 763493351424 len 1073741824 used 179699712 
chunk_objectid 256 flags 17 usage 0.17
block group offset 764567093248 len 1073741824 used 240254976 
chunk_objectid 256 flags 17 usage 0.22
block group offset 765640835072 len 1073741824 used 611897344 
chunk_objectid 256 flags 17 usage 0.57
block group offset 766714576896 len 1073741824 used 543674368 
chunk_objectid 256 flags 17 usage 0.51
block group offset 767788318720 len 1073741824 used 441778176 
chunk_objectid 256 flags 17 usage 0.41
block group offset 768862060544 len 1073741824 used 321441792 
chunk_objectid 256 flags 17 usage 0.30
block group offset 769935802368 len 1073741824 used 289775616 
chunk_objectid 256 flags 17 usage 0.27
block group offset 771009544192 len 1073741824 used 346759168 
chunk_objectid 256 flags 17 usage 0.32
block group offset 772083286016 len 1073741824 used 171155456 
chunk_objectid 256 flags 17 usage 0.16
block group offset 773157027840 len 1073741824 used 484233216 
chunk_objectid 256 flags 17 usage 0.45
block group offset 774230769664 len 1073741824 used 436781056 
chunk_objectid 256 flags 17 usage 0.41
block group offset 775304511488 len 1073741824 used 387092480 
chunk_objectid 256 flags 17 usage 0.36
block group offset 776378253312 len 1073741824 used 453230592 
chunk_objectid 256 flags 17 usage 0.42
block group offset 777451995136 len 1073741824 used 530366464 
chunk_objectid 256 flags 17 usage 0.49
block group offset 778525736960 len 1073741824 used 145711104 
chunk_objectid 256 flags 17 usage 0.14
block group offset 779599478784 len 1073741824 used 160198656 
chunk_objectid 256 flags 17 usage 0.15
block group offset 780673220608 len 1073741824 used 269946880 
chunk_objectid 256 flags 17 usage 0.25
block group offset 781746962432 len 1073741824 used 84987904 
chunk_objectid 256 flags 17 usage 0.08
block group offset 782820704256 len 1073741824 used 127004672 
chunk_objectid 256 flags 17 usage 0.12
block group offset 783894446080 len 1073741824 used 351936512 
chunk_objectid 256 flags 17 usage 0.33
block group offset 784968187904 len 1073741824 used 286433280 
chunk_objectid 256 flags 17 usage 0.27
block group offset 786041929728 len 1073741824 used 176111616 
chunk_objectid 256 flags 17 usage 0.16
block group offset 787115671552 len 1073741824 used 253472768 
chunk_objectid 256 flags 17 usage 0.24
block group offset 788189413376 len 1073741824 used 443858944 
chunk_objectid 256 flags 17 usage 0.41
block group offset 789263155200 len 1073741824 used 203227136 
chunk_objectid 256 flags 17 usage 0.19
block group offset 790336897024 len 1073741824 used 271093760 
chunk_objectid 256 flags 17 usage 0.25
block group offset 791410638848 len 1073741824 used 240893952 
chunk_objectid 256 flags 17 usage 0.22
block group offset 792484380672 len 1073741824 used 510099456 
chunk_objectid 256 flags 17 usage 0.48
block group offset 793558122496 len 1073741824 used 490971136 
chunk_objectid 256 flags 17 usage 0.46
block group offset 794631864320 len 1073741824 used 431878144 
chunk_objectid 256 flags 17 usage 0.40
block group offset 795705606144 len 1073741824 used 131350528 
chunk_objectid 256 flags 17 usage 0.12
block group offset 796779347968 len 1073741824 used 155181056 
chunk_objectid 256 flags 17 usage 0.14
block group offset 797853089792 len 1073741824 used 267878400 
chunk_objectid 256 flags 17 usage 0.25
block group offset 798926831616 len 1073741824 used 363737088 
chunk_objectid 256 flags 17 usage 0.34
block group offset 800000573440 len 1073741824 used 371228672 
chunk_objectid 256 flags 17 usage 0.35
block group offset 801074315264 len 1073741824 used 333512704 
chunk_objectid 256 flags 17 usage 0.31
block group offset 802148057088 len 1073741824 used 349712384 
chunk_objectid 256 flags 17 usage 0.33
block group offset 803221798912 len 1073741824 used 642527232 
chunk_objectid 256 flags 17 usage 0.60
block group offset 804295540736 len 1073741824 used 168931328 
chunk_objectid 256 flags 17 usage 0.16
block group offset 805369282560 len 1073741824 used 278888448 
chunk_objectid 256 flags 17 usage 0.26
block group offset 806443024384 len 1073741824 used 229961728 
chunk_objectid 256 flags 17 usage 0.21
block group offset 807516766208 len 1073741824 used 389857280 
chunk_objectid 256 flags 17 usage 0.36
block group offset 808590508032 len 1073741824 used 280907776 
chunk_objectid 256 flags 17 usage 0.26
block group offset 809664249856 len 1073741824 used 382054400 
chunk_objectid 256 flags 17 usage 0.36
block group offset 810737991680 len 1073741824 used 211423232 
chunk_objectid 256 flags 17 usage 0.20
block group offset 811811733504 len 1073741824 used 281456640 
chunk_objectid 256 flags 17 usage 0.26
block group offset 812885475328 len 1073741824 used 307662848 
chunk_objectid 256 flags 17 usage 0.29
block group offset 813959217152 len 1073741824 used 185409536 
chunk_objectid 256 flags 17 usage 0.17
block group offset 815032958976 len 1073741824 used 610664448 
chunk_objectid 256 flags 17 usage 0.57
block group offset 816106700800 len 1073741824 used 455544832 
chunk_objectid 256 flags 17 usage 0.42
block group offset 817180442624 len 1073741824 used 356343808 
chunk_objectid 256 flags 17 usage 0.33
block group offset 818254184448 len 1073741824 used 312946688 
chunk_objectid 256 flags 17 usage 0.29
block group offset 819327926272 len 1073741824 used 154918912 
chunk_objectid 256 flags 17 usage 0.14
block group offset 820401668096 len 1073741824 used 210526208 
chunk_objectid 256 flags 17 usage 0.20
block group offset 821475409920 len 1073741824 used 382570496 
chunk_objectid 256 flags 17 usage 0.36
block group offset 822549151744 len 1073741824 used 165621760 
chunk_objectid 256 flags 17 usage 0.15
block group offset 823622893568 len 1073741824 used 229781504 
chunk_objectid 256 flags 17 usage 0.21
block group offset 824696635392 len 1073741824 used 184930304 
chunk_objectid 256 flags 17 usage 0.17
block group offset 826844119040 len 1073741824 used 387780608 
chunk_objectid 256 flags 17 usage 0.36
block group offset 827917860864 len 1073741824 used 454524928 
chunk_objectid 256 flags 17 usage 0.42
block group offset 828991602688 len 1073741824 used 363769856 
chunk_objectid 256 flags 17 usage 0.34
block group offset 831139086336 len 1073741824 used 404836352 
chunk_objectid 256 flags 17 usage 0.38
block group offset 832212828160 len 1073741824 used 520110080 
chunk_objectid 256 flags 17 usage 0.48
block group offset 833286569984 len 1073741824 used 544399360 
chunk_objectid 256 flags 17 usage 0.51
block group offset 834360311808 len 1073741824 used 239640576 
chunk_objectid 256 flags 17 usage 0.22
block group offset 835434053632 len 1073741824 used 613244928 
chunk_objectid 256 flags 17 usage 0.57
block group offset 836507795456 len 1073741824 used 700862464 
chunk_objectid 256 flags 17 usage 0.65
block group offset 837581537280 len 1073741824 used 461037568 
chunk_objectid 256 flags 17 usage 0.43
block group offset 838655279104 len 1073741824 used 625061888 
chunk_objectid 256 flags 17 usage 0.58
block group offset 839729020928 len 1073741824 used 349057024 
chunk_objectid 256 flags 17 usage 0.33
block group offset 840802762752 len 1073741824 used 409407488 
chunk_objectid 256 flags 17 usage 0.38
block group offset 841876504576 len 1073741824 used 436609024 
chunk_objectid 256 flags 17 usage 0.41
block group offset 842950246400 len 1073741824 used 451768320 
chunk_objectid 256 flags 17 usage 0.42
block group offset 844023988224 len 1073741824 used 533405696 
chunk_objectid 256 flags 17 usage 0.50
block group offset 845097730048 len 1073741824 used 658169856 
chunk_objectid 256 flags 17 usage 0.61
block group offset 846171471872 len 1073741824 used 292184064 
chunk_objectid 256 flags 17 usage 0.27
block group offset 847245213696 len 1073741824 used 455761920 
chunk_objectid 256 flags 17 usage 0.42
block group offset 848318955520 len 1073741824 used 391958528 
chunk_objectid 256 flags 17 usage 0.37
block group offset 849392697344 len 1073741824 used 379977728 
chunk_objectid 256 flags 17 usage 0.35
block group offset 850466439168 len 1073741824 used 313704448 
chunk_objectid 256 flags 17 usage 0.29
block group offset 853687664640 len 1073741824 used 270372864 
chunk_objectid 256 flags 17 usage 0.25
block group offset 854761406464 len 1073741824 used 348319744 
chunk_objectid 256 flags 17 usage 0.32
block group offset 855835148288 len 1073741824 used 175984640 
chunk_objectid 256 flags 17 usage 0.16
block group offset 856908890112 len 1073741824 used 216760320 
chunk_objectid 256 flags 17 usage 0.20
block group offset 857982631936 len 1073741824 used 305971200 
chunk_objectid 256 flags 17 usage 0.28
block group offset 859056373760 len 1073741824 used 315138048 
chunk_objectid 256 flags 17 usage 0.29
block group offset 861203857408 len 1073741824 used 745463808 
chunk_objectid 256 flags 17 usage 0.69
block group offset 862277599232 len 1073741824 used 194326528 
chunk_objectid 256 flags 17 usage 0.18
block group offset 863351341056 len 1073741824 used 888487936 
chunk_objectid 256 flags 17 usage 0.83
block group offset 864425082880 len 1073741824 used 486821888 
chunk_objectid 256 flags 17 usage 0.45
block group offset 865498824704 len 1073741824 used 353210368 
chunk_objectid 256 flags 17 usage 0.33
block group offset 866572566528 len 1073741824 used 311578624 
chunk_objectid 256 flags 17 usage 0.29
block group offset 867646308352 len 1073741824 used 384884736 
chunk_objectid 256 flags 17 usage 0.36
block group offset 868720050176 len 1073741824 used 434302976 
chunk_objectid 256 flags 17 usage 0.40
block group offset 869793792000 len 1073741824 used 668499968 
chunk_objectid 256 flags 17 usage 0.62
block group offset 870867533824 len 1073741824 used 221671424 
chunk_objectid 256 flags 17 usage 0.21
block group offset 871941275648 len 1073741824 used 272408576 
chunk_objectid 256 flags 17 usage 0.25
block group offset 873015017472 len 1073741824 used 386215936 
chunk_objectid 256 flags 17 usage 0.36
block group offset 874088759296 len 1073741824 used 118960128 
chunk_objectid 256 flags 17 usage 0.11
block group offset 875162501120 len 1073741824 used 238624768 
chunk_objectid 256 flags 17 usage 0.22
block group offset 876236242944 len 1073741824 used 268787712 
chunk_objectid 256 flags 17 usage 0.25
block group offset 877309984768 len 1073741824 used 461127680 
chunk_objectid 256 flags 17 usage 0.43
block group offset 878383726592 len 1073741824 used 245559296 
chunk_objectid 256 flags 17 usage 0.23
block group offset 879457468416 len 1073741824 used 552534016 
chunk_objectid 256 flags 17 usage 0.51
block group offset 880531210240 len 1073741824 used 492670976 
chunk_objectid 256 flags 17 usage 0.46
block group offset 881604952064 len 1073741824 used 607686656 
chunk_objectid 256 flags 17 usage 0.57
block group offset 882678693888 len 1073741824 used 425488384 
chunk_objectid 256 flags 17 usage 0.40
block group offset 883752435712 len 1073741824 used 259645440 
chunk_objectid 256 flags 17 usage 0.24
block group offset 884826177536 len 1073741824 used 425963520 
chunk_objectid 256 flags 17 usage 0.40
block group offset 885899919360 len 1073741824 used 232914944 
chunk_objectid 256 flags 17 usage 0.22
block group offset 886973661184 len 1073741824 used 170930176 
chunk_objectid 256 flags 17 usage 0.16
block group offset 888047403008 len 1073741824 used 247267328 
chunk_objectid 256 flags 17 usage 0.23
block group offset 889121144832 len 1073741824 used 205602816 
chunk_objectid 256 flags 17 usage 0.19
block group offset 890194886656 len 1073741824 used 323842048 
chunk_objectid 256 flags 17 usage 0.30
block group offset 891268628480 len 1073741824 used 646483968 
chunk_objectid 256 flags 17 usage 0.60
block group offset 892342370304 len 1073741824 used 335949824 
chunk_objectid 256 flags 17 usage 0.31
block group offset 893416112128 len 1073741824 used 247644160 
chunk_objectid 256 flags 17 usage 0.23
block group offset 894489853952 len 1073741824 used 393486336 
chunk_objectid 256 flags 17 usage 0.37
block group offset 895563595776 len 1073741824 used 352370688 
chunk_objectid 256 flags 17 usage 0.33
block group offset 896637337600 len 1073741824 used 563159040 
chunk_objectid 256 flags 17 usage 0.52
block group offset 897711079424 len 1073741824 used 290377728 
chunk_objectid 256 flags 17 usage 0.27
block group offset 898784821248 len 1073741824 used 483008512 
chunk_objectid 256 flags 17 usage 0.45
block group offset 899858563072 len 1073741824 used 312786944 
chunk_objectid 256 flags 17 usage 0.29
block group offset 900932304896 len 1073741824 used 248545280 
chunk_objectid 256 flags 17 usage 0.23
block group offset 902006046720 len 1073741824 used 189079552 
chunk_objectid 256 flags 17 usage 0.18
block group offset 904153530368 len 1073741824 used 115830784 
chunk_objectid 256 flags 17 usage 0.11
block group offset 905227272192 len 1073741824 used 350433280 
chunk_objectid 256 flags 17 usage 0.33
block group offset 906301014016 len 1073741824 used 306683904 
chunk_objectid 256 flags 17 usage 0.29
block group offset 907374755840 len 1073741824 used 471134208 
chunk_objectid 256 flags 17 usage 0.44
block group offset 908448497664 len 1073741824 used 230105088 
chunk_objectid 256 flags 17 usage 0.21
block group offset 909522239488 len 1073741824 used 363417600 
chunk_objectid 256 flags 17 usage 0.34
block group offset 910595981312 len 1073741824 used 302993408 
chunk_objectid 256 flags 17 usage 0.28
block group offset 912743464960 len 1040187392 used 102686720 
chunk_objectid 256 flags 17 usage 0.10
block group offset 913783652352 len 1073741824 used 206684160 
chunk_objectid 256 flags 17 usage 0.19
block group offset 914993512448 len 107806720 used 30445568 
chunk_objectid 256 flags 17 usage 0.28
block group offset 915101319168 len 19922944 used 692224 chunk_objectid 
256 flags 17 usage 0.03
block group offset 915121242112 len 8388608 used 409600 chunk_objectid 
256 flags 17 usage 0.05
total_free 255213842432 min_used 409600 free_of_min_used 7979008 
block_group_of_min_used 915121242112
balance block group (915121242112) can reduce the number of data block 
group



Tomasz Chmielewski
https://lxadm.com

