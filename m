Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:47314 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1161746AbcEaCIl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 May 2016 22:08:41 -0400
Subject: Re: [PATCH] btrfs-progs: tests: run rollback after conversion
To: <dsterba@suse.cz>, David Sterba <dsterba@suse.com>,
        <linux-btrfs@vger.kernel.org>
References: <1464623554-5119-1-git-send-email-dsterba@suse.com>
 <20160530155656.GD29147@twin.jikos.cz>
 <8eee3f8f-f9ab-e978-c3e9-6007bda17560@cn.fujitsu.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <cf32759c-2ead-c9ef-7823-4ca1fbd5dadc@cn.fujitsu.com>
Date: Tue, 31 May 2016 10:08:33 +0800
MIME-Version: 1.0
In-Reply-To: <8eee3f8f-f9ab-e978-c3e9-6007bda17560@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Problem located.

may_rollback() is still the old codes, while for new convert's metadata, 
it's complete OK if it's physical position is different from its logical 
space.
Unlike the strict old condition.

I'll add more check to ensure new convert can pass may_rollback() check.

Thanks,
Qu

Qu Wenruo wrote on 2016/05/31 09:13 +0800:
>
>
> David Sterba wrote on 2016/05/30 17:56 +0200:
>> Hi Qu,
>>
>> the convert patchset does not pass a rollback test, fails in the case of
>> 32k nodesize. Thre's not much info why, just 'rollback failed'.
>>
>> The branch that passes is 'test-rollback', it's current devel without
>> the convert and low-mem fsck patchsets.
>>
>>
> Pretty strange.
>
> As I manually tested a ext4 filled with my /etc, used 32K default
> incompat flags, both convert and rollback succeeded without problem.
>
> The same is for convert-tests.sh.
> All passed here, just as what we did when developing the patchset.
>
> The commit head I tested is 2a7c68a4e46f4713e746d6e977e9c4cf27913ce3.
>
> Did you have more info on the situation where the rollback fails?
> Like the commit head, test method (I assume it's rollback tests from
> btrfs-progs)?
>
> Thanks,
> Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


