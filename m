Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:38188 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759654Ab3BLOjF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 09:39:05 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id DF7DA9A0653
	for <linux-btrfs@vger.kernel.org>; Tue, 12 Feb 2013 07:39:03 -0700 (MST)
Date: Tue, 12 Feb 2013 09:39:01 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Miao Xie <miaox@cn.fujitsu.com>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix the deadlock between the transaction attach
 and commit
Message-ID: <20130212143901.GC2611@localhost.localdomain>
References: <5114A177.5020604@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5114A177.5020604@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 11:55:51PM -0700, Miao Xie wrote:
> Here is the whole story:
> 	Trans_Attach_Task		Trans_Commit_Task
> 					btrfs_commit_transaction()
> 					 |->wait writers to be 1
> 	btrfs_attach_transaction()	 |
> 	btrfs_commit_transaction()	 |
> 	 |				 |->set trans_no_join to 1
> 	 |				 |  (close join transaction)
> 	 |->btrfs_run_ordered_operations |
> 	    (Those ordered operations	 |
> 	     are added when releasing	 |
> 	     file)			 |
> 	     |->btrfs_join_transaction() |
> 		|->wait_commit()	 |
> 					 |->wait writers to be 1

I'm just dropping this patch, the way you describe this deadlock can't happen
since the second btrfs_join_transaction() would see theres already a
transaction in current->journal_info and use that and not do wait_commit().  If
you observed a deadlock like this then look at it again, there is something else
going wrong.  Thanks,

Josef
