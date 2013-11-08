Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17122 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1755588Ab3KHAcA (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 7 Nov 2013 19:32:00 -0500
Message-ID: <527C312F.5070204@cn.fujitsu.com>
Date: Fri, 08 Nov 2013 08:32:47 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Stefan Behrens <sbehrens@giantdisaster.de>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 02/17] btrfs: Added btrfs_workqueue_struct implemented
 ordered execution based on kernel workqueue
References: <1383803527-23736-1-git-send-email-quwenruo@cn.fujitsu.com> <1383803527-23736-3-git-send-email-quwenruo@cn.fujitsu.com> <527B5E6C.9000506@giantdisaster.de> <20131107160529.GI16662@twin.jikos.cz>
In-Reply-To: <20131107160529.GI16662@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On thu, 7 Nov 2013 17:05:29 +0100, David Sterba wrote:
> On Thu, Nov 07, 2013 at 10:33:32AM +0100, Stefan Behrens wrote:
>>> +struct btrfs_work_struct {
>>> +	void (*func)(struct btrfs_work_struct *arg);
>>> +	void (*ordered_func)(struct btrfs_work_struct *arg);
>>> +	void (*ordered_free)(struct btrfs_work_struct *arg);
>>> +
>>> +	/* Don't touch things below */
>>> +	struct work_struct normal_work;
>>> +	struct work_struct ordered_work;
>>> +	struct completion normal_completion;
>>> +};
>> If you compare the Btrfs sources before applying your patchset and after
>> applying all 17 patches, one change is this:
>> -struct btrfs_work {
>> +struct btrfs_work_struct {
>>
>> Which causes changes s/struct btrfs_work/struct btrfs_work_struct/ like
>> in patch 16/17:
>> -	struct btrfs_work	work;
>> +	struct btrfs_work_struct
>> +				work;
>>
>> -static void scrub_bio_end_io_worker(struct btrfs_work *work);
>> +static void scrub_bio_end_io_worker(struct btrfs_work_struct *work);
>>
>> I just don't see any good reason for renaming 'struct foo' to 'struct
>> foo_struct'.
> It seems to be meaningfull only though out this patchset. The old
> contents of btrfs_work is different from btrfs_work_struct, I agree it's
> right to have the name without _struct suffix. But then the change to
> new worker structs would have to be done in one single patch, while
> there are 10+ patches converting each worker type.
>
> I suggest to add one more patch to the end that removes the _struct
> suffix again, so the series does not have to be redone.
>
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
Yes, the "_struct" suffix is mostly used to distinguishfrom the original
btrfs_workers, and also try to use the kernel workqueue naming, which has
the "_struct" suffix.
And itis true that the long struct name makes some original codes ugly.

I'll add a new patchafter all these patches to remove the long suffix.

Thanks
Qu

-- 
-----------------------------------------------------
Qu Wenruo
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST)
No. 6 Wenzhu Road, Nanjing, 210012, China
TEL: +86+25-86630566-8526
COINS: 7998-8526
FAX: +86+25-83317685
MAIL: quwenruo@cn.fujitsu.com
-----------------------------------------------------

