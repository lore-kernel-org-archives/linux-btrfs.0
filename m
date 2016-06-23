Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:27139 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750874AbcFWL6f (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Jun 2016 07:58:35 -0400
Subject: Re: [PATCH v2] fstests: btrfs: fix 006 adds _runnt_btrfs_util_prog()
To: fdmanana@gmail.com
References: <1466678252-4058-1-git-send-email-anand.jain@oracle.com>
 <20160623105302.GJ3226@eguan.usersys.redhat.com>
 <24a2491d-91d7-0e45-5008-e784b7a699fd@oracle.com>
 <20160623111843.GL3226@eguan.usersys.redhat.com>
 <98fc270c-cd74-23cb-7bd6-b02ff75a7b91@oracle.com>
 <CAL3q7H7A061KGcjByrLTqMrA=fexMajjeZuzSjDUO2M7LToJXQ@mail.gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <1a521394-fe06-5142-659b-7a8bac297baf@oracle.com>
Date: Thu, 23 Jun 2016 19:59:24 +0800
MIME-Version: 1.0
In-Reply-To: <CAL3q7H7A061KGcjByrLTqMrA=fexMajjeZuzSjDUO2M7LToJXQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/23/2016 07:54 PM, Filipe Manana wrote:
> On Thu, Jun 23, 2016 at 12:34 PM, Anand Jain <anand.jain@oracle.com> wrote:
>>
>>
>> On 06/23/2016 07:18 PM, Eryu Guan wrote:
>>>
>>> On Thu, Jun 23, 2016 at 07:03:59PM +0800, Anand Jain wrote:
>>>>
>>>>
>>>>
>>>> On 06/23/2016 06:53 PM, Eryu Guan wrote:
>>>
>>> [snip]
>>>>>>
>>>>>> diff --git a/common/rc b/common/rc
>>>>>> index a44fb8750220..2a10fbb2d341 100644
>>>>>> --- a/common/rc
>>>>>> +++ b/common/rc
>>>>>> @@ -3114,6 +3114,17 @@ _min_dio_alignment()
>>>>>>      fi
>>>>>>  }
>>>>>>
>>>>>> +run_check_dontfail()
>>>>>> +{
>>>>>> +       echo "# $@" >> $seqres.full 2>&1
>>>>>> +       "$@" >> $seqres.full 2>&1 || echo "failed: '$@'"
>>>>>> +}
>>>>>> +
>>>>>> +_runnt_btrfs_util_prog()
>>>>>> +{
>>>>>> +       run_check_dontfail $BTRFS_UTIL_PROG $*
>>>>>> +}
>>>>>> +
>>>>>>  run_check()
>>>>>>  {
>>>>>>         echo "# $@" >> $seqres.full 2>&1
>>>>>> diff --git a/tests/btrfs/006 b/tests/btrfs/006
>>>>>> index 715fd80fb6fc..9d1fe09e07de 100755
>>>>>> --- a/tests/btrfs/006
>>>>>> +++ b/tests/btrfs/006
>>>>>> @@ -79,7 +79,7 @@ echo "== Show filesystem by UUID"
>>>>>>  $BTRFS_UTIL_PROG filesystem show $UUID | _filter_btrfs_filesystem_show
>>>>>> $TOTAL_DEVS $UUID
>>>>>>
>>>>>>  echo "== Sync filesystem"
>>>>>> -$BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT | _filter_scratch
>>>>>> +_runnt_btrfs_util_prog filesystem sync $SCRATCH_MNT
>>>>>
>>>>>
>>>>> Still, I don't think this helper is necessary.
>>>>>
>>>>> $BTRFS_UTIL_PROG filesystem sync $SCRATCH_MNT >/dev/null
>>>>>
>>>>> doesn't _fail on failure, output error messages breaks golden image, and
>>>>> is much simpler. Do I miss anything?
>>>>
>>>>
>>>>  runnt_btrfs_util_prog() checks the return status of the command,
>>>>  if failed (!0) it will echo so to break the golden image.
>>>
>>>
>>> So it fails silently now? (return non-zero value and print no error
>>> message) That seems a btrfs-progs bug to me.. It should print error
>>> messages to stderr on failure, so we don't have to check the return
>>> value explicitly.
>>
>>
>>  For programming interfaces I would rather depend more on the return
>>  value, than the UI/error strings.
>
> That's precisely why both error messages to stderr *and* return values are used.
> For scripts you always have the option to ignore stderr through
> redirection to /dev/null and check only the return value.
>
> Also _runnt_btrfs_util_prog filesystem is, in my opinion, a terrible
> name. What does "runnt" means?

  run (but) not terminate.

Thanks, Anand

>>
>> Thanks, Anand
>>
>>
>>> Thanks,
>>> Eryu
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
