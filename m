Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48742 "EHLO
	m0041696.ppops.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752633AbbIPNuZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Sep 2015 09:50:25 -0400
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
To: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>,
        <linux-btrfs@vger.kernel.org>, Omar Sandoval <osandov@osandov.com>
References: <1442326024-2536-1-git-send-email-jbacik@fb.com>
 <55F83E34.3090900@googlemail.com> <55F86CB1.5020503@googlemail.com>
 <55F86E63.8050300@fb.com> <55F92F20.2040603@googlemail.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <55F97399.7000407@fb.com>
Date: Wed, 16 Sep 2015 09:50:17 -0400
MIME-Version: 1.0
In-Reply-To: <55F92F20.2040603@googlemail.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/16/2015 04:58 AM, Holger Hoffstätte wrote:
> On 09/15/15 21:15, Josef Bacik wrote:
>> On 09/15/2015 03:08 PM, Holger Hoffstätte wrote:
>>> On 09/15/15 17:50, Holger Hoffstätte wrote:
>>>> This V2 does indeed seem to fix the issues I reported with snapshot
>>>> deletion & concurrent sync. I've now created/filled/deleted countless
>>>> snapshots while issuing sync(s) in parallel, and the problem that I
>>>> saw fairly frequently with V1 no longer seems to occur here.
>>>
>>> Well..I may have spoken too soon:
>>
>> Huh this doesn't seem related to my stuff.  Can I have your script
>> you are running to reproduce this?  Thanks,
>>
>> Josef
>
> It seemed to be related to Omar's free-space-tree - I saw the same bug
> a bit later on a different device without snapshot deletion, just
> deleting two large files. Sorry for the false positive.
>

Omar, do you have time to look into this?  Were they highly fragmented 
files or just giant contiguous files?  Thanks,

Josef

