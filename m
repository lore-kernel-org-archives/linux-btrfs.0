Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51340 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755018AbdHYIcX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 25 Aug 2017 04:32:23 -0400
Subject: Re: [PATCH][v2] btrfs: change how we decide to commit transactions
 during flushing
From: Nikolay Borisov <nborisov@suse.com>
To: josef@toxicpanda.com, linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc: Josef Bacik <jbacik@fb.com>
References: <1503432039-7666-1-git-send-email-jbacik@fb.com>
 <703e4090-1bd7-afd7-ecb6-a4f07047d823@suse.com>
Message-ID: <cfc2e650-b161-1cc2-1b8b-831f1acf282c@suse.com>
Date: Fri, 25 Aug 2017 11:32:21 +0300
MIME-Version: 1.0
In-Reply-To: <703e4090-1bd7-afd7-ecb6-a4f07047d823@suse.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 24.08.2017 17:43, Nikolay Borisov wrote:
> 
> 
> On 22.08.2017 23:00, josef@toxicpanda.com wrote:
>> From: Josef Bacik <jbacik@fb.com>
>>
>> Nikolay reported that generic/273 was failing currently with ENOSPC.
>> Turns out this is because we get to the point where the outstanding
>> reservations are greater than the pinned space on the fs.  This is a
>> mistake, previously we used the current reservation amount in
>> may_commit_transaction, not the entire outstanding reservation amount.
>> Fix this to find the minimum byte size needed to make progress in
>> flushing, and pass that into may_commit_transaction.  From there we can
>> make a smarter decision on whether to commit the transaction or not.
>> This fixes the failure in generic/273.
>>
>> Reported-by: Nikolay Borisov <nborisov@suse.com>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
> 
> Reviewed-and-tested-by: Nikolay Borisov <nborisov@suse.com>


For this commit we might also add:

Fixes: 957780eb2788 ("Btrfs: introduce ticketed enospc infrastructure")
Cc: stable@vger.kernel.org # 4.8
