Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:10669 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750734AbcGLSBW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Jul 2016 14:01:22 -0400
Subject: Re: [PATCH v2] Btrfs: fix panic in balance due to EIO
To: Liu Bo <bo.li.liu@oracle.com>, <linux-btrfs@vger.kernel.org>
References: <1468283820-25471-1-git-send-email-bo.li.liu@oracle.com>
 <1468344577-8684-1-git-send-email-bo.li.liu@oracle.com>
CC: David Sterba <dsterba@suse.cz>
From: Chris Mason <clm@fb.com>
Message-ID: <258213dd-3720-a572-c2e3-4697b5e0bbeb@fb.com>
Date: Tue, 12 Jul 2016 14:01:00 -0400
MIME-Version: 1.0
In-Reply-To: <1468344577-8684-1-git-send-email-bo.li.liu@oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/12/2016 01:29 PM, Liu Bo wrote:
> During build_backref_tree(), if we fail to read a btree node,
> we can eventually run into BUG_ON(cache->nr_nodes) that we put
> in backref_cache_cleanup(), meaning we have at least one
> memory leak.
>
> This frees the backref_node that we's allocated at the very
> beginning of build_backref_tree().
>
> Signed-off-by: Liu Bo <bo.li.liu@oracle.com>

Signed-off-by: Chris Mason <clm@fb.com>

-chris
