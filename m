Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:54136 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbbHVOiR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 22 Aug 2015 10:38:17 -0400
Date: Sat, 22 Aug 2015 07:37:46 -0700
From: Marc MERLIN <marc@merlins.org>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: Josef Bacik <jbacik@fb.com>, dsterba@suse.com, clm@fb.com,
        linux-btrfs@vger.kernel.org
Subject: Re: kernel BUG at fs/btrfs/extent-tree.c:8113! (4.1.3 kernel)
Message-ID: <20150822143746.GG5602@merlins.org>
References: <20150803035130.GL24824@merlins.org>
 <20150811050758.GF29259@merlins.org>
 <55CA177D.1050004@fb.com>
 <20150812144749.GY24824@merlins.org>
 <55CB631B.2080404@fb.com>
 <20150812160936.GK29259@merlins.org>
 <55CB71E5.1070302@fb.com>
 <20150812171912.GL29259@merlins.org>
 <55D1406C.9040607@cn.fujitsu.com>
 <20150817144904.GT29259@merlins.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150817144904.GT29259@merlins.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 17, 2015 at 07:49:04AM -0700, Marc MERLIN wrote:
> On Mon, Aug 17, 2015 at 10:01:16AM +0800, Qu Wenruo wrote:
> > Hi Marc,
>  
> Hi Qu, thanks for your answer and looking at this.
> 
> > Did btrfs-debug-tree also has the crash?
> > 
> > If not, would you please attach the output if it doesn't contain
> > classified data.
  
Do you need anything else before I wipe the filesystem and start over?

1) kernel is fixed not to crash
2) btrfs check --repair segfaults
3) btrfs-debug-tree ends with assert

Thanks,
Marc

> Sure thing:
> btrfs-debug-tree /dev/mapper/crypt_sdd1 > /tmp/tree.out
> parent transid verify failed on 2968115101696 wanted 34855 found 39533
> parent transid verify failed on 2968115101696 wanted 34855 found 39533
> parent transid verify failed on 2968115101696 wanted 34855 found 39533
> parent transid verify failed on 2968115101696 wanted 34855 found 39533
> Ignoring transid failure
> parent transid verify failed on 2968115134464 wanted 34855 found 39533
> parent transid verify failed on 2968115134464 wanted 34855 found 39533
> parent transid verify failed on 2968115134464 wanted 34855 found 39533
> parent transid verify failed on 2968115134464 wanted 34855 found 39533
> Ignoring transid failure
> parent transid verify failed on 2968115150848 wanted 34855 found 39533
> parent transid verify failed on 2968115150848 wanted 34855 found 39533
> parent transid verify failed on 2968115150848 wanted 34855 found 39533
> parent transid verify failed on 2968115150848 wanted 34855 found 39533
> Ignoring transid failure
> parent transid verify failed on 2968115691520 wanted 34855 found 39533
> parent transid verify failed on 2968115691520 wanted 34855 found 39533
> parent transid verify failed on 2968115691520 wanted 34855 found 39533
> parent transid verify failed on 2968115691520 wanted 34855 found 39533
> Ignoring transid failure
> parent transid verify failed on 1291597152256 wanted 35830 found 39530
> parent transid verify failed on 1291597152256 wanted 35830 found 39530
> parent transid verify failed on 1291597152256 wanted 35830 found 39530
> parent transid verify failed on 1291597152256 wanted 35830 found 39530
> Ignoring transid failure
> parent transid verify failed on 2968116592640 wanted 34855 found 39533
> parent transid verify failed on 2968116592640 wanted 34855 found 39533
> parent transid verify failed on 2968116592640 wanted 34855 found 39533
> parent transid verify failed on 2968116592640 wanted 34855 found 39533
> Ignoring transid failure
> parent transid verify failed on 2968116609024 wanted 34855 found 39533
> parent transid verify failed on 2968116609024 wanted 34855 found 39533
> parent transid verify failed on 2968116609024 wanted 34855 found 39533
> parent transid verify failed on 2968116609024 wanted 34855 found 39533
> Ignoring transid failure
> print-tree.c:1094: btrfs_print_tree: Assertion failed.
> btrfs-debug-tree[0x805ce93]
> btrfs-debug-tree(btrfs_print_tree+0x26d)[0x805eb51]
> btrfs-debug-tree(btrfs_print_tree+0x279)[0x805eb5d]
> btrfs-debug-tree(main+0x8b5)[0x804dfb7]
> /lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb757c4d3]
> btrfs-debug-tree[0x804e221]
> 
> Do you want the actual output?
> (it's 1.1GB uncompressed)
> 
> Marc
> 
> 
> > Thanks,
> > Qu
> > 
> > Marc MERLIN wrote on 2015/08/12 10:19 -0700:
> > >On Wed, Aug 12, 2015 at 12:18:45PM -0400, Josef Bacik wrote:
> > >>Going to need more info to figure this one out
> > >
> > >Thanks for the patch, here's the output:
> > >enabling repair mode
> > >Checking filesystem on /dev/mapper/crypt_sdd1
> > >UUID: 024ba4d0-dacb-438d-9f1b-eeb34083fe49
> > >checking extents
> > >wtf, parent 575708413952 <<<<<<
> > >cmds-check.c:4488: add_data_backref: Assertion `back->bytes != max_size` failed.
> > >/tmp/btrfs[0x8066a83]
> > >/tmp/btrfs[0x8066ab4]
> > >/tmp/btrfs[0x80679d8]
> > >/tmp/btrfs[0x806b4f2]
> > >/tmp/btrfs[0x806b9ea]
> > >/tmp/btrfs[0x806c5f9]
> > >/tmp/btrfs(cmd_check+0x1088)[0x806ee26]
> > >/tmp/btrfs(main+0x153)[0x80557d6]
> > >/lib/i386-linux-gnu/libc.so.6(__libc_start_main+0xf3)[0xb75a54d3]
> > >/tmp/btrfs[0x80557fc]
> > >
> > >Marc
> > >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
> -- 
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
