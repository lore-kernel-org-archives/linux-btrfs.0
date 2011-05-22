From: Stephane Chazelas <stephane_chazelas@yahoo.fr>
Subject: Re: curious writes on mounted, not used btrfs filesystem
Date: Sun, 22 May 2011 19:26:12 +0100
Message-ID: <20110522182612.GB22491@yahoo.fr>
References: <4DD7B6ED.5040403@wpkg.org>
 <20110522093352.GA22491@yahoo.fr>
 <4DD8DCE5.6070703@wpkg.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Tomasz Chmielewski <mangoo@wpkg.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DD8DCE5.6070703@wpkg.org>
List-ID: <linux-btrfs.vger.kernel.org>

2011-05-22 11:52:37 +0200, Tomasz Chmielewski:
[...]
> Can you try running these commands yourself:
> 
> iostat -k 1 </your/btrfs/device>
> 
> 
> And in a second terminal:
> 
> while true; do sync ; done
> 
> 
> To see if your btrfs makes writes on sync each time?
[...]

Yes it does. And I see:

<7>[38554.244219] sync(3354): dirtied inode 1 (?) on dm-11
<7>[38554.244740] btrfs-submit-0(29134): WRITE block 301128 on dm-11 (56 sectors)
<7>[38554.244774] btrfs-submit-0(29134): WRITE block 741832 on dm-11 (56 sectors)
<7>[38554.249963] sync(3354): WRITE block 128 on dm-11 (8 sectors)
<7>[38554.250010] sync(3354): WRITE block 131072 on dm-11 (8 sectors)

<7>[38567.312908] sync(3356): dirtied inode 1 (?) on dm-11
<7>[38567.313330] btrfs-submit-0(29134): WRITE block 301256 on dm-11 (24 sectors)
<7>[38567.313350] btrfs-submit-0(29134): WRITE block 741960 on dm-11 (24 sectors)
<7>[38567.313358] btrfs-submit-0(29134): WRITE block 301288 on dm-11 (24 sectors)
<7>[38567.313366] btrfs-submit-0(29134): WRITE block 741992 on dm-11 (24 sectors)
<7>[38567.313393] btrfs-submit-0(29134): WRITE block 301312 on dm-11 (8 sectors)
<7>[38567.313403] btrfs-submit-0(29134): WRITE block 742016 on dm-11 (8 sectors)
<7>[38567.325194] sync(3356): WRITE block 128 on dm-11 (8 sectors)
<7>[38567.325244] sync(3356): WRITE block 131072 on dm-11 (8 sectors)

<7>[38570.374449] sync(3358): dirtied inode 1 (?) on dm-11
<7>[38570.374976] btrfs-submit-0(29134): WRITE block 301128 on dm-11 (56 sectors)
<7>[38570.375011] btrfs-submit-0(29134): WRITE block 741832 on dm-11 (56 sectors)
<7>[38570.379221] sync(3358): WRITE block 128 on dm-11 (8 sectors)
<7>[38570.379272] sync(3358): WRITE block 131072 on dm-11 (8 sectors)

<7>[38572.170816] sync(3359): dirtied inode 1 (?) on dm-11
<7>[38572.171289] btrfs-submit-0(29134): WRITE block 301256 on dm-11 (24 sectors)
<7>[38572.171300] btrfs-submit-0(29134): WRITE block 741960 on dm-11 (24 sectors)
<7>[38572.171304] btrfs-submit-0(29134): WRITE block 301288 on dm-11 (24 sectors)
<7>[38572.171308] btrfs-submit-0(29134): WRITE block 741992 on dm-11 (24 sectors)
<7>[38572.171320] btrfs-submit-0(29134): WRITE block 301312 on dm-11 (8 sectors)
<7>[38572.171325] btrfs-submit-0(29134): WRITE block 742016 on dm-11 (8 sectors)
<7>[38572.180338] sync(3359): WRITE block 128 on dm-11 (8 sectors)
<7>[38572.180386] sync(3359): WRITE block 131072 on dm-11 (8 sectors)

<7>[38574.186559] sync(3360): dirtied inode 1 (?) on dm-11
<7>[38574.187090] btrfs-submit-0(29134): WRITE block 301128 on dm-11 (56 sectors)
<7>[38574.187125] btrfs-submit-0(29134): WRITE block 741832 on dm-11 (56 sectors)
<7>[38574.191602] sync(3360): WRITE block 128 on dm-11 (8 sectors)
<7>[38574.191654] sync(3360): WRITE block 131072 on dm-11 (8 sectors)

<7>[38576.370003] sync(3361): dirtied inode 1 (?) on dm-11
<7>[38576.370452] btrfs-submit-0(29134): WRITE block 301256 on dm-11 (24 sectors)
<7>[38576.370470] btrfs-submit-0(29134): WRITE block 741960 on dm-11 (24 sectors)
<7>[38576.370478] btrfs-submit-0(29134): WRITE block 301288 on dm-11 (24 sectors)
<7>[38576.370485] btrfs-submit-0(29134): WRITE block 741992 on dm-11 (24 sectors)
<7>[38576.370513] btrfs-submit-0(29134): WRITE block 301312 on dm-11 (8 sectors)
<7>[38576.370523] btrfs-submit-0(29134): WRITE block 742016 on dm-11 (8 sectors)
<7>[38576.379718] sync(3361): WRITE block 128 on dm-11 (8 sectors)
<7>[38576.379766] sync(3361): WRITE block 131072 on dm-11 (8 sectors)

Every other sync the same.

-- 
Stephane
