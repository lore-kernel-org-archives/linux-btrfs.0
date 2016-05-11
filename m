Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mgwym04.jp.fujitsu.com ([211.128.242.43]:32848 "EHLO
	mgwym04.jp.fujitsu.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbcEKC0z (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 May 2016 22:26:55 -0400
Received: from m3051.s.css.fujitsu.com (m3051.s.css.fujitsu.com [10.134.21.209])
	by yt-mxauth.gw.nic.fujitsu.com (Postfix) with ESMTP id 550A7AC04BC
	for <linux-btrfs@vger.kernel.org>; Wed, 11 May 2016 11:26:46 +0900 (JST)
Subject: Re: About in-band dedupe for v4.7
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        btrfs <linux-btrfs@vger.kernel.org>
References: <aae84f04-cb64-46f3-79ea-f2d84d79a3ba@cn.fujitsu.com>
 <20160511003758.e3hy5v3lwbtethjl@floor.thefacebook.com>
 <a8fdf4f2-4b3c-7c17-1709-55ae61888f94@cn.fujitsu.com>
From: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Message-ID: <5732984B.1000809@jp.fujitsu.com>
Date: Wed, 11 May 2016 11:26:19 +0900
MIME-Version: 1.0
In-Reply-To: <a8fdf4f2-4b3c-7c17-1709-55ae61888f94@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016/05/11 10:40, Qu Wenruo wrote:
>
>
> Chris Mason wrote on 2016/05/10 20:37 -0400:
>> On Tue, May 10, 2016 at 03:19:52PM +0800, Qu Wenruo wrote:
>>> Hi, Chris, Josef and David,
>>>
>>> As merge window for v4.7 is coming, it would be good to hear your ideas
>>> about the inband dedupe.
>>>
>>> We are addressing the ENOSPC problem which Josef pointed out, and we believe
>>> the final fix patch would come out at the beginning of the merge
>>> window.(Next week)
>>>
>>>
>>> If it's fine, would you please consider to merge the in-memory backend
>>> patchset for v4.7 as an experimental feature?
>>>
>>>
>>> Most of the patch won't be changed from v10 patchset, only ENOSPC fix will
>>> be updated, and ioctl patchset will introduce a new Kconfig option of "btrfs
>>> experimental features" for inband dedupe.
>>> (With explain about unstable ioctl/on-disk format for experimental features)
>>>
>>>
>>> If you are all OK to merge inband dedupe in-memory backend, I'll prepare the
>>> new v11 patchset for this merge.
>>
>> We have to balance the part where we really want the features to come
>> in, and we want to lower the load on you to continue porting them.  But,
>> I really do agree that we need strong test suites included with every
>> major feature like this.
>>
>> -chris
>>
>>
> That's fine.
>
> We're running all generic and btrfs test case with dedupe enabled,
 > by modifying xfstest to call "btrfs dedeup enable"
> just after mount, to ensure dedupe won't corrupt any existing test case.

How about writing the xfstests patch that we can run
the above tests without modifying xfstests by hand?
Then it becomes easy for everyone to test dedupe.

Thanks,
Satoru

>
> And we are also enriching our dedupe test cases to reduce the stability concern on the new feature.
>
>
> BTW, does it mean inband dedup won't catch v4.7 merge window and no need to submit a v11 patchset for this merge window?
>
> Thanks,
> Qu
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
