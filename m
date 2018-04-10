Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:50817 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751650AbeDJBtq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 21:49:46 -0400
Subject: Re: [PATCH] btrfs-progs: Use more loose open ctree flags for
 dump-tree and restore
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180406063919.11771-1-wqu@suse.com>
 <20180409141235.GP8557@twin.jikos.cz>
 <a75a16c3-eb04-5c64-a861-e370aa144606@gmx.com>
 <20180409150538.GW8557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <f5a96b8d-5325-bc23-c295-180496e5f2bb@gmx.com>
Date: Tue, 10 Apr 2018 09:49:28 +0800
MIME-Version: 1.0
In-Reply-To: <20180409150538.GW8557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月09日 23:05, David Sterba wrote:
> On Mon, Apr 09, 2018 at 10:29:34PM +0800, Qu Wenruo wrote:
>>>> --- a/cmds-inspect-dump-tree.c
>>>> +++ b/cmds-inspect-dump-tree.c
>>>> @@ -303,7 +303,9 @@ int cmd_inspect_dump_tree(int argc, char **argv)
>>>>  	int uuid_tree_only = 0;
>>>>  	int roots_only = 0;
>>>>  	int root_backups = 0;
>>>> -	unsigned open_ctree_flags = OPEN_CTREE_FS_PARTIAL;
>>>> +	/* Speed up open_ctree() and continue if extent tree is corrupted */
>>>> +	unsigned open_ctree_flags = OPEN_CTREE_PARTIAL |
>>>> +				    OPEN_CTREE_NO_BLOCK_GROUPS;
>>>
>>> We could consider that separatelly, whether to allow dumping a partially
>>> created filesystem, ie. OPEN_CTREE_FS_PARTIAL added by a new option.
>>
>> For dump-tree, there is really no limitation here.
>> As long as chunk tree is OK, we should be OK to do "-b" dump.
>>
>> For "-t" or all tree (default) dump, with chunk tree opened only, we
>> could try our best to print any good trees.
>> So I don't get the point to read all other trees.
> 
> Yeah, eg. a bad filesystem magic number does not stop dump-tree, so no
> change is needed.

Bad magic will still stop dump-tree, super block check is not affected
by open ctree flags.
The only way to block dump-tree is corrupted chunk tree, which mostly
makes the fs garbage.

Even root tree is corrupted, we can still specify bytenr manually to
salvage what we need.

The point here is still the same, for read-only operations where we
don't care about the cross-reference, there is no need to care about
extent tree at all, and skip block group item search could save us a lot
of time.

Thanks,
Qu
> 
