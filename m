Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932576AbeD0TcR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Apr 2018 15:32:17 -0400
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 1EFB7AF5A
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Apr 2018 19:32:16 +0000 (UTC)
Subject: Re: [PATCH 1/3] btrfs: qgroups, fix rescan worker running races
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20180426192351.473-1-jeffm@suse.com>
 <20180427155608.GC21272@twin.jikos.cz>
 <fbfbd98c-a7ee-4309-22ab-1e3a8416d27a@suse.com>
 <20180427164031.GH21272@twin.jikos.cz>
From: Jeff Mahoney <jeffm@suse.com>
Message-ID: <9714f37c-2ab4-2c07-7ced-a174f281d53f@suse.com>
Date: Fri, 27 Apr 2018 15:32:14 -0400
MIME-Version: 1.0
In-Reply-To: <20180427164031.GH21272@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/27/18 12:40 PM, David Sterba wrote:
> On Fri, Apr 27, 2018 at 12:02:13PM -0400, Jeff Mahoney wrote:
>>>> +static void queue_rescan_worker(struct btrfs_fs_info *fs_info)
>>>> +{
>>>
>>> And this had to be moved upwards as there was earlier use of
>>> btrfs_queue_work that matched following the hunk.
>>
>> Weird.  That must be exactly the kind of mismerge artifact that we were
>> talking about the other day.  In my tree it's in the right spot.
> 
> I've tried current master, upcoming pull request queue (misc-4.17, one
> nonc-onflicting patch) and current misc-next. None of them applies the
> patch cleanly and the function is still added after the first use, so
> this would not compile.
> 
> The result can be found in
> https://github.com/kdave/btrfs-devel/commits/ext/jeffm/qgroup-fixes
> 

Thanks.  The "Fixes" is incorrect there.  I had the right commit message
but not the right commit id.  It should be:

8d9eddad1946 (Btrfs: fix qgroup rescan worker initialization)

-Jeff

-- 
Jeff Mahoney
SUSE Labs
