Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.cn.fujitsu.com ([183.91.158.132]:45190 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S934907AbdLSCPQ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Dec 2017 21:15:16 -0500
Subject: Re: btrfs check lowmem crash, backref.c:466: __add_missing_keys:
 Assertion `ref->root_id` failed
To: Chris Murphy <lists@colorremedies.com>, Qu Wenruo <quwenruo.btrfs@gmx.com>
CC: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtScin-9AomqOwiSTwj=5rCeJW12jv8rv8taxwUq+AX5Lw@mail.gmail.com>
 <b580f4c4-3eb0-9203-75b5-c918f15d12cf@cn.fujitsu.com>
 <CAJCQCtRuaWb2_EHiiKzk7iWhMoLno6F-O+J42hqsgYif5AEVew@mail.gmail.com>
From: Su Yue <suy.fnst@cn.fujitsu.com>
Message-ID: <a076c7ff-87e3-b18c-c046-ff4912e277c4@cn.fujitsu.com>
Date: Tue, 19 Dec 2017 10:19:17 +0800
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRuaWb2_EHiiKzk7iWhMoLno6F-O+J42hqsgYif5AEVew@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/19/2017 09:34 AM, Chris Murphy wrote:
> On Sun, Dec 17, 2017 at 8:07 PM, Su Yue <suy.fnst@cn.fujitsu.com>
> wrote:
>> Hi,
>> 
>> On 12/18/2017 10:50 AM, Chris Murphy wrote:
>>> 
>>> This is v4.14.
>>> 
>>> I've filed a bug which contains the build steps, versions. It's 
>>> crashing on all volumes I try it on so far.
>>> 
>>> 
>> 
>> It was fixed by Qu's patch btrfs-progs: backref: Allow backref walk
>> to handle direct parent ref which is available on his github 
>> https://github.com/adam900710/btrfs-progs/tree/lowmem_fix
>> 
> OK that fixed the crashing problem on all tested volumes. One volume 
> so far has a bunch of these:
> 
> ERROR: data extent[1218774720512 167936] backref lost
> 

Did you apply all patches on this branch?
If only the patch mentioned above is applied, you can try another
patch named
  btrfs-progs: lowmem check: Fix false backref lost warning for keyed
     extent data ref
which exists in same branch.

Otherwise, it seems a bug of lowmem check. Would you please
provide some dump of btrfs-debug-tree?

# btrfs-debug-tree /$device  |\
   grep -C10 1218774720512

You can erase filenames if you think they are private.

> With the same numbers for each line. Is that fixed in kdave devel 
> branch? Or pending? All commits in this brach are pending.

Thanks,
Su


