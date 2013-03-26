Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:34764 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934781Ab3CZPZ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Mar 2013 11:25:56 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 5090E9A0680
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Mar 2013 09:25:56 -0600 (MDT)
Date: Tue, 26 Mar 2013 11:25:53 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
CC: Josef Bacik <JBacik@fusionio.com>, Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: No space left on device (28)
Message-ID: <20130326152553.GN1955@localhost.localdomain>
References: <20130322204932.GE1955@localhost.localdomain>
 <514CC52B.1000201@profihost.ag>
 <20130325201426.GG1955@localhost.localdomain>
 <51515226.9010509@profihost.ag>
 <20130326125319.GH1955@localhost.localdomain>
 <51519ABB.4030207@profihost.ag>
 <20130326133053.GK1955@localhost.localdomain>
 <5151A75C.6080703@profihost.ag>
 <20130326144426.GL1955@localhost.localdomain>
 <5151B8AF.60900@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5151B8AF.60900@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 26, 2013 at 09:03:11AM -0600, Stefan Priebe - Profihost AG wrote:
> Hi,
> Am 26.03.2013 15:44, schrieb Josef Bacik:
> >>>> Am 26.03.2013 13:53, schrieb Josef Bacik:
> >>>> no - it's just mounted with mount -o noatime
> >>>>
> >>>> :~# cat /proc/mounts | grep btrfs
> >>>> /dev/mapper/raid54tb1 /mnt btrfs rw,noatime,space_cache 0 0
> >>>>
> >>>
> >>> Ok I think I see what's going on.  Can you try this patch and see if it fixes
> >>> it?  Thanks,
> >>
> >> It still does not fix the problem.
> >>
> >> The rsync output looks like this so it does not work for file a but then
> >> continues on c d e, ...
> >>
> >> sync -av --progress /backup/ /mnt/
> >> sending incremental file list
> >> .etc_openvpn/ipp.txt
> >>          229 100%    3.99kB/s    0:00:00 (xfer#2, to-check=1009/1196)
> >> .etc_openvpn/openvpn-status.log
> >>          360 100%    6.28kB/s    0:00:00 (xfer#3, to-check=1007/1196)
> >> rsync: rename "/mnt/.etc_openvpn/.ipp.txt.t9lucX" ->
> >> ".etc_openvpn/ipp.txt": No space left on device (28)
> >> .log/
> >> .log/UcliEvt.log
> >>       104188 100%  147.67kB/s    0:00:00 (xfer#4, to-check=1131/2700)
> >> .log/auth.log
> >>     15211522 100%    2.97MB/s    0:00:04 (xfer#5, to-check=1105/2700)
> >> .log/auth.log.1
> >>     19431424  61%    7.35MB/s    0:00:01
> >>
> >> the dmesg output looks like this:
> >> [  551.321576] returning enospc, space_info 3, size 0 reserved 0, flush
> >> 2, flush_state 7  dumping space info
> >> [  551.323694] space_info 4 has 6439526400 free, is full
> >> [  551.323696] space_info total=25748307968, used=19308666880, pinned=0,
> >> reserved=49152, may_use=6438453248, readonly=65536
> >>
> > 
> > Ok so then this is probably it, let me know if it helps.  Thanks,
> 
> OK it now has copied a lot of files (170) without an error all were very
> small.
>

Welp progress is good.  Throw this into the mix and go again, it's just adding
some more debugging so I can make sure I'm going down the right rabbit hole.
Thanks,

Josef 

diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
index 84e8909..1cf810a 100644
--- a/fs/btrfs/extent-tree.c
+++ b/fs/btrfs/extent-tree.c
@@ -4026,6 +4026,15 @@ static int flush_space(struct btrfs_root *root,
 
 	return ret;
 }
+
+static void dump_block_rsv(struct btrfs_block_rsv *block_rsv)
+{
+	spin_lock(&block_rsv->lock);
+	printk(KERN_ERR "dumping block rsv %u, size %Lu reserved %Lu\n",
+	       block_rsv->type, block_rsv->size, block_rsv->reserved);
+	spin_unlock(&block_rsv->lock);
+}
+
 /**
  * reserve_metadata_bytes - try to reserve bytes from the block_rsv's space
  * @root - the root we're allocating for
@@ -4179,6 +4188,9 @@ out:
 			       "flush %d, flush_state %d  dumping space info\n", block_rsv->type,
 			       block_rsv->size, block_rsv->reserved, flush, flush_state);
 			spin_unlock(&block_rsv->lock);
+			dump_block_rsv(&root->fs_info->delalloc_block_rsv);
+			dump_block_rsv(&root->fs_info->delayed_block_rsv);
+			dump_block_rsv(&root->fs_info->global_block_rsv);
 			dump_space_info(space_info, 0, 0);
 		}
 
-- 
1.7.7.6

