Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.133]:54484 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388200AbeGWSJx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 23 Jul 2018 14:09:53 -0400
Subject: Re: [PATCH] btrfs: fix size_t format string
To: dsterba@suse.cz, Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        Qu Wenruo <wqu@suse.com>, Nikolay Borisov <nborisov@suse.com>,
        Su Yue <suy.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20180717135236.3673195-1-arnd@arndb.de>
 <20180717150400.GA3126@twin.jikos.cz>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <544184a7-25ae-55a6-3e81-0e1fa1e5cd1d@infradead.org>
Date: Mon, 23 Jul 2018 10:07:42 -0700
MIME-Version: 1.0
In-Reply-To: <20180717150400.GA3126@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/17/2018 08:04 AM, David Sterba wrote:
> On Tue, Jul 17, 2018 at 03:52:27PM +0200, Arnd Bergmann wrote:
>> The newly added check_block_group_item() function causes a build warning
>> on 32-bit architectures:
>>
>> fs/btrfs/tree-checker.c: In function 'check_block_group_item':
>> fs/btrfs/tree-checker.c:404:41: error: format '%lu' expects argument of type 'long unsigned int', but argument 6 has type 'unsigned int' [-Werror=format=]
>>
>> The type of a sizeof() expression is size_t, which is correctly printed
>> using the %zu format string.
>>
>> Fixes: 9dc16aad5660 ("btrfs: tree-checker: Verify block_group_item")
> 
> Folded to the commit, thanks.
> 

Hi David,
Where did this patch end up?  linux-next-20180723 is still showing this
format warning.

thanks,
-- 
~Randy
