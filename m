Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34231 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751083AbdHBFzR (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Aug 2017 01:55:17 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH] btrfs: copy fsid to super_block s_uuid
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
References: <20170801103508.19746-1-anand.jain@oracle.com>
 <20170801153644.GA4457@magnolia>
Message-ID: <14c243df-4532-33ab-7e72-89de96f19b2e@oracle.com>
Date: Wed, 2 Aug 2017 14:02:11 +0800
MIME-Version: 1.0
In-Reply-To: <20170801153644.GA4457@magnolia>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Darrick,

  Thanks for commenting..

>> +	memcpy(&sb->s_uuid, fs_info->fsid, BTRFS_FSID_SIZE);
> 
> uuid_copy()?

   It requires a larger migration to use uuid_t, IMO it can be done all
   together, in a separate patch ?

   Just for experiment, starting with struct btrfs_fs_info.fsid and
   to check its foot prints, I just renamed fsid to fs_id, and compiled.
   It reports 73 'has no member named ‘fsid'' errors.
   So looks like redefining u8 fsid[] to uuid_t fsid and further updating
   all its foot prints, has to be simplified. Any suggestions ?

Thanks, Anand

