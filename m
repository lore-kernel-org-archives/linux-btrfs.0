Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46389 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751439AbaBGPJO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 7 Feb 2014 10:09:14 -0500
Message-ID: <52F4F755.4090503@fb.com>
Date: Fri, 7 Feb 2014 10:10:13 -0500
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Tejun Heo <tj@kernel.org>, Filipe David Borba Manana <fdmanana@gmail.com>,
        <linux-btrfs@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        David Rientjes <rientjes@google.com>
Subject: Re: [btrfs] BUG: unable to handle kernel NULL pointer dereference
 at 0000000000000038
References: <20140207023801.GC11051@localhost> <alpine.DEB.2.02.1402070213020.22146@chino.kir.corp.google.com> <20140207121038.GA1690@localhost>
In-Reply-To: <20140207121038.GA1690@localhost>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri 07 Feb 2014 07:10:38 AM EST, Fengguang Wu wrote:
> On Fri, Feb 07, 2014 at 02:13:59AM -0800, David Rientjes wrote:
>> On Fri, 7 Feb 2014, Fengguang Wu wrote:
>>
>>> [    1.625020] BTRFS: selftest: Running btrfs_split_item tests
>>> [    1.627004] BTRFS: selftest: Running find delalloc tests
>>> [    2.289182] tsc: Refined TSC clocksource calibration: 2299.967 MHz
>>> [  292.084537] kthreadd invoked oom-killer: gfp_mask=0x3000d0, order=1, oom_score_adj=0
>>> [  292.086439] kthreadd cpuset=
>>> [  292.087072] BUG: unable to handle kernel NULL pointer dereference at 0000000000000038
>>> [  292.087372] IP: [<ffffffff812119de>] pr_cont_kernfs_name+0x1b/0x6c
>>
>> This looks like a problem with the cpuset cgroup name, are you sure this
>> isn't related to the removal of cgroup->name?
>
> It looks not related to patch "cgroup: remove cgroup->name", because
> that patch lies in the cgroup tree and not contained in output of "git log BAD_COMMIT".

Still not sure exactly what is going on, but I can't trigger it here.  
My first guess is that it is related to having btrfs static, some part 
of our init is happening at the wrong time, and the self tests are 
swooping in and causing trouble.


