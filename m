Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37924 "EHLO
        mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751340AbeFTMi6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Jun 2018 08:38:58 -0400
From: Chris Mason <clm@fb.com>
To: "Huang, Ying" <ying.huang@intel.com>
CC: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, <lkp@01.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [LKP] [lkp-robot] [mm] 9092c71bb7: blogbench.write_score -12.3%
 regression
Date: Wed, 20 Jun 2018 08:38:45 -0400
Message-ID: <B33D77FE-E654-4BB3-A7F3-CEBCE93C6589@fb.com>
In-Reply-To: <878t7ai08v.fsf@yhuang-dev.intel.com>
References: <20180408015739.GN3845@yexl-desktop>
 <876036apgx.fsf@yhuang-dev.intel.com> <878t7t3k3s.fsf@yhuang-dev.intel.com>
 <87h8m6m9ld.fsf@yhuang-dev.intel.com> <878t7ai08v.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19 Jun 2018, at 23:51, Huang, Ying wrote:
>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>
>>>> Hi, Josef,
>>>>
>>>> Do you have time to take a look at the regression?
>>>>
>>>> kernel test robot <xiaolong.ye@intel.com> writes:
>>>>
>>>>> Greeting,
>>>>>
>>>>> FYI, we noticed a -12.3% regression of blogbench.write_score and a 
>>>>> +9.6% improvement
>>>>> of blogbench.read_score due to commit:
>>>>>
>>>>>
>>>>> commit: 9092c71bb724dba2ecba849eae69e5c9d39bd3d2 ("mm: use 
>>>>> sc->priority for slab shrink targets")
>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git 
>>>>> master
>>>>>
>>>>> in testcase: blogbench
>>>>> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @ 2.10GHz 
>>>>> with 8G memory
>>>>> with following parameters:
>>>>>
>>>>> 	disk: 1SSD
>>>>> 	fs: btrfs
>>>>> 	cpufreq_governor: performance
>>>>>
>>>>> test-description: Blogbench is a portable filesystem benchmark 
>>>>> that tries to reproduce the load of a real-world busy file server.
>>>>> test-url:

I'm surprised, this patch is a big win in production here at FB.  I'll 
have to reproduce these results to better understand what is going on.  
My first guess is that since we have fewer inodes in slab, we're reading 
more inodes from disk in order to do the writes.

But that should also make our read scores lower.

-chris
