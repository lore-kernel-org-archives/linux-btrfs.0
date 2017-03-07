Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:4145 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752662AbdCGHaB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Mar 2017 02:30:01 -0500
Subject: Re: [PATCH 00/17] fs, btrfs refcount conversions
To: "Reshetova, Elena" <elena.reshetova@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1488531326-21271-1-git-send-email-elena.reshetova@intel.com>
 <7849485b-89a5-485b-dfcb-e6c8f6ef0aa0@cn.fujitsu.com>
 <2236FBA76BA1254E88B949DDB74E612B41C54E80@IRSMSX102.ger.corp.intel.com>
CC: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "jbacik@fb.com" <jbacik@fb.com>, "clm@fb.com" <clm@fb.com>,
        "dsterba@suse.com" <dsterba@suse.com>
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
Message-ID: <db3e2666-e24b-7ea4-7dad-b53b97d501fc@cn.fujitsu.com>
Date: Tue, 7 Mar 2017 14:05:39 +0800
MIME-Version: 1.0
In-Reply-To: <2236FBA76BA1254E88B949DDB74E612B41C54E80@IRSMSX102.ger.corp.intel.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



At 03/06/2017 05:43 PM, Reshetova, Elena wrote:
>
>> At 03/03/2017 04:55 PM, Elena Reshetova wrote:
>>> Now when new refcount_t type and API are finally merged
>>> (see include/linux/refcount.h), the following
>>> patches convert various refcounters in the btrfs filesystem from atomic_t
>>> to refcount_t. By doing this we prevent intentional or accidental
>>> underflows or overflows that can led to use-after-free vulnerabilities.
>>>
>>> The below patches are fully independent and can be cherry-picked separately.
>>> Since we convert all kernel subsystems in the same fashion, resulting
>>> in about 300 patches, we have to group them for sending at least in some
>>> fashion to be manageable. Please excuse the long cc list.
>>>
>>> These patches have been tested with xfstests by running btrfs-related tests.
>>> btrfs debug was enabled, warns on refcount errors, too. No output related to
>>> refcount errors produced. However, the following errors were during the run:
>>>  * tests btrfs/078, btrfs/114, btrfs/115, no errors anywhere in dmesg, but
>>>  process hangs. They all seem to be around qgroup, sometimes error visible
>>>  such as qgroup scan failed -4 before it blocks, but not always.
>>
>> How reproducible of the hang?
>
> Always in  my environment, but I would not much go into investigating why it happens, if it works for you.
> My test environment is far from ideal: I am testing in VM with rather old userspace and couple of additional changes in,
> so there are many things that can potentially go wrong. Anyway the strace for 078 is in the attachment.

Thanks for the strace.

However no "-f" is passed to strace, so it doesn't contain much useful info.

>
> If the patches pass all tests on your side, could you please take them in and propagate further?
> I will continue with other kernel subsystems.

The patchset itself looks like a common cleanup, while I did encounter 
several cases (almost all scrub tests) causing kernel warning due to 
underflow.

So I'm afraid the patchset will not be merged until we fix all the 
underflows.

But thanks for the patchset, it helps us to expose a lot of problem.

Thanks,
Qu

>
> Best Regards,
> Elena.
>
>
>>
>> I also see the -EINTR output, but that seems to be designed for
>> btrfs/11[45].
>>
>> btrfs/078 is unrelated to qgroup, and all these three test pass in my
>> test environment, which is v4.11-rc1 with your patches applied.
>>
>> I ran these 3 tests in a row with default and space_cache=v2 mount
>> options, and 5 times for each mount option, no hang at all.
>>
>> It would help much if more info can be provided, from blocked process
>> backtrace to test mount option to base commit.
>>
>> Thanks,
>> Qu
>>
>>>  * test btrfs/104 dmesg has additional error output:
>>>  BTRFS warning (device vdc): qgroup 258 reserved space underflow, have: 0,
>>>  to free: 4096
>>>  I tried looking at the code on what causes the failure, but could not figure
>>>  it out. It doesn't seem to be related to any refcount changes at least IMO.
>>>
>>> The above test failures are hard for me to understand and interpreted, but
>>> they don't seem to relate to refcount conversions.
>>>
>>> Elena Reshetova (17):
>>>   fs, btrfs: convert btrfs_bio.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert btrfs_transaction.use_count from atomic_t to
>>>     refcount_t
>>>   fs, btrfs: convert extent_map.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert btrfs_ordered_extent.refs from atomic_t to
>>>     refcount_t
>>>   fs, btrfs: convert btrfs_caching_control.count from atomic_t to
>>>     refcount_t
>>>   fs, btrfs: convert btrfs_delayed_ref_node.refs from atomic_t to
>>>     refcount_t
>>>   fs, btrfs: convert btrfs_delayed_node.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert btrfs_delayed_item.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert btrfs_root.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert extent_state.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert compressed_bio.pending_bios from atomic_t to
>>>     refcount_t
>>>   fs, btrfs: convert scrub_recover.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert scrub_page.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert scrub_block.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert scrub_parity.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert scrub_ctx.refs from atomic_t to refcount_t
>>>   fs, btrfs: convert btrfs_raid_bio.refs from atomic_t to refcount_t
>>>
>>>  fs/btrfs/backref.c           |  2 +-
>>>  fs/btrfs/compression.c       | 18 ++++++++---------
>>>  fs/btrfs/ctree.h             |  5 +++--
>>>  fs/btrfs/delayed-inode.c     | 46 ++++++++++++++++++++++----------------------
>>>  fs/btrfs/delayed-inode.h     |  5 +++--
>>>  fs/btrfs/delayed-ref.c       |  8 ++++----
>>>  fs/btrfs/delayed-ref.h       |  8 +++++---
>>>  fs/btrfs/disk-io.c           |  6 +++---
>>>  fs/btrfs/disk-io.h           |  4 ++--
>>>  fs/btrfs/extent-tree.c       | 20 +++++++++----------
>>>  fs/btrfs/extent_io.c         | 18 ++++++++---------
>>>  fs/btrfs/extent_io.h         |  3 ++-
>>>  fs/btrfs/extent_map.c        | 10 +++++-----
>>>  fs/btrfs/extent_map.h        |  3 ++-
>>>  fs/btrfs/ordered-data.c      | 20 +++++++++----------
>>>  fs/btrfs/ordered-data.h      |  2 +-
>>>  fs/btrfs/raid56.c            | 19 +++++++++---------
>>>  fs/btrfs/scrub.c             | 42 ++++++++++++++++++++--------------------
>>>  fs/btrfs/transaction.c       | 20 +++++++++----------
>>>  fs/btrfs/transaction.h       |  3 ++-
>>>  fs/btrfs/tree-log.c          |  2 +-
>>>  fs/btrfs/volumes.c           | 10 +++++-----
>>>  fs/btrfs/volumes.h           |  2 +-
>>>  include/trace/events/btrfs.h |  4 ++--
>>>  24 files changed, 143 insertions(+), 137 deletions(-)
>>>
>>
>
>
>


