Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38715 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756563Ab3JKIDz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 11 Oct 2013 04:03:55 -0400
Message-ID: <5257B037.6060303@cn.fujitsu.com>
Date: Fri, 11 Oct 2013 16:00:55 +0800
From: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Daniel <daniel@wagners.name>
CC: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-convert won't convert ext* - No valid Btrfs found on /dev/sdb1
References: <CAGqmi74L9WrifDROz7Mr4r3BxqDWiyiQqy0Wn6JBdfz17qDY9A@mail.gmail.com> <5228A713.6060003@redhat.com> <20130905184453.GF15634@localhost.localdomain> <loom.20131011T095125-875@post.gmane.org>
In-Reply-To: <loom.20131011T095125-875@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello Daniel,

On 10/11/2013 03:52 PM, Daniel wrote:
> Hello Josef,
>
> Josef Bacik <jbacik <at> fusionio.com> writes:
>
>> On Thu, Sep 05, 2013 at 10:45:23AM -0500, Eric Sandeen wrote:
> [...]
>
>>> This was a regression around July 3; there was no regression test at
>>> the time.
>>>
>>> [615f2867854c186a37cb2e2e5a2e13e9ed4ab0df] Btrfs-progs: cleanup similar
> code in open_ctree_* and close_ctree
>>> broke it.
>>>
>>> Patches were sent to the list to fix it on July 17,
>>>
>>> https://patchwork.kernel.org/patch/2828820/
>>>
>>> but they haven't been merged into the main repo.
>>>
>>> I sent a regression test for it to the list on Aug 4, but nobody
>>> reviewed it, so it hasn't been merged into the test suite, either.
>>>
>>> Winning all around!
>> Alright, alright I'll review it, Jesus.  ;),
> Is there any progress on this or can I help with solving this somehow?
This problem has been fixed , but it did not come into Chris's branch.
But it did come into david's integration branches.

http://github.com/kdave/btrfs-progs.git integration-20131008

Thanks,
Wang
>   
>> Josef
> Daniel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

