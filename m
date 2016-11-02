Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:38639 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751677AbcKBBTS (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 1 Nov 2016 21:19:18 -0400
Subject: Re: [PATCH v3 1/4] btrfs-progs: utils: Introduce function to escape
 characters
To: <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
 <20161101100851.GV12522@suse.cz>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <1382110a-9c56-e9e2-be33-77dbfffce4b6@cn.fujitsu.com>
Date: Wed, 2 Nov 2016 09:19:10 +0800
MIME-Version: 1.0
In-Reply-To: <20161101100851.GV12522@suse.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 11/01/2016 06:08 PM, David Sterba wrote:
> On Tue, Nov 01, 2016 at 04:01:43PM +0800, Qu Wenruo wrote:
>> Introduce new function, escape_string_inplace(), to escape specified
>> characters in place.
>
> Sorry, the pointer to seq_path was misleading. The actual escape
> function is mangle_path and it copies one string to another. As we just
> print the path, we can simply switch and call putchar.
>

Putchar() method is indeed much easier to implement.

But it makes us hard to do further formatting, like aligning the path to 
given width. (At least we are still using 32 chars alignment for path)

So I still prefer the current full function string escaping and still 
use %-32s for formatting.


And the idea of implementing escape_string_inplace() as a pure string 
manipulation function can make it more agile for later use.
For example, we can reuse it for print-tree.

Although the current esacpe_string_inplace() can be further fine-tuned 
to avoid calling memmove() in a loop, which I can update it in next version.

Thanks,
Qu


