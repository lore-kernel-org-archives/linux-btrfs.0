Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:47560 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751988AbdHBRrG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 13:47:06 -0400
Date: Wed, 2 Aug 2017 10:47:01 -0700
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH] btrfs: copy fsid to super_block s_uuid
Message-ID: <20170802174701.GB4457@magnolia>
References: <20170801103508.19746-1-anand.jain@oracle.com>
 <20170801153644.GA4457@magnolia>
 <14c243df-4532-33ab-7e72-89de96f19b2e@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <14c243df-4532-33ab-7e72-89de96f19b2e@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 02, 2017 at 02:02:11PM +0800, Anand Jain wrote:
> 
> Hi Darrick,
> 
>  Thanks for commenting..
> 
> >>+	memcpy(&sb->s_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
> >
> >uuid_copy()?
> 
>   It requires a larger migration to use uuid_t, IMO it can be done all
>   together, in a separate patch ?
> 
>   Just for experiment, starting with struct btrfs_fs_info.fsid and
>   to check its foot prints, I just renamed fsid to fs_id, and compiled.
>   It reports 73 'has no member named ‘fsid'' errors.
>   So looks like redefining u8 fsid[] to uuid_t fsid and further updating
>   all its foot prints, has to be simplified. Any suggestions ?

Cocinelle script?

<shrug> It was a fairly simply transition for xfs and others, though
from a simple grep it looks like btrfs uses open coded u8 arrays in a
few more places.

--D

> 
> Thanks, Anand
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
