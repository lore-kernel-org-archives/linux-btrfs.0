Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:53446 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750907AbdI2IAq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 04:00:46 -0400
Subject: Re: delayed inodes implementation questions
To: Nikolay Borisov <nborisov@suse.com>, miaox@cn.fujitsu.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
References: <f44de3db-b49a-d1af-350d-5f08a0445abf@suse.com>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <54d1ee20-4653-75be-f55a-05c8d8709aef@gmx.com>
Date: Fri, 29 Sep 2017 16:00:29 +0800
MIME-Version: 1.0
In-Reply-To: <f44de3db-b49a-d1af-350d-5f08a0445abf@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 2017年09月29日 15:15, Nikolay Borisov wrote:
> Hello,
> 
> 
> I've been studying the implementation of the delayed inodes feature and
> have a couple of questions.

Sorry I can't answer your question, but as you may already know by the 
rejection mail, Miao Xie has left Fujitsu and has been for several years.

And I'm not sure if he still checks btrfs mail list, so you may be on 
your own.

So to avoid such situation, it would be better to maintain a wiki page 
for such less maintained features, about it design principle and 
possible corner cases.

This will make later developers quite happy.
(personally speaking, this should be done before coding)

Thanks,
Qu
> 
> 1. Why are there 2 lists when each and every node is on both lists at
> the same time? So if we happen to be running the async worker we are
> processing nodes based on the prepared_list, at the same time if there
> is a concurent transaction commit happening then the exact some nodes
> are going to be processed from the node_list - it's not a functional
> problem but the presence of 2 lists and each node being on the same list
> at the same time just seems a bit redundant.
> 
> 2. in btrfs_next_delayed_node can this code really trigger:
> 
>   if (!test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags)) {
>                  /* not in the list */
> 
>                  if (list_empty(&delayed_root->node_list))
> 
>                          goto out;
> 
>                  p = delayed_root->node_list.next;
> 
> In order for !test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags) to be
> true this means this node should have been btrfs_dequeue_delayed_node
> underneath us? Can this really happen e.g. have multiple concurrent
> __btrfs_run_delayed_items executions?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
