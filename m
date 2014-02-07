Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f53.google.com ([209.85.214.53]:49268 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752929AbaBGPWK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 7 Feb 2014 10:22:10 -0500
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <52F4F755.4090503@fb.com>
References: <20140207023801.GC11051@localhost>
	<alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com>
	<20140207121038.GA1690@localhost>
	<52F4F755.4090503@fb.com>
Date: Fri, 7 Feb 2014 15:22:08 +0000
Message-ID: <CAL3q7H6ZRzXqaxF_DQbeiRdE_dy=62BjFHiBKt=YAiGgEeiCRA@mail.gmail.com>
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
From: Filipe David Manana <fdmanana@gmail.com>
To: Chris Mason <clm@fb.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Tejun Heo <tj@kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 7, 2014 at 3:10 PM, Chris Mason <clm@fb.com> wrote:
> On Fri 07 Feb 2014 07:10:38 AM EST, Fengguang Wu wrote:
>>
>> On Fri, Feb 07, 2014 at 02:13:59AM -0800, David Rientjes wrote:
>>>
>>> On Fri, 7 Feb 2014, Fengguang Wu wrote:
>>>
>>>> [    1.625020] BTRFS: selftest: Running btrfs_split_item tests
>>>> [    1.627004] BTRFS: selftest: Running find delalloc tests
>>>> [    2.289182] tsc: Refined TSC clocksource calibration: 2299.967 MHz
>>>> [  292.084537] kthreadd invoked oom-killer: gfp_mask=0x3000d0, order=1,
>>>> oom_score_adj=0
>>>> [  292.086439] kthreadd cpuset=
>>>> [  292.087072] BUG: unable to handle kernel NULL pointer dereference at
>>>> 0000000000000038
>>>> [  292.087372] IP: [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c
>>>
>>>
>>> This looks like a problem with the cpuset cgroup name, are you sure this
>>> isn't related to the removal of cgroup->name?
>>
>>
>> It looks not related to patch "cgroup: remove cgroup->name", because
>> that patch lies in the cgroup tree and not contained in output of "git log
>> BAD_COMMIT".
>
>
> Still not sure exactly what is going on, but I can't trigger it here.  My
> first guess is that it is related to having btrfs static, some part of our
> init is happening at the wrong time, and the self tests are swooping in and
> causing trouble.

I couldn't reproduce it either so far, neither on a physical machine
nor in a vm (qemu+kvm) (with CONFIG_BTRFS_FS=y, CONFIG_CRYPTO_CRC32C=y
and CONFIG_CRYPTO_CRC32C_INTEL=y).
If you disable CONFIG_BTRFS_FS_RUN_SANITY_TESTS, does it still crash?

thanks

>
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
