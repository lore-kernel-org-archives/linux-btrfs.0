Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:3948 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753211AbbENAdV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 May 2015 20:33:21 -0400
Message-ID: <5553ED4F.3060207@cn.fujitsu.com>
Date: Thu, 14 May 2015 08:33:19 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 00/13]  Introduce offline fsid/chunk tree uuid change
 for btrfstune.
References: <1431331734-11714-1-git-send-email-quwenruo@cn.fujitsu.com> <20150513160325.GN23255@twin.jikos.cz>
In-Reply-To: <20150513160325.GN23255@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

That's very kind of you to modify them by yourself.

I have already prepared branches for both property and btrfstune, but 
you did it even before I send the v3 patchset.

Would you mind me to do all the modification you mentioned and send the 
v3 patchset?
This should save some time for you.

Thanks,
Qu

-------- Original Message  --------
Subject: Re: [PATCH v2 00/13]  Introduce offline fsid/chunk tree uuid 
change for btrfstune.
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2015年05月14日 00:03

> On Mon, May 11, 2015 at 04:08:41PM +0800, Qu Wenruo wrote:
>> Qu Wenruo (13):
>>    btrfs-progs: Add CHANGIND_FSID and CHANGING_CHUNK_TREE_ID super flags.
>>    btrfs-progs: Use unified function to implement print_readable_*_flag()
>>          function.
>>    btrfs-progs: Make btrfs-show-super print human readable flag for super
>>          flags.
>>    btrfs-progs: Add open_ctree check for uuid changing.
>>    btrfs-progs: Export write_tree_block().
>>    btrfs-progs: Introduce change_header_uuid() function.
>>    btrfs-progs: Introduce change_extents_uuid() function.
>>    btrfs-progs: Introduce change_device_uuid() function.
>>    btrfs-progs: Introduce change_devices_uuid() function.
>>    btrfs-progs: Introduce change_id_prepare() and change_id_done()
>>      functions.
>>    btrfs-progs: Introduce change_uuid() function.
>
> All of the above merged (with some minor modifications), this covers
> patches 1-7 from the first patchset. The btrfstune options are not
> there, it needs some updates after I dropped the extra option to set the
> chunk tree uuid.
>
> The expected use:
>
> * change the fsid to something that user specifies
> * change the fsid but generate it randomly
> * if the operation is interrupted, pick up the new fsid and continue
>    automatically, ie. the user does not have to remember uuid (this is
>    for convenience, the new fsid is stored in the superblock already and
>    can be obtained by show-super)
> * the new chunk tree uuid has to be stored in some block, eg. the root
>    node of the tree_root; then picked from there when the uuid change
>    process is restarted
>
> I'll get to that after doing the 4.0.1 release.
>
