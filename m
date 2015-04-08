Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout4.samsung.com ([203.254.224.34]:60848 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751476AbbDHX4Z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Apr 2015 19:56:25 -0400
Received: from epcpsbgr2.samsung.com
 (u142.gpu120.samsung.co.kr [203.254.230.142])
 by mailout4.samsung.com (Oracle Communications Messaging Server 7.0.5.31.0
 64bit (built May  5 2014))
 with ESMTP id <0NMI007QSIHZ8F70@mailout4.samsung.com> for
 linux-btrfs@vger.kernel.org; Thu, 09 Apr 2015 08:56:23 +0900 (KST)
Date: Wed, 08 Apr 2015 23:56:21 +0000 (GMT)
From: =?euc-kr?B?wM7BpL3E?= <js7.in@samsung.com>
Subject: Re: Re: Re: Porting BTRFS to user space
To: Hugo Mills <hugo@carfax.org.uk>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Reply-to: js7.in@samsung.com
MIME-version: 1.0
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <1233276516.596701428537380887.JavaMail.weblogic@epmlwas06c>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

My goal is to make a "native" DFS, with native as contrast to overlay.
It's about performance and features.

1. With overlay DFS, overlying system and underlying system do pretty much overlaping tasks:
        maintain/lookup meta-data, keep data/meta-data consistency, and etc.
    They are both implementational duplication and performance overhead.
2. If I overlay some FS over BTRFS, many of the BTRFS features would be hidden: especially COW and snapshot.
   It means I have to implement them independently if I need them.
   On the other hand, by embedding distribution layer into BTRFS, all the BTRFS features could be inherited with minimal cost.
If any of the existing DFS were fine for me, I would have been using it.

Of course I have to deal with all the issues coming from the distribution.

------- Original Message -------
Sender : Hugo Mills<hugo@carfax.org.uk> 
Date   : 2015-04-08 21:27 (GMT+09:00)
Title  : Re: Re: Porting BTRFS to user space

On Wed, Apr 08, 2015 at 12:03:29PM +0000, ÀÎÁ¤½Ä wrote:
> Thank you for the advise.
> I am still wonder why there are same-name files in btrfs(kernel source) and btrfs-progs.
> They are quite many as follows.
>     backref.{c, h}
>     ctree.{c, h}
>     dir-item.c
>     disk-io.{c, h}
>     extent_io.{c, h}
>     extent-tree.c
>     file.c
>     file-item.c
>     free-space-cashe.{c, h}
>     hash.h
>     inode.c
>     inode-item.c
>     inode-map.c
>     print-tree.{c, h}
>     props.{c, h}
>     qgroup.{c, h}
>     root-tree.c
>     send.h
>     ulist.{c, h}
>     uuid-tree.c
>     volumes.{c, h}
> 
> It seems btrfs-progs files have been ported from kernel files.
> Are they the result of efforts to port btrfs from kernel to user space?

   Kind of. They were copied from kernel space some time ago, but have
diverged from that point significantly since. There's all kinds of
extra flags and options in the userspace code that allow it to bypass
particular kinds of checks for the recovery tools. The kernel
implementation will have moved on in different ways since, as well.

> Or at least can I utilize the them so that I have to only port the remaining files?

   You'll probably find that a lot of the remainder are to do with the
interface to the block layer, which I think (without actually knowing
much about FUSE) you won't need to do much of.

   I have to say, I'm somewhat more concerned about your distributed
systems design. You haven't mentioned anywhere any of the design
features that you would have to think about for a distributed
filesystem. For example, how do you handle concurrent access from
different machines, node failures, network failures, caching of
data/metadata, synchronisation of write followed by read (possibly by
a different node)?

   I would suggest that you're better off spending your effort on
those issues in your userspace distributed filesystem, and simply
using btrfs itself as a backing store. This gives you a useful
separation between the relatively simple underlying "write some bytes
to permanent storage" layer and the horrible, nasty, complicated
"manage a distributed data store in a usable way" layer on top of it.

   It's noticeable that pretty much all of the network and distributed
filesystems that I'm aware of have this kind of architecture: an
ordinary boring non-distributed filestore running on each storage
node, and a networking, metadata, caching and management layer on top
of that to deal with the distributed parts. (NFS, Ceph, Gluster
certainly work this way. I would be surprised if any of the others out
there at the moment didn't work like that).

   Hugo.

> ------- Original Message -------
> Sender : Austin S Hemmelgarn<ahferroin7@gmail.com> 
> Date   : 2015-04-08 20:37 (GMT+09:00)
> Title  : Re: Porting BTRFS to user space
> 
> On 2015-04-07 19:57, ÀÎÁ¤½Ä wrote:
> > Thank you for the information.
> > I just found that btrfs-progs includes several files that seem modified from btrfs kernel source.
> > I am not sure exactly what they are.
> > Web pages say libbtrfs is to provide interface for apps that use btrfs.
> > Why should there be duplicated codes between kernel and user space?
> > Is it an on-going effort to port whole btrfs to user space?
> > 
> > Could you lead me to some more information about libbtrfs or how to port btrfs to user space?
> > 
> > Thank you,
> > Jeongsik
> > 
> > 
> As far as I understand it, the intent is to allow things like btrfs
> check and btrfs restore to still work even if the kernel doesn't have
> btrfs support.  From what I can tell, you are the first person to
> actually be serious about getting BTRFS running in userspace, so there
> probably isn't much BTRFS specific literature out there.
> 
> I would, however suggest looking at the FUSE drivers for ext4 and ZFS,
> as those are both ported from kernel space, and should give some good
> examples of where to start.
> 
> <p>&nbsp;</p><p>&nbsp;</p>

-- 
Hugo Mills             | "I lost my leg in 1942. Some bastard stole it in a
hugo@... carfax.org.uk | pub in Pimlico."
http://carfax.org.uk/  |
PGP: E2AB1DE4          |
<p>&nbsp;</p><p>&nbsp;</p>ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
