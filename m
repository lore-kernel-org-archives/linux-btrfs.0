Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:15561 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753057AbdHWCcw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 22:32:52 -0400
From: "Gu, Jinxiang" <gujx@cn.fujitsu.com>
To: "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: RE: [PATCH] btrfs-progs: mkfs: Replace number with enum
Date: Wed, 23 Aug 2017 02:32:49 +0000
Message-ID: <516DDBE5B1D92D42BCF7A2E37F045A5D0141284B06@G08CNEXMBPEKD02.g08.fujitsu.local>
References: <20170628095924.3276-1-gujx@cn.fujitsu.com>
 <20170821173948.GU2866@twin.jikos.cz> <20170822140404.GV2866@twin.jikos.cz>
In-Reply-To: <20170822140404.GV2866@twin.jikos.cz>
Content-Type: text/plain; charset="gb2312"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> -----Original Message-----
> From: David Sterba [mailto:dsterba@suse.cz]
> Sent: Tuesday, August 22, 2017 10:04 PM
> To: Gu, Jinxiang/¹Ë ½ğÏã <gujx@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> Subject: Re: [PATCH] btrfs-progs: mkfs: Replace number with enum
> 
> On Mon, Aug 21, 2017 at 07:39:49PM +0200, David Sterba wrote:
> > > +/* roots: root tree, extent tree, chunk tree, dev tree, fs tree,
> > > +csum tree */ enum btrfs_mkfs_block {
> > > +	SUPER_BLOCK = 0,
> > > +	ROOT_TREE,
> > > +	EXTENT_TREE,
> > > +	CHUNK_TREE,
> > > +	DEV_TREE,
> > > +	FS_TREE,
> > > +	CSUM_TREE,
> > > +	BLOCK_COUNT
> 
> BLOCK_COUNT is 7

> 
> > > +};
> > > +
> > >  struct btrfs_mkfs_config {
> > >  	/* Label of the new filesystem */
> > >  	const char *label;
> > > @@ -43,7 +55,7 @@ struct btrfs_mkfs_config {
> > >  	/* Output fields, set during creation */
> > >
> > >  	/* Logical addresses of superblock [0] and other tree roots */
> > > -	u64 blocks[8];
> > > +	u64 blocks[BLOCK_COUNT];
> 
> This replaces 8 with 7 then, so the fs_uuid gets overwritten, can be also caught by simply running 'make test-mkfs'.

I made this change because block[7] is never used. I have run 'make test-mkfs', and get no error.
Why need to make a u64 left before fs_uuid?

> 
> > >  	char fs_uuid[BTRFS_UUID_UNPARSED_SIZE];
> > >  	char chunk_uuid[BTRFS_UUID_UNPARSED_SIZE];
> > >
> > > --
> > > 2.9.4
> > >
> > >
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe
> > > linux-btrfs" in the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-btrfs"
> > in the body of a message to majordomo@vger.kernel.org More majordomo
> > info at  http://vger.kernel.org/majordomo-info.html
> 



ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±ı»k~ÏâØ^n‡r¡ö¦zËëh™¨è­Ú&£ûàz¿äz¹Ş—ú+€Ê+zf£¢·hšˆ§~†­†Ûiÿÿïêÿ‘êçz_è®æj:+v‰¨ş)ß£øm
