Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:11107 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S938622AbdDTAk4 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Apr 2017 20:40:56 -0400
Subject: Re: [PATCH 0/9] Introduce btrfs-modify prog to make corruption easier
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20170417032642.30770-1-quwenruo@cn.fujitsu.com>
 <20170419181512.GI22319@twin.jikos.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cee5bc22-1bca-809f-999d-53491ec6b353@cn.fujitsu.com>
Date: Thu, 20 Apr 2017 08:40:52 +0800
MIME-Version: 1.0
In-Reply-To: <20170419181512.GI22319@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 04/20/2017 02:15 AM, David Sterba wrote:
> On Mon, Apr 17, 2017 at 11:26:33AM +0800, Qu Wenruo wrote:
>> Introduce a new command, btrfs-modify, which is not part of 'btrfs', but
>> an independent command, bring minimal impact to existing btrfs commands.
>>
>> Btrfs-modify is designed to provides better documentation than current
>> btrfs-corrupt-block with better subcommand division to reduce confusing
>> or conflicting options.
>>
>> Btrfs-modify paired with offline-scrub patchset (not merged yet) could
>> provide a full suite for test case writers to do corruption and recovery
>> verification.
> 
> Starting a new tool makes sense, the btrfs-corrupt-block lacks the
> subcommand hierarchy and it would be tedious to sew it in.
> 
> The commands that you add now still seem ad-hoc, adressing current
> needs.

Yes, the "mirror" command is indeed for current corruption recovery test 
cases.

But the ability to add new command easily could make the tool more generic.

> This is how the corrupt-block utility started as well. I'd like
> see some proposal of more potential uses and some command gouping. For
> example main group: set, get, map, delete, insert, show.

While I prefer to create command groups by their logical level.
For example, "mirror" as the lowest level.
And then "leaf", allowing us to modify specified leaf headers.

Then "item", allowing us to modify btrfs item and its stored structure.
Including modifying, inserting, removing.

The short objective is to allow us to modify one-item-one-structure 
structure, like INODE_ITEM or EXTENT_DATA, but not EXTENT_ITEM(inlined).

By this method, we can reducing the option combinations by limiting some 
options under certain commands.
Or the logic to check option validation will be a hell.

Thanks,
Qu

> Then, define
> for which objects the commands are applicable. We can start with the
> raid56 testing usecase. You want to locate and modify a block baced on
> the logical offset, so this should comprise of 'map' + 'set'. For
> specific tasks we can add shortcuts or compound commands, not from the
> start.


