Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:57706 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752867AbeGDNkd (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 4 Jul 2018 09:40:33 -0400
Date: Wed, 4 Jul 2018 15:40:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: "Gu, Jinxiang" <gujx@cn.fujitsu.com>, Nikolay Borisov <nborisov@suse.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "wen.xu@gatech.edu" <wen.xu@gatech.edu>,
        "xuwen.sjtu@gmail.com" <xuwen.sjtu@gmail.com>
Subject: Re: [PATCH v2] btrfs: Add chunk type check in read a chunk
Message-ID: <20180704134030.GR3126@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1530598800-9174-1-git-send-email-gujx@cn.fujitsu.com>
 <90e3c7e3-725f-7e19-25ac-9a9aee8128df@suse.com>
 <516DDBE5B1D92D42BCF7A2E37F045A5D01A8557E01@G08CNEXMBPEKD02.g08.fujitsu.local>
 <5358b5d9-2f35-369d-fb41-5be71780dc05@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5358b5d9-2f35-369d-fb41-5be71780dc05@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 04, 2018 at 05:49:50PM +0800, Qu Wenruo wrote:
> On 2018年07月04日 16:39, Gu, Jinxiang wrote:
> >> -----Original Message-----
> >> From: Nikolay Borisov [mailto:nborisov@suse.com]
> >> Sent: Wednesday, July 04, 2018 4:15 PM
> >> To: Gu, Jinxiang/顾 金香 <gujx@cn.fujitsu.com>; linux-btrfs@vger.kernel.org
> >> Cc: quwenruo.btrfs@gmx.com; wen.xu@gatech.edu; xuwen.sjtu@gmail.com
> >> Subject: Re: [PATCH v2] btrfs: Add chunk type check in read a chunk
> >> On  3.07.2018 09:20, Gu Jinxiang wrote:
> >>> Reported in https://bugzilla.kernel.org/show_bug.cgi?id=199839,
> >>> which has a invalid chunk, not return error opportunlly.
> >>>
> >>> Add chunk type check in btrfs_check_chunk_valid,
> >>> to make error be returned in advance.
> >>>
> >>> Reported-by: Xu Wen <wen.xu@gatech.edu>
> >>> Signed-off-by: Gu Jinxiang <gujx@cn.fujitsu.com>
> >>> ---
> >>> changelog:
> >>> v2:
> >>> deal with comment by Qu, add precise check for chunk type.
> >>>
> >>>  fs/btrfs/volumes.c | 27 +++++++++++++++++++++++++++
> >>>  1 file changed, 27 insertions(+)
> >>>
> >>> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >>> index e034ad9e23b4..fcdb1a75d653 100644
> >>> --- a/fs/btrfs/volumes.c
> >>> +++ b/fs/btrfs/volumes.c
> >>> @@ -6401,6 +6401,8 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> >>>  	u16 num_stripes;
> >>>  	u16 sub_stripes;
> >>>  	u64 type;
> >>> +	u64 features;
> >>> +	int mixed = 0;
> >>>
> >>>  	length = btrfs_chunk_length(leaf, chunk);
> >>>  	stripe_len = btrfs_chunk_stripe_len(leaf, chunk);
> >>> @@ -6439,6 +6441,31 @@ static int btrfs_check_chunk_valid(struct btrfs_fs_info *fs_info,
> >>>  			  btrfs_chunk_type(leaf, chunk));
> >>>  		return -EIO;
> >>>  	}
> >>> +
> >>> +	if (!(type & BTRFS_BLOCK_GROUP_TYPE_MASK)) {
> >>> +		btrfs_err(fs_info, "missing chunk type flag: %llu", type);
> >>> +		return -EIO;
> >>> +	}
> >>> +
> >>> +	if ((type & BTRFS_BLOCK_GROUP_SYSTEM) &&
> >>> +	(type & (BTRFS_BLOCK_GROUP_METADATA | BTRFS_BLOCK_GROUP_DATA))) {
> >>> +		btrfs_err(fs_info, "duplicate chunk type flag: %llu", type);
> >>
> >> This is not really a duplicate chunk type flag but instead an invalid
> >> combination. SYSTEM is always a dedicated chunk, rephrase the error
> >> message.
> > 
> > Yes. This message should be updated.
> > But [PATCH 1/5] btrfs: tree-checker: Verify block_group_item sent by Qu, checks the chunk type
> > in tree checker, which be called when read a bio. So this patch should not be merged.
> 
> Nope, this patch is still needed.
> 
> Although I added block group -> chunk checker, and it indeed detects all
> the crafted images, doing chunk verification is nothing wrong.
> 
> If chunk verification can detect anything wrong, we can error out even
> earlier.
> 
> So I still think this patch is needed.
> (Although I'd like to move a lot of chunk verification to tree-checker
> later)

I'd rather add that to the tree-checker.c now and the enhanced checks.
btrfs_check_chunk_valid is self-contained and does not use anything
that's local to volumes.c.
