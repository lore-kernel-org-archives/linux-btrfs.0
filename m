Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58356 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752949AbbFXT0d (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Jun 2015 15:26:33 -0400
Date: Wed, 24 Jun 2015 15:26:22 -0400
From: Chris Mason <clm@fb.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Qu Wenruo <quwenruo@cn.fujitsu.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.cz>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] btrfs: delayed-ref: double free in
 btrfs_add_delayed_tree_ref()
Message-ID: <20150624192622.GA3920@ret.masoncoding.com>
References: <20150624143233.GF1702@mwanda>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20150624143233.GF1702@mwanda>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 24, 2015 at 05:32:33PM +0300, Dan Carpenter wrote:
> There is a cut and paste error so instead of freeing "head_ref", we free
> "ref" twice.
> 
> Fixes: 3368d001ba5d ('btrfs: qgroup: Record possible quota-related extent for qgroup.')
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Thanks Dan!  Queued.

-chris
