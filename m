Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:61495 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751905AbbDJAf6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Apr 2015 20:35:58 -0400
Message-ID: <55271A01.3010801@cn.fujitsu.com>
Date: Fri, 10 Apr 2015 08:32:01 +0800
From: Dongsheng Yang <yangds.fnst@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Justin Maggard <jmaggard10@gmail.com>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>, <russell@coker.com.au>,
        BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: snapshot space use
References: <201504091039.33442.russell@coker.com.au> <5525CBA1.5000408@cn.fujitsu.com> <CAKgsxVQ8=Y43DbJ+cNJSt6sb9uPKSfNx+HxErnVMvA6grBCVyg@mail.gmail.com> <20150409222421.GW13864@carfax.org.uk> <CAKgsxVRQ82aGuVUCFMs+Sn7khuXAZfz-Zm_K4SUHPkiR9u+tZA@mail.gmail.com> <20150409233935.GY13864@carfax.org.uk>
In-Reply-To: <20150409233935.GY13864@carfax.org.uk>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/10/2015 07:39 AM, Hugo Mills wrote:
> On Thu, Apr 09, 2015 at 04:27:08PM -0700, Justin Maggard wrote:
>> On Thu, Apr 9, 2015 at 3:24 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
>>> On Thu, Apr 09, 2015 at 03:01:55PM -0700, Justin Maggard wrote:
>>>> On Wed, Apr 8, 2015 at 5:45 PM, Qu Wenruo <quwenruo@cn.fujitsu.com> wrote:
>>>>> Hi,
>>>>>
>>>>> You can use btrfs quota feature to do it.
>>>>> Like this:
>>>>>
>>>>> # btrfs quota enable <MNT_POINT>
>>>>> # btrfs quota rescan -w <MNT_POINT>
>>>>> # btrfs qgroup show -prce <MNT_POINT>
>>>>> qgroupid rfer    excl    max_rfer max_excl parent  child
>>>>> -------- ----    ----    -------- -------- ------  -----
>>>>> 0/5      2248704 12288   0        0        ---     ---
>>>>> 0/256    5509120 3272704 0        0        ---     ---
>>>>>
>>>>>
>>>>> rfer is all the space the subvolume takes.
>>>>> excl is the exclusive space the subvolume takes.
>>>>>
>>>> Yes, but this isn't as useful as it sounds if you have more than one
>>>> snapshot.  Because if a file is included in at least two snapshots,
>>>> it's no longer exclusive.  So AFAICT even with btrfs qgroups, you
>>>> still cannot answer the question "How much space are my snapshots
>>>> using?" for a given subvolume, unless you have only one snapshot.  But
>>>> I'd be happy to be informed otherwise. :-)
>>>     There are basically two useful answers to that question, depending
>>> on how the question is specified, exactly:
>>>
>>> 1) How much space would I use if I copied this subvolume to a
>>>     different filesystem?
>>>
>>> 2) How much space would I free up if I deleted this subvolume?
>>>
>>>     Part 1 is the rfer answer. Part 2 is the excl answer.
>>>
>>>     Which of these do you mean by "How much space are my snapshots
>>> using?". The question as posed is highly ambiguous, and needs
>>> considerably more precision before it can be answered.
>>>
>>>     If you can pose the question more precisely, you might wish to ask
>>> one of those questions about N subvolumes as a group -- this is
>>> where(*) you would define a qgroup covering the subvols you're
>>> interested in, and then use the above interface to ask the question
>>> for the group of subvols as a whole.
>> To be more precise, let's consider an example, where we have a
>> subvolume named "stuff"; and two snapshots of "stuff", "snap1" and
>> "snap2".  So the question I'm posing is:
>>
>> How much space would I free up if I were to remove my snapshots,
>> "snap1" and "snap2", but keep "stuff" intact?
>>
>> I can't use the rfer value from snap1 and snap2, because in general
>> most of that space is shared by "stuff" and would not be freed.  I
>> could look at the excl column for snap1 and snap2 and add them up; but
>> if they shared extents with each other (and not with "stuff"), those
>> extents are no longer exclusive, and thus not accounted for.  So I
>> would have to delete either snap1 or snap2 in order to answer my
>> question using qgroups.
>>
>> I can't think of a way to define a qgroup that would be able to answer
>> my question, although I'm admittedly no expert in qgroups either.
>     I think you'd define a qgroup comtaining snap1 and snap2, and look
> at the excl value.

Agreed, This is a possible method to get what you want. We can create a 
qgroup
in a higher level, as a pool.
# btrfs qgroup create 1/0 /MNT

And then assign your snapshots into this qgroup.
# btrfs qgroup assign 0/xxx 1/0 /MNT
# btrfs qgroup assign 0/xxx 1/0 /MNT

*Considering we can not update the quota number automatically in moving 
qgroup
we need a rescan here.
# btrfs quota rescan -w /MNT

Then you can get the information you want by
#btrfs qgroup show -prce /MNT

Thanx
Yang
> Anyone out there with qgroups experience who can
> tell us how/whether that would do the job?
>
>     Hugo.
>
>> -Justin
>>
>>>     Hugo.
>>>
>>> (*) I'm not an expert in qgroups. I may have the idea completely
>>> wrong, but I think this is the right kind of approach.
>>>
>>>
>>>> -Justin
>>>>
>>>>> You can also refer to 'btrfs-quota'(8) and 'btrfs-qgroup'(8),
>>>>> Also the following wiki can help:
>>>>> https://btrfs.wiki.kernel.org/index.php/Quota_support
>>>>>
>>>>> NOTE: quota is not so stable and has some problem, but should give
>>>>> you enough info.
>>>>>
>>>>> Thanks,
>>>>> Qu
>>>>>
>>>>>> # zfs list -t snapshot
>>>>>> NAME                        USED  AVAIL  REFER  MOUNTPOINT
>>>>>> hetz0/be0-mail@2015-03-10  2.88G      -   387G  -
>>>>>> hetz0/be0-mail@2015-03-11  1.12G      -   388G  -
>>>>>> hetz0/be0-mail@2015-03-12  1.11G      -   388G  -
>>>>>> hetz0/be0-mail@2015-03-13  1.19G      -   388G  -
>>>>>> hetz0/be0-mail@2015-03-14  1.02G      -   388G  -
>>>>>> hetz0/be0-mail@2015-03-15   989M      -   386G  -
>>>>>>
>>>>>> Is there any way to do something similar to the above ZFS command?  It's
>>>>>> handy
>>>>>> to know which snapshots are taking up the most space, especially when
>>>>>> multiple
>>>>>> subvols are being snapshotted.
>>>>>>

