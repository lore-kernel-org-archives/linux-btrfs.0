Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:58921 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754018AbbCMB66 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Mar 2015 21:58:58 -0400
Message-ID: <55024460.3040706@cn.fujitsu.com>
Date: Fri, 13 Mar 2015 09:58:56 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        <fstests@vger.kernel.org>
Subject: Re: [PATCH] fstest: btrfs/083: Test for incorrect exclusive refernce
 number after file clone.
References: <1425973594-31936-1-git-send-email-quwenruo@cn.fujitsu.com> <CAL3q7H54-k-MEZnNzZn8Pyc6YH3okp+LUrncbMR=Kq6q5_xd7w@mail.gmail.com> <55018B3C.6070104@fb.com> <5502374C.8050607@cn.fujitsu.com>
In-Reply-To: <5502374C.8050607@cn.fujitsu.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



-------- Original Message  --------
Subject: Re: [PATCH] fstest: btrfs/083: Test for incorrect exclusive 
refernce number after file clone.
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
To: Josef Bacik <jbacik@fb.com>, fdmanana@gmail.com
Date: 2015年03月13日 09:03

>
>
> -------- Original Message  --------
> Subject: Re: [PATCH] fstest: btrfs/083: Test for incorrect exclusive
> refernce number after file clone.
> From: Josef Bacik <jbacik@fb.com>
> To: <fdmanana@gmail.com>, Qu Wenruo <quwenruo@cn.fujitsu.com>
> Date: 2015年03月12日 20:49
>
>> On 03/12/2015 08:38 AM, Filipe David Manana wrote:
>>> On Tue, Mar 10, 2015 at 7:46 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>> [Problem]
>>>> Since commit fcebe4562dec83b3f8d308 ("Btrfs: rework qgroup
>>>> accounting"),
>>>> quota data update is delayed after delayed_ref calculation, and lacks
>>>> correct protection to detect root reference which shouldn't be counted
>>>> in current sequence number but already written into extent backref.
>>>>
>>>> This makes exclusive reference not decreased correctly and give
>>>> incorrect
>>>> result.
>>>>
>>>> [Test procedure]
>>>> 1. Create a btrfs with 3 subvolumes, quota enabled and rescanned.
>>>> 2. Create a file in 1st subvolume
>>>> 3. Clone the file to 2nd and 3rd subvolume
>>>> 4. Sync the fs to reflect the changes in qgroup.
>>>> 5. Check the qgroup data
>>>>
>>>> [Expected result]
>>>> None of the subvolume has exclusive reference to the file.
>>>>
>>>> [Actual result]
>>>> The first subvolume still have exclusive reference to the file.
[snip]
> Thanks,
>>
>> Josef
BTW, I'm somewhat worried about how to fix the problem.

Two method comes to me, but neither seems perfect.
1) Change qgroup counters update timing.
Just change the actual qgroup update timing from current 
btrfs_delayed_qgroup_accouting() to btrfs_qgroup_record_ref().

Although it seems we can get accurate old/new_roots, but delayed tree 
block refs can be ordered/merged, causing data ref is run before its 
tree block, causing btrfs_find_all_roots() always return 0 root.

So this method needs extra modification on delayed refs.

2) Do "oper-replay" in qgroup codes.
We can do things like log replay in qgroup operations, and do some black 
magic to calculate the correct old/new_roots number even we can only see 
the final result backrefs.

But I didn't see a good algorithm to do this, and the complexity may 
cause even more bugs.

Any ideas?

Thanks,
Qu
