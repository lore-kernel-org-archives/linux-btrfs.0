Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1633 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726033AbeHBHow (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 2 Aug 2018 03:44:52 -0400
From: "Huang\, Ying" <ying.huang@intel.com>
To: Chris Mason <clm@fb.com>
Cc: Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>, <lkp@01.org>,
        <linux-btrfs@vger.kernel.org>
Subject: Re: [LKP] [lkp-robot] [mm] 9092c71bb7: blogbench.write_score -12.3% regression
References: <20180408015739.GN3845@yexl-desktop>
        <876036apgx.fsf@yhuang-dev.intel.com>
        <878t7t3k3s.fsf@yhuang-dev.intel.com>
        <87h8m6m9ld.fsf@yhuang-dev.intel.com>
        <878t7ai08v.fsf@yhuang-dev.intel.com>
        <B33D77FE-E654-4BB3-A7F3-CEBCE93C6589@fb.com>
        <87zhyvew74.fsf@yhuang-dev.intel.com>
Date: Thu, 02 Aug 2018 13:55:23 +0800
In-Reply-To: <87zhyvew74.fsf@yhuang-dev.intel.com> (Ying Huang's message of
        "Fri, 13 Jul 2018 09:55:11 +0800")
Message-ID: <87tvod8g8k.fsf@yhuang-dev.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

"Huang, Ying" <ying.huang@intel.com> writes:

> Hi, Chris,
>
> Chris Mason <clm@fb.com> writes:
>
>> On 19 Jun 2018, at 23:51, Huang, Ying wrote:
>>>>> "Huang, Ying" <ying.huang@intel.com> writes:
>>>>>
>>>>>> Hi, Josef,
>>>>>>
>>>>>> Do you have time to take a look at the regression?
>>>>>>
>>>>>> kernel test robot <xiaolong.ye@intel.com> writes:
>>>>>>
>>>>>>> Greeting,
>>>>>>>
>>>>>>> FYI, we noticed a -12.3% regression of blogbench.write_score and
>>>>>>> a +9.6% improvement
>>>>>>> of blogbench.read_score due to commit:
>>>>>>>
>>>>>>>
>>>>>>> commit: 9092c71bb724dba2ecba849eae69e5c9d39bd3d2 ("mm: use
>>>>>>> sc->priority for slab shrink targets")
>>>>>>> https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git
>>>>>>> master
>>>>>>>
>>>>>>> in testcase: blogbench
>>>>>>> on test machine: 16 threads Intel(R) Xeon(R) CPU D-1541 @
>>>>>>> 2.10GHz with 8G memory
>>>>>>> with following parameters:
>>>>>>>
>>>>>>> 	disk: 1SSD
>>>>>>> 	fs: btrfs
>>>>>>> 	cpufreq_governor: performance
>>>>>>>
>>>>>>> test-description: Blogbench is a portable filesystem benchmark
>>>>>>> that tries to reproduce the load of a real-world busy file
>>>>>>> server.
>>>>>>> test-url:
>>
>> I'm surprised, this patch is a big win in production here at FB.  I'll
>> have to reproduce these results to better understand what is going on.
>> My first guess is that since we have fewer inodes in slab, we're
>> reading more inodes from disk in order to do the writes.
>>
>> But that should also make our read scores lower.
>
> Any update on this?

Ping.

Best Regards,
Huang, Ying
