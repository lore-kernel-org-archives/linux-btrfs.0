Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:40499 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751547Ab2HPNao (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 16 Aug 2012 09:30:44 -0400
Message-ID: <502CF602.8070105@gmx.net>
Date: Thu, 16 Aug 2012 15:30:42 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: trivial code style fix in root-tree.c
References: <502CF2F0.7020601@gmail.com> <502CF450.50405@gmx.net> <502CF50C.9090006@gmail.com>
In-Reply-To: <502CF50C.9090006@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 16.08.2012 15:26, Wang Sheng-Hui wrote:
> On 2012年08月16日 21:23, Arne Jansen wrote:
>> On 16.08.2012 15:17, Wang Sheng-Hui wrote:
>>> Add code indent to the bad styled statements.
>>>
>>> Signed-off-by: Wang Sheng-Hui <shhuiw@gmail.com>
>>> ---
>>>  root-tree.c |   10 ++++------
>>>  1 files changed, 4 insertions(+), 6 deletions(-)
>>>
>>> diff --git a/root-tree.c b/root-tree.c
>>> index 782472c..39cfef6 100644
>>> --- a/root-tree.c
>>> +++ b/root-tree.c
>>> @@ -182,12 +182,10 @@ int btrfs_del_root(struct btrfs_trans_handle *trans, struct btrfs_root *root,
>>>  	if (ret < 0)
>>>  		goto out;
>>>  	if (ret) {
>>> -btrfs_print_leaf(root, path->nodes[0]);
>>> -printk("failed to del %llu %u %llu\n",
>>> -	(unsigned long long)key->objectid,
>>> -	key->type,
>>> -	(unsigned long long)key->offset);
>>> -
>>
>> I guess Alexander intentionally put in the bad indentation
>> to remind him to remove this code before submitting the
>> patch :)
>>
>>> +		btrfs_print_leaf(root, path->nodes[0]);
>>> +		printk("failed to del %llu %u %llu\n",
>>> +			(unsigned long long)key->objectid, key->type,
>>> +			(unsigned long long)key->offset);
>>>  	}
> 
> When I saw the BUG_ON, I wonder do we still need the above branch statement.
> It looks just to be helpful for debug - give out some info, right? 

Yes. So either we delete it completely or we move the BUG_ON
into the block as a BUG_ON(1) and add a "Btrfs: "-prefix to the
printk.
On the other hand, I just saw this is progs, so I think it can
just be deleted.

> 
>>>  	BUG_ON(ret != 0);
>>>  	leaf = path->nodes[0];
>>
> 

