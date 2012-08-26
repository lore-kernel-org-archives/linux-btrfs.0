Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:25383 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2HZM0Q (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 26 Aug 2012 08:26:16 -0400
Message-ID: <503A15DC.3000902@oracle.com>
Date: Sun, 26 Aug 2012 20:26:04 +0800
From: Jie Liu <jeff.liu@oracle.com>
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: Alex Lyakas <alex.bolshoy.btrfs@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] btrfs-progs: snapshot diff function
References: <5020D84E.4010900@oracle.com> <CAHf9xvbMRyzXbhDtUUcqimA6+RCNCnvE=TtsU5k4PAGcnz3akQ@mail.gmail.com> <50378C73.7040901@oracle.com> <CAB9VWqCHdh_-TSPovszJVCz4R2s8B6zOjA5mJ87Q=xKB+sKZPQ@mail.gmail.com>
In-Reply-To: <CAB9VWqCHdh_-TSPovszJVCz4R2s8B6zOjA5mJ87Q=xKB+sKZPQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 08/25/12 14:23, Alexander Block wrote:
> On Fri, Aug 24, 2012 at 4:15 PM, Jeff Liu <jeff.liu@oracle.com> wrote:
>> Hi Alex,
>>
>> Thanks for taking a look.
>>
>> On 08/24/2012 09:09 PM, Alex Lyakas wrote:
>>
>>> Hi Jeff,
>>> how do you see this snapshot-diff functionality vs the send/receive
>>> functionality that was recently added? I think that the binary stream
>>> that the send code produces, can be interpreted by printing out text
>>> messages, which will essentially give the same information (although
>>> much more detailed) as your snapshot-diff tool.
>> send/receive has not yet implemented when I working on this feature(back to the end of last year).
>> looks there really has some duplicate efforts.
>>
>> Just as you said, the produced stream of send need to interpret to show readable info, if the binary stream is
>> became huge enough, maybe that will make some silly user crying like me :).
>> Also, it is mainly focus on backup purpose IMHO, please correct me if I missing something in this point.
>>
>> The diff utility is designed to list any changes between two snapshots in a straightforward way consider the command interface,
>> it also can be improved to show the differences at a given time range.
>>
>> But sure, send/receive is just awesome, if we can introduce a interpreted script which do same thing to
>> make end user's life easier, that would be fine.
>>
>> Thanks,
>> -Jeff
>>
>>> Apologies if I somehow misunderstood what your snapshot-diff code does.
>>>
>>> Thanks,
>>> Alex.
>>>
>>>
>>> On Tue, Aug 7, 2012 at 11:56 AM, Jeff Liu <jeff.liu@oracle.com> wrote:
>>>> Hello,
>>>>
>>>> I've done a prototype implementation of snapshot diff utility many months ago.
>>>> It was originally meant to analyze the differences between two snapshots which are
>>>> inherited from the same subvolume/snapshot.

>>>> My idea was to introduce new "instructions" to the stream later which
>>>> could be activated using a flag in the ioctl structure. These
>>>> instructions would not be real instruction but diff statements. They
>>>> would contain the plain results as given by btrfs_compare_trees. So we
>>>> would have the information which tree items were
>>>> added/removed/changed. As an alternative, this could be a new ioctl.
Sound interesting.
The performance of interpret huge streams from the user land could
resolved in this way, am looking forward to see that become true so. :)

Thanks,
-Jeff
>
> Greetings from Ko Tao :)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

