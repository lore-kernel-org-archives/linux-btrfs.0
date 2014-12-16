Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:46604 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750745AbaLPBAx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 15 Dec 2014 20:00:53 -0500
Message-ID: <548F8442.2000707@cn.fujitsu.com>
Date: Tue, 16 Dec 2014 09:00:50 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
 script fsck test case.
References: <1418615699-18169-1-git-send-email-quwenruo@cn.fujitsu.com>	<CAL3q7H4S6UDMwZb5oX0c=cpa4=ryDdJLwRE7me5aBBVY9ercvg@mail.gmail.com>	<548EAC72.9030006@cn.fujitsu.com> <CAL3q7H7sNTY8b2mzyxe-vOu=viNY=z=fxAFgMu+o_5+O2CJ0QQ@mail.gmail.com>
In-Reply-To: <CAL3q7H7sNTY8b2mzyxe-vOu=viNY=z=fxAFgMu+o_5+O2CJ0QQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + 
corrupt script fsck test case.
From: Filipe David Manana <fdmanana@gmail.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年12月15日 17:43
> On Mon, Dec 15, 2014 at 9:40 AM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH 1/2] btrfs-progs: Add support for btrfs-image + corrupt
>> script fsck test case.
>> From: Filipe David Manana <fdmanana@gmail.com>
>> To: Qu Wenruo <quwenruo@cn.fujitsu.com>
>> Date: 2014年12月15日 17:00
>>> On Mon, Dec 15, 2014 at 3:54 AM, Qu Wenruo <quwenruo@cn.fujitsu.com>
>>> wrote:
>>>> Although btrfsck test case support pure image dump(tar.xz), it is still
>>>> too large for some images, e.g, a small 64M image with about 3 levels
>>>> (level 0~2) metadata will produce about 2.6M after xz zip, which is too
>>>> large for a single binary commit.
>>>>
>>>> However btrfs-image -c9 will works much finer, the above image with
>>>> btrfs-image dump will only be less than 200K, which is quite reasonable.
>>>>
>>>> Signed-off-by: Qu Wenruo <quwenruo@cn.fujitsu.com>
>>>> ---
>>>>    tests/fsck-tests.sh | 34 ++++++++++++++++++++++++++++++++--
>>>>    1 file changed, 32 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/tests/fsck-tests.sh b/tests/fsck-tests.sh
>>>> index 8987d04..007e5b0 100644
>>>> --- a/tests/fsck-tests.sh
>>>> +++ b/tests/fsck-tests.sh
>>>> @@ -22,16 +22,38 @@ run_check()
>>>>           "$@" >> $RESULT 2>&1 || _fail "failed: $@"
>>>>    }
>>>>
>>>> +# For complicated fsck repair case,
>>>> +# where even repairing is OK, it may still report problem before or
>>>> after
>>>> +# reparing since the repair needs several loops to repair all the
>>>> problems
>>>> +# but report checks it before all repair loops done
>>>> +run_check_no_fail()
>>>> +{
>>>> +       echo "############### $@" >> $RESULT 2>&1
>>>> +       "$@" >> $RESULT 2>&1
>>>> +}
>>> I'm confused with this function, why it's needed and the respective
>>> comment.
>>> So I can interpret it as either:
>>>
>>> 1) The several loops means fsck --repair does multiple passages
>>> internally to fix some issues?
>>>    If this is the case, we (user or script) only need to call fsck
>>> --repair once, which should exit with status 0 if it was able to fix
>>> all the issues, right? If so, then we should check that fsck --repair
>>> exits with status 0, removing the need for this new function.
>> Sorry for the poor explain.
>>
>> The problem is, there is some check cases before we doing repair and these
>> check result is bad so
>> btrfsck thinks there is err even it will be repaired later.
>>
>> So The result is, especially on corrupted-leaf case, btrfsck --repair will
>> fix all the problems but
>> still return 1, and the next btrfsck without --repair will return 0.
> That seems wrong to me. If --repair was able to fix all problems it
> should exit with status 0.
> If a script is running fsck --repair it would incorrectly assume
> --repair failed.
That's right, I'll look into it and try to fix the return value things 
before I send the v2 test case.

Thanks,
Qu
