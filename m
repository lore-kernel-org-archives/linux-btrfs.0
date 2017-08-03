Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:59045 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751133AbdHCPHw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 3 Aug 2017 11:07:52 -0400
Subject: Re: [PATCH] btrfs: Move skip checksum check from btrfs_submit_direct
 to __btrfs_submit_dio_bio
To: Nikolay Borisov <nborisov@suse.com>, <linux-btrfs@vger.kernel.org>
References: <1501764298-24522-1-git-send-email-nborisov@suse.com>
From: Chris Mason <clm@fb.com>
Message-ID: <d5c7b3dd-268f-131f-ce57-dbc4ff5baf63@fb.com>
Date: Thu, 3 Aug 2017 11:07:39 -0400
MIME-Version: 1.0
In-Reply-To: <1501764298-24522-1-git-send-email-nborisov@suse.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/03/2017 08:44 AM, Nikolay Borisov wrote:
> Currently the code checks whether we should do data checksumming in
> btrfs_submit_direct and the boolean result of this check is passed to
> btrfs_submit_direct_hook, in turn passing it to __btrfs_submit_dio_bio which
> actually consumes it. The last function actually has all the necessary context
> to figure out whether to skip the check or not, so let's move the check closer
> to where it's being consumed. No functional changes.

I like it, thanks.

Reviewed-by: Chris Mason <clm@fb.com>

-chris
