Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:24819 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752147AbcD1OOC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Apr 2016 10:14:02 -0400
Subject: Re: [PATCH RFC 03/16] btrfs-progs: fsck: Introduce function to query
 tree block level
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, <linux-btrfs@vger.kernel.org>
References: <1461642543-4621-1-git-send-email-quwenruo@cn.fujitsu.com>
 <1461642543-4621-4-git-send-email-quwenruo@cn.fujitsu.com>
CC: <dsterba@suse.cz>, Lu Fengqi <lufq.fnst@cn.fujitsu.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <ed7323de-cc1d-603c-0064-9e016f026f1b@fb.com>
Date: Thu, 28 Apr 2016 10:13:45 -0400
MIME-Version: 1.0
In-Reply-To: <1461642543-4621-4-git-send-email-quwenruo@cn.fujitsu.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2016 11:48 PM, Qu Wenruo wrote:
> From: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
>
> Introduce function query_tree_block_level() to resolve tree block level
> by reading out the tree block.
>
> Signed-off-by: Lu Fengqi <lufq.fnst@cn.fujitsu.com>
> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
> ---

This skips the check_tree_block if the transid passes, but we could have 
a matching transid but a corrupt item.  You need to fix 
read_tree_block_fs_info to always call check_block so we can be sure 
that our btrfs_header_level() is valid here.  Thanks,

Josef
