Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33094 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750847AbdI2HPD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 29 Sep 2017 03:15:03 -0400
To: miaox@cn.fujitsu.com
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
From: Nikolay Borisov <nborisov@suse.com>
Subject: delayed inodes implementation questions
Message-ID: <f44de3db-b49a-d1af-350d-5f08a0445abf@suse.com>
Date: Fri, 29 Sep 2017 10:15:01 +0300
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello,


I've been studying the implementation of the delayed inodes feature and
have a couple of questions.

1. Why are there 2 lists when each and every node is on both lists at
the same time? So if we happen to be running the async worker we are
processing nodes based on the prepared_list, at the same time if there
is a concurent transaction commit happening then the exact some nodes
are going to be processed from the node_list - it's not a functional
problem but the presence of 2 lists and each node being on the same list
at the same time just seems a bit redundant.

2. in btrfs_next_delayed_node can this code really trigger:

 if (!test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags)) {
                /* not in the list */

                if (list_empty(&delayed_root->node_list))

                        goto out;

                p = delayed_root->node_list.next;

In order for !test_bit(BTRFS_DELAYED_NODE_IN_LIST, &node->flags) to be
true this means this node should have been btrfs_dequeue_delayed_node
underneath us? Can this really happen e.g. have multiple concurrent
__btrfs_run_delayed_items executions?
