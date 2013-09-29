Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43708 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752277Ab3I2PCj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 Sep 2013 11:02:39 -0400
Message-ID: <52484105.8090302@oracle.com>
Date: Sun, 29 Sep 2013 23:02:29 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Zach Brown <zab@redhat.com>
CC: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <20130927191029.GX30372@lenny.home.zabbo.net> <52470F85.6040405@oracle.com>
In-Reply-To: <52470F85.6040405@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>>
>>> +    printf("\tUnshared space: \t%s\n",
>>> +        pretty_size(freeable_bytes));
>>
>> There's no reason to have a local variable:
>>
>>     printf("\tUnshared space: \t%s\n",
>>         pretty_size(get_subvol_freeable_bytes(fd));
>>
>>

this is taken care.


>> These two fiddly functions only differ in the tree search and what they
>> do with each item.  So replace them with a function that takes a
>> description of the search and calls the caller's callback for each item.
>>
>> typedef void (*item_func_t)(struct btrfs_key *key, void *data, void
>> *arg);
>>
>> int btrfs_for_each_item(int fd, min and max and junk,
>>             item_func_t func, void *arg);
>>
>> u64 get_subvol_freeable_bytes(int fd)
>> {
>>     u64 size_bytes = 0;
>>
>>     btrfs_for_each_item(fd, ...., sum_extents, &size_bytes);
>>
>>     return size_bytes;
>> }
>>
>> Etc.  You get the idea.
>
>
>   Will fix them.  Thanks !
>
> -Anand

  this is to avoid duplicate codes, which indeed spans across
  most of the search functions that's in there in btrfs-progs.
  what you suggest is good, but its better to do that collectively.


Thanks, Anand
