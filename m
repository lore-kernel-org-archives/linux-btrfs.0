Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:26144 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727043AbeGTGTX (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 20 Jul 2018 02:19:23 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [bug report] btrfs: Add type check when reading a chunk
Date: Fri, 20 Jul 2018 05:32:47 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A38230@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20180719081053.f46f3pmrdoia64ws@mwanda>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8A37CB1@G08CNEXMBPEKD02.g08.fujitsu.local>
 <20180719092201.GD26141@twin.jikos.cz> <20180719101403.GG26141@twin.jikos.cz>
In-Reply-To: <20180719101403.GG26141@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Thursday, July 19, 2018 6:14 PM
> To: dsterba@suse.cz; Gu, Jinxiang/é¡¾ é‡‘é¦™ <gujx@cn.fujitsu.com>; Dan Carpenter <dan.carpenter@oracle.com>;
> linux-btrfs@vger.kernel.org
> Subject: Re: [bug report] btrfs: Add type check when reading a chunk
> 
> On Thu, Jul 19, 2018 at 11:22:01AM +0200, David Sterba wrote:
> > On Thu, Jul 19, 2018 at 08:18:25AM +0000, Gu, Jinxiang wrote:
> > >
> > >
> > > > -----Original Message-----
> > > > From: Dan Carpenter [mailto:dan.carpenter@oracle.com]
> > > > Sent: Thursday, July 19, 2018 4:11 PM
> > > > To: Gu, Jinxiang/é¡¾ é‡‘é¦™ <gujx@cn.fujitsu.com>
> > > > Cc: linux-btrfs@vger.kernel.org
> > > > Subject: [bug report] btrfs: Add type check when reading a chunk
> > > >
> > > > Hello Gu Jinxiang,
> > > >
> > > > The patch 72e75ed03c8d: "btrfs: Add type check when reading a chunk"
> > > > from Jul 4, 2018, leads to the following static checker warning:
> > > >
> > > > 	fs/btrfs/volumes.c:6388 btrfs_check_chunk_valid()
> > > > 	warn: AND to zero '0x4 & 0x1'
> > > >
> > > > fs/btrfs/volumes.c
> > > >   6356          if (!is_power_of_2(stripe_len) || stripe_len != BTRFS_STRIPE_LEN) {
> > > >   6357                  btrfs_err(fs_info, "invalid chunk stripe length: %llu",
> > > >   6358                            stripe_len);
> > > >   6359                  return -EIO;
> > > >   6360          }
> > > >   6361          if (~(BTRFS_BLOCK_GROUP_TYPE_MASK | BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> > > >   6362              type) {
> > > >   6363                  btrfs_err(fs_info, "unrecognized chunk type: %llu",
> > > >   6364                            ~(BTRFS_BLOCK_GROUP_TYPE_MASK |
> > > >   6365                              BTRFS_BLOCK_GROUP_PROFILE_MASK) &
> > > >   6366                            btrfs_chunk_type(leaf, chunk));
> > > >   6367                  return -EIO;
> > > >   6368          }
> > > >   6369
> > > >   6370          if ((type & BTRFS_BLOCK_GROUP_TYPE_MASK) == 0) {
> > > >   6371                  btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> > > >   6372                  return -EIO;
> > > >   6373          }
> > > >   6374
> > > >   6375          if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> > > >   6376              (type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> > > >   6377                  btrfs_err(fs_info,
> > > >   6378                          "system chunk with data or metadata type: %llu", type);
> > > >   6379                  return -EIO;
> > > >   6380          }
> > > >   6381
> > > >   6382          features = btrfs_super_incompat_flags(fs_info->super_copy);
> > > >   6383          if (features & BTRFS_FEATURE_INCOMPAT_MIXED_GROUPS)
> > > >   6384                  mixed = 1;
> > > >   6385
> > > >   6386          if (!mixed) {
> > > >   6387                  if (type &
> > > >   6388                      (BTRFS_BLOCK_GROUP_METADATA & BTRFS_BLOCK_GROUP_DATA)) {
> > > >                              ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > > > Was this supposed to be | or perhaps check that both are set?
> > > Yes. It should be |.
> > > Thank you, I'll send a patch to fix it.
> >
> > Not needed, I'll fix the patch directly.
> 
> And that leads to failed mount:
> 
> [   10.867868] BTRFS error (device vda): mixed chunk type in non-mixed mode: 1
> [   10.871084] BTRFS error (device vda): failed to read chunk tree: -5
> [   10.908541] BTRFS error (device vda): open_ctree failed
> 
> Please send fixed version.

I send a patch to fix this.
Patch: btrfs: fix bug of chunk type check
And, if possible, please just fold it into 72e75ed03c8d: "btrfs: Add type check when reading a chunk".

Thanks, Gu Jinxiang

> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
