Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:62799 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751816AbcIJH64 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 10 Sep 2016 03:58:56 -0400
Subject: Re: [PATCH v13 00/15] Btrfs In-band De-duplication
To: Mark Fasheh <mfasheh@suse.de>, Qu Wenruo <quwenruo@cn.fujitsu.com>
References: <20160908071304.25616-1-quwenruo@cn.fujitsu.com>
 <20160910002259.GR5316@wotan.suse.de>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
From: Qu Wenruo <quwenruo.btrfs@gmx.com>
Message-ID: <327320d0-2e3b-a991-499c-6c923c6f8331@gmx.com>
Date: Sat, 10 Sep 2016 15:58:18 +0800
MIME-Version: 1.0
In-Reply-To: <20160910002259.GR5316@wotan.suse.de>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 09/10/2016 08:22 AM, Mark Fasheh wrote:
> On Thu, Sep 08, 2016 at 03:12:49PM +0800, Qu Wenruo wrote:
>> This patchset can be fetched from github:
>> https://github.com/adam900710/linux.git wang_dedupe_20160907
>>
>> This version is just another small update, rebased to David's
>> for-next-20160906 branch.
>>
>> This updates only includes one small fix, which is exposed by recent
>> commits which checks space_info->bytes_may_use at umount time.
>> Caused by that we only free quota reserved space at hash hit, but doesn't
>> free space_info->bytes_may_use.
>>
>> Other rebase changes are all related to recent infrastructure change,
>> like io_tree and quota flags change.
>>
>> We ran xfstests with dedupe enabled.
>
> Is there an xfstests patch for this I can look at? We want to be able to run
> and reproduce the same tests as you.

Any btrfs test which enable dedupe and trigger dedupe will cause kernel 
warning at umount time.
So, no new test cases, either submitted xfstest dedupe test cases, or 
enabling dedupe by modifying xfstests.

We were testing it by modifying _scratch_mount() and _test_mount() to 
enable dedupe for *EVERY* test case.

But now we are adding support to enable quota/dedupe for any test case 
if FSTYP is "btrfs" and environment variant 
"ALWAYS_ENABLE_BTRFS_FEATURE" contains "dedupe".

We will submit such patch to help increase the coverage soon and will CC 
anyone who is interested in inband dedupe and quota.

>
> Also where are the disk portion patches or did I miss them somehow?

Disk format changes are planned for later merge, just as changelog 
version 11 mentioned, we are focusing on the in-memory backend for now.

Only after in-memory backend is stable and merged then we will consider 
other backend.

Thank,
Qu

> 	--Mark
>
> --
> Mark Fasheh
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
