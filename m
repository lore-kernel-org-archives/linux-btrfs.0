From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: Memory leak?
Date: Fri, 8 Jul 2011 21:04:12 +0100
Message-ID: <20110708200412.GG4284@yahoo.fr>
References: <20110703190913.GA4474@yahoo.fr>
 <CAE5mzvhZc4afuBTT0GrDvPXKaSwYeyPdyiQaYPjCTmvzBahr7g@mail.gmail.com>
 <20110706081111.GA6931@yahoo.fr>
 <20110708124429.GB4284@yahoo.fr>
 <1310137241-sup-8158@shiny>
 <20110708154123.GA17886@yahoo.fr>
 <1310141349-sup-9515@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: cwillu <cwillu@cwillu.com>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1310141349-sup-9515@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

2011-07-08 12:15:08 -0400, Chris Mason:
[...]
> I'd definitely try without -o compress_force.
[...]

Just started that over the night.

I'm running a "dstat -df" at the same time and I'm seeing
substantive amount of disk writes on the disks that hold the
source FS (and I'm rsyncing from read-only snapshot subvolumes
in case you're thinking of atimes) almost more than onto the
drive holding the target FS!?

--dsk/sda-- --dsk/sdb-- --dsk/sdc-- --dsk/sdd--
 read  writ: read  writ: read  writ: read  writ
1000k    0 : 580k    0 :2176k    0 :   0     0
1192k    0 :  76k    0 : 988k    0 :   0     0
 436k    0 : 364k    0 :1984k    0 :   0    33M
 824k    0 : 812k    0 :4276k    0 :   0     0
3004k    0 :2868k    0 :5488k    0 :   0     0
 796k  564k: 640k   25M:2284k 4600k:   0     0
 108k    0 :  68k   23M: 648k   35M:   0     0
1712k   12k:1644k   12k:2476k 7864k:   0     0
 732k    0 : 620k    0 :3192k    0 :   0     0
1148k    0 :1116k    0 :3532k    0 :   0    19M
1392k    0 :1380k    0 :4416k    0 :   0  7056k
1336k    0 :1212k    0 :6664k    0 :   0  3148k
 820k    0 : 784k    0 :4528k    0 :   0    48M
1336k    0 :1340k    0 :3964k    0 :   0  8996k
1528k    0 :1280k    0 :2908k    0 :   0     0
1352k    0 :1216k    0 :3880k    0 :   0     0
 864k    0 : 888k    0 :1684k    0 :   0     0
1268k    0 :1208k    0 :3072k    0 :   0     0

(source FS is on sda4+sdb+sdc, target on sdd, sda alsa has an
ext4 FS)

How can that be? Some garbage collection, background defrag or
something like that? But then, if I stop the rsync, those writes
stop as well.

-- 
Stephane
