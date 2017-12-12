Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp2130.oracle.com ([141.146.126.79]:60450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752679AbdLLXFG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 12 Dec 2017 18:05:06 -0500
Subject: Re: [PATCH v3 0/5] define BTRFS_DEV_STATE
To: dsterba@suse.cz, dsterba@suse.com, linux-btrfs@vger.kernel.org
References: <20171210091522.6061-1-anand.jain@oracle.com>
 <20171212174249.GN3553@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <d37abb08-087f-7372-2196-c98b60229b63@oracle.com>
Date: Wed, 13 Dec 2017 06:38:12 +0800
MIME-Version: 1.0
In-Reply-To: <20171212174249.GN3553@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/13/2017 01:42 AM, David Sterba wrote:
> On Sun, Dec 10, 2017 at 05:15:17PM +0800, Anand Jain wrote:
>> As of now device properties and states are being represented as int
>> variable, patches here makes them bit flags instead. Further, wip
>> patches such as device failed state needs this cleanup.
>>
>> v2:
>>   Adds BTRFS_DEV_STATE_REPLACE_TGT
>>   Adds BTRFS_DEV_STATE_FLUSH_SENT
>>   Drops BTRFS_DEV_STATE_CAN_DISCARD
>>   Starts bit flag from the bit 0
>>   Drops unrelated change - declare btrfs_device
>>
>> v3:
>>   Fix static checker warning, define respective dev state as bit number
> 
> The define numbers are fixed but the whitespace changes that I made in
> misc-next

  Will do next time. Thanks. I don't see misc-next. Is it for-next ?

  git branch -a
* master
   remotes/origin/HEAD -> origin/master
   remotes/origin/for-4.13-part1
   remotes/origin/for-4.14
   remotes/origin/for-4.15-rc2
   remotes/origin/for-4.15-rc3
   remotes/origin/for-chris-4.12
   remotes/origin/for-next
   remotes/origin/for-next-test
   remotes/origin/master
   remotes/origin/nowait-aio-btrfs-fixup
git remote -v
origin	git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git (fetch)
origin	git://git.kernel.org/pub/scm/linux/kernel/git/kdave/linux.git (push)

Thanks, Anand


> while merging the patches are not in v3. I'd expect that you
> update your patches if there's another iteration and there have been
> changes to the merged ones, or send me only incrementals to the merged
> code or instructions how to fix it up if it's a trivial change like
> that.
