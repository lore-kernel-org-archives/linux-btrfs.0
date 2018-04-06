Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.15]:60529 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751401AbeDFX1T (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 6 Apr 2018 19:27:19 -0400
Subject: Re: [PATCH v2 2/2] btrfs: Validate child tree block's level and first
 key
To: dsterba@suse.cz, Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org
References: <20180327124419.28398-1-wqu@suse.com>
 <20180327124419.28398-2-wqu@suse.com> <20180328154949.GO30422@twin.jikos.cz>
 <7d95e99d-09bf-483f-2fa8-3ab658c2a8f5@gmx.com>
 <20180406170748.GI8557@twin.jikos.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <34030821-fa65-73b3-fbea-789689bc785b@gmx.com>
Date: Sat, 7 Apr 2018 07:27:06 +0800
MIME-Version: 1.0
In-Reply-To: <20180406170748.GI8557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2018年04月07日 01:07, David Sterba wrote:
> On Mon, Apr 02, 2018 at 06:47:32PM +0800, Qu Wenruo wrote:
>> On 2018年03月28日 23:49, David Sterba wrote:
>>> On Tue, Mar 27, 2018 at 08:44:19PM +0800, Qu Wenruo wrote:
>>>> We have several reports about node pointer points to incorrect child
>>>> tree blocks, which could have even wrong owner and level but still with
>>>> valid generation and checksum.
>>>>
>>>> Although btrfs check could handle it and print error message like:
>>>> leaf parent key incorrect 60670574592
>>>>
>>>> Kernel doesn't have enough check on this type of corruption correctly.
>>>> At least add such check to read_tree_block() and btrfs_read_buffer(),
>>>> where we need two new parameters @level and @first_key to verify the
>>>> child tree block.
>>>>
>>>> The new @level check is mandatory and all call sites are already
>>>> modified to extract expected level from its call chain.
>>>>
>>>> While @first_key is optional, the following call sites are skipping such
>>>> check:
>>>> 1) Root node/leaf
>>>>    As ROOT_ITEM doesn't contain the first key, skip @first_key check.
>>>> 2) Direct backref
>>>>    Only parent bytenr and level is known and we need to resolve the key
>>>>    all by ourselves, skip @first_key check.
>>>>
>>>> Another note of this verification is, it needs extra info from nodeptr
>>>> or ROOT_ITEM, so it can't fit into current tree-checker framework, which
>>>> is limited to node/leaf boundary.
>>>>
>>>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>>>> ---
>>>> changelog:
>>>> v2:
>>>>   Make @level check mandatory, suggesed by Jeff and Nikolay.
>>>>   Change parameter order as @level is now mandatory, put it in front of
>>>>   @first_key.
>>>>   Change verify_parent_level() to verify_key_level() to avoid confusion
>>>>   on the @level parameter.
>>>>   Add btrfs_error() output for CONFIG_BTRFS_DEBUG to help debugging.
>>>
>>> That's much better overall, thanks. Adding it to next.
>>
>> Nikolay reported a case where @first_key check seems to cause false alert.
>> (Although my xfstests check hasn't exposed it yet)
>>
>> Please discard this patch since it has the possibility to cause false
>> alert for btrfs core functionality.
> 
> Too late, the patch is in master now, so we need to fix it.

Seems to be a very rare race in tree operations, still under investigation.

Thanks,
Qu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
