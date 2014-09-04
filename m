Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:35473 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750793AbaIDMsh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Sep 2014 08:48:37 -0400
Message-ID: <54085F9E.80206@fb.com>
Date: Thu, 4 Sep 2014 08:48:30 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Dan Carpenter <dan.carpenter@oracle.com>
CC: Josef Bacik <jbacik@fb.com>, <linux-btrfs@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] Btrfs: kfree()ing ERR_PTRs
References: <20140904110915.GB21504@mwanda>
In-Reply-To: <20140904110915.GB21504@mwanda>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/04/2014 07:09 AM, Dan Carpenter wrote:
> The "inherit" in btrfs_ioctl_snap_create_v2() and "vol_args" in
> btrfs_ioctl_rm_dev() are ERR_PTRs so we can't call kfree() on them.
> 
> These kind of bugs are "One Err Bugs" where there is just one error
> label that does everything.  I could set the "inherit = NULL" and keep
> the single out label but it ends up being more complicated that way.  It
> makes the code simpler to re-order the unwind so it's in the mirror
> order of the allocation and introduce some new error labels.

Thanks Dan, agreed on the unwinding.

-chris
