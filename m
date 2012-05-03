From: "Jim Schutt" <jaschut@sandia.gov>
Subject: Re: [EXTERNAL] Re: kernel BUG at fs/btrfs/extent_io.c:3982!
Date: Thu, 3 May 2012 09:46:15 -0600
Message-ID: <4FA2A847.8030007@sandia.gov>
References: <4F848C62.6030100@sandia.gov>
 <20120411190926.GE2506@localhost.localdomain>
 <4F85E87E.90804@sandia.gov>
 <20120501160047.GA2050@localhost.localdomain>
 <4FA01239.7080907@sandia.gov> <4FA29994.6030009@sandia.gov>
 <20120503145317.GE1914@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Cc: linux-btrfs@vger.kernel.org
To: "Josef Bacik" <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20120503145317.GE1914@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

On 05/03/2012 08:53 AM, Josef Bacik wrote:
> On Thu, May 03, 2012 at 08:43:32AM -0600, Jim Schutt wrote:
>> On 05/01/2012 10:41 AM, Jim Schutt wrote:
>>> On 05/01/2012 10:00 AM, Josef Bacik wrote:
>>>> On Wed, Apr 11, 2012 at 02:24:30PM -0600, Jim Schutt wrote:
>>>>> On 04/11/2012 01:09 PM, Josef Bacik wrote:
>>>>>> On Tue, Apr 10, 2012 at 01:39:14PM -0600, Jim Schutt wrote:
>>>>>>> Hi,
>>>>>>>
>>>>>>> I hit this BUG today.
>>>>>>>
>>>>>>> I'm running 3.3.1 merged with the ceph and btrfs bits for 3.4,
>>>>>>> i.e. 3.3.1 +
>>>>>>> commit bc3f116fec194 "Btrfs: update the checks for mixed block =
groups with big metadata blocks"
>>>>>>> commit c666601a935b9 "rbd: move snap_rwsem to the device, renam=
e to header_rwsem"
>>>>>>>
>>>>>>> The btrfs filesystem in question is backing a Ceph OSD under
>>>>>>> a heavy write load.
>>>>>>>
>>>>>>> Here's the bug:
>>>>>>>
>>>>>>
>>>>>> Can you give this a whirl and let me know how it goes? If I'm ri=
ght you should
>>>>>> see a warning pop up in your messages. Thanks,
>>>>>
>>>>> OK, I've got my test running with your patch applied
>>>>> to my previous kernel.
>>>>>
>>>>> Do you expect your warning to only fire when my
>>>>> previous kernel would have BUGged? I ask because I've
>>>>> only seen the BUG once, so it may be a low-probability
>>>>> occurrence.
>>>>>
>>>>> It seems like I should keep testing until I see either
>>>>> your new warning or the BUG, right?
>>>>
>>>> Hey Jim,
>>>>
>>>> I just sent a patch to the list
>>>>
>>>> [PATCH] Btrfs: fix page leak when allocing extent buffers
>>>>
>>>> Could you try that and see if you can reproduce your problem?
>>>
>>> Taking it for a spin now...
>>>
>>
>> Hit it again:
>>
>
> Argh ok it's time to stop hopping around the problem and see what exa=
ctly the
> state is when this happens so I know where to look.  Can you run with=
 this patch
> and give me the dmesg?  The important information will be above the -=
-- cut here
>   --- line so make sure to grab that part.  Thanks,

Working on it...

BTW, when I recompiled, I noticed this warning:

   CC [M]  fs/btrfs/extent_io.o
fs/btrfs/extent_io.c: In function =E2=80=98write_one_eb=E2=80=99:
fs/btrfs/extent_io.c:3195: warning: =E2=80=98ret=E2=80=99 may be used u=
ninitialized in this function

Is there ever any chance at all that write_one_eb() can be
called by mistake for an eb with zero pages?  If so, could
that be part of the problem?

-- Jim

>
> Josef
>

--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
