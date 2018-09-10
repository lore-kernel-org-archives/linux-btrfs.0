Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54106 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727535AbeIJWK0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 10 Sep 2018 18:10:26 -0400
Subject: Re: [RFC PATCH linux-next] btrfs: btrfs_run_delayed_refs_for_head()
 can be static
To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        Chris Mason <chris.mason@fusionio.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org
References: <201809102215.95hxOLVe%fengguang.wu@intel.com>
 <20180910150029.GA11874@lkp-wsm-ep1.lkp.intel.com>
 <20180910164843.GS24025@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <7438b39c-dabf-568b-efdb-afef9cd513fd@suse.com>
Date: Mon, 10 Sep 2018 20:15:18 +0300
MIME-Version: 1.0
In-Reply-To: <20180910164843.GS24025@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10.09.2018 19:48, David Sterba wrote:
> On Mon, Sep 10, 2018 at 11:00:29PM +0800, kbuild test robot wrote:
>>
>> Fixes: ac75a14eb672 ("btrfs: Factor out loop processing all refs of a head")
>> Signed-off-by: kbuild test robot <fengguang.wu@intel.com>
>> ---
>>  extent-tree.c |    6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
>> index b0882b6..719f1bb 100644
>> --- a/fs/btrfs/extent-tree.c
>> +++ b/fs/btrfs/extent-tree.c
>> @@ -2537,9 +2537,9 @@ struct btrfs_delayed_ref_head *btrfs_obtain_ref_head(
>>  }
>>  
>>  STATIC
>> -int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
>> -				    struct btrfs_delayed_ref_head *locked_ref,
>> -				    unsigned long *run_refs)
>> +static int btrfs_run_delayed_refs_for_head(struct btrfs_trans_handle *trans,
>> +					   struct btrfs_delayed_ref_head *locked_ref,
>> +					   unsigned long *run_refs)
> 
> I have a cleanup series to get rid of the STATIC macro, will result in
> normal 'static' of the function. The patch will need to be updated, you
> can ignore the warning for now.

So one added benefit of the STATIC macro (at least in XFS and hence I
used it here) is that STATIC functions are noinline_for_stack pretty
much which is why I wanted to use it here. I guess for btrfs we ought to
use a bare noinline_for_static

> 
>>  {
>>  	struct btrfs_fs_info *fs_info = trans->fs_info;
>>  	struct btrfs_delayed_ref_root *delayed_refs;
