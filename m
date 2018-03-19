Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:46953 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932616AbeCSLPj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 19 Mar 2018 07:15:39 -0400
Subject: Re: [PATCH] btrfs-progs: print-tree: Do correct offset output for
 ROOT_ITEM
From: Nikolay Borisov <nborisov@suse.com>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20180319102810.24356-1-wqu@suse.com>
 <d1fa813b-814c-21ff-4cc7-f6ba38399f9d@suse.com>
 <f14d629e-4174-9fea-9440-fd7d9b8dd5d7@gmx.com>
 <168142ff-0b85-463e-c028-6183ae32fd75@suse.com>
Message-ID: <ace03bb9-2676-e233-37e7-2b8171af779d@suse.com>
Date: Mon, 19 Mar 2018 13:15:35 +0200
MIME-Version: 1.0
In-Reply-To: <168142ff-0b85-463e-c028-6183ae32fd75@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 19.03.2018 12:54, Nikolay Borisov wrote:
> 
> 
> On 19.03.2018 12:50, Qu Wenruo wrote:
>> What about this value?
>> 18446744073709551607
>>
>> It's data reloc tree objectid.
>> And it's pretty long since it's -9ULL.
>>
>> At least this makes 2 objectid more readable.
> 
> Fair enough.
> 

Looking a bit more I wonder if we should use the same print_objectid
function for the "owner" field of a leaf block.

For the data reloc tree we currently get:

leaf 30490624 items 2 free space 16061 generation 4 owner
18446744073709551607


Or for the leaf belonging to the first fs tree (5):
leaf 30883840 items 11 free space 15354 generation 10 owner 5
