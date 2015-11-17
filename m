Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:14298 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751342AbbKQAmS (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Nov 2015 19:42:18 -0500
Subject: Re: Ideas for btrfs-convert fix(or rework)
To: <dsterba@suse.cz>, Qu Wenruo <quwenruo.btrfs@gmx.com>,
        btrfs <linux-btrfs@vger.kernel.org>, David Sterba <dsterba@suse.com>
References: <56418E5D.9020604@gmx.com> <20151116174636.GA31035@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <564A77E5.1040300@cn.fujitsu.com>
Date: Tue, 17 Nov 2015 08:42:13 +0800
MIME-Version: 1.0
In-Reply-To: <20151116174636.GA31035@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



David Sterba wrote on 2015/11/16 18:46 +0100:
> On Tue, Nov 10, 2015 at 02:27:41PM +0800, Qu Wenruo wrote:
>> [[FIX IDEA]]
>> 1. Too many patches
>
> Not percieved as a problem as long as the patches are well separated and
> reviewable. If you prefer reasonably many preparatory and trivial
> patches, then be it.
>
>> 2. superblock reserve is d*mning hard, not matter at what timing.
>>      Until I need to codes for superblock reserve, the codes are quite
>>      easy to write.
>>      But when it comes to sb reserve, I'm going to get crazy...
>
> What do you mean by the 'sb reserve'?

Superblock reserved space.
And the first 1Mb reserved space.

IIRC, normal btrfs and convert btrfs doesn't reserve super block space well.
For normal btrfs, it's still possible for device extent covering 
btrfs_sb_offset(), not to mention the converted one, which only uses one sb.

But the good news is, although it needs extra codes(about 5 patches and 
over 500 lines), it shouldn't be a big problem as I'll reserve these 
space at early time.

>
>>      I'll either add tons of codes to the simple chunk allocation to
>>      avoid using SB space and keep all chunks are large enough.
>>      Or I need to implement user-space whole chunk relocation codes.
>>
>>      I miss the old days when sb_bytenr can be specified by user...
>>      Then my work should be quite close to end...
>>
>> 3. Too aggressive rework
>>      I suppose this will not be a fix, but a total rework of the whole
>>      btrfs-convert program.
>>      Maybe only less than 30% old codes will stay, most of them will be
>>      rewritten.
>
> I suppose that the rewrite would also touch generic code, so as far as
> it's cleanups and other refactoring I won't object investing the time to
> that.

Not that much, most of the codes are rework of make_btrfs() to allow it 
to alloc metadata and system chunk at early time.
It's almost 10 patches and over 1000 lines to rework the huge 
make_btrfs() into structuralized make_btrfs_v2().

And will remove some btrfs-convert only hooks like custom_alloc_extent().

As now, btrfs-convert will has a meta and system chunk(not covering 
existing ext* data) after make_btrfs_v2().
And then data chunks will be inserted to cover all ext* data.
So no extra extent allocate routine is needed.

>
>>      No matter how I think the new code will be superior than old one,
>>      I'm pretty sure there will be tons of regression or new bugs for
>>      such huge rework.
>>
>>      But without such work, btrfs-convert will always be a mess and no
>>      real support for balance.
>>
>> So any ideas or advice is welcomed for this rework.
>
> In general, I welcome the efforts to make convert better. The in-place
> conversion is a unique feature and a nice to have. Several people
> mentioned that.  Next, we want to add support more filesystems, eg.
> reiserfs code is ready and needs configure checks and minor updates to
> convert.c.  Basically any filesystem that provides a library API similar
> to what ext2 does can be added. Convert code in a good shape would save
> us trouble.
>
> Expecting the regressions, the test set for the convertors needs to be
> enhanced, the current state is less then ideal. Possibly we can use the
> images from e2fsprogs testsuite.

Nice idea.

I'll try to enhance self test after btrfs-convert rework.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
