Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:30314 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965613AbbDWMwa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Apr 2015 08:52:30 -0400
Message-ID: <5538EB05.7050200@fb.com>
Date: Thu, 23 Apr 2015 08:52:21 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <fdmanana@gmail.com>
CC: =?UTF-8?B?SG9sZ2VyIEhvZmZzdMOkdHRl?=
	<holger.hoffstaette@googlemail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/4] btrfs: reduce block group cache writeout times during
 commit
References: <1428954759-1304912-1-git-send-email-clm@fb.com>	<mh8h3f$l3u$1@ger.gmane.org>	<pan.2015.04.22.16.37.38@googlemail.com>	<5537D27E.3080609@fb.com> <CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
In-Reply-To: <CAL3q7H4ccdcJYKZaH_fYW9EUPCSTa3gDz_fiUjP8TvCUvQtxTQ@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/23/2015 08:45 AM, Filipe David Manana wrote:
> On Wed, Apr 22, 2015 at 5:55 PM, Chris Mason <clm@fb.com> wrote:
>> On 04/22/2015 12:37 PM, Holger Hoffstätte wrote:
>>> On Wed, 22 Apr 2015 18:09:18 +0200, Lutz Vieweg wrote:
>>>
>>>> On 04/13/2015 09:52 PM, Chris Mason wrote:
>>>>> Large filesystems with lots of block groups can suffer long stalls during
>>>>> commit while we create and send down all of the block group caches.  The
>>>>> more blocks groups dirtied in a transaction, the longer these stalls can be.
>>>>> Some workloads average 10 seconds per commit, but see peak times much higher.
>>>>
>>>> Since we see this problem very frequently on some shared development servers,
>>>> I will try to install this ASAP.
>>>>
>>>> Meanwhile, can anybody already tell success stories about successfully removing
>>>> lags by this patch?
>>>
>>> Works fine, but make sure to get the followup patch [1] as well while you're
>>> at it. I've observed that my (bandwidth-throttled) backups now cause shorter,
>>> nicely spaced-out blips of activity instead of longer ones when the writeback
>>> kicks in.
>>>
>>> -h
>>>
>>> [1] https://git.kernel.org/cgit/linux/kernel/git/mason/linux-btrfs.git/commit/?h=integration-4.1&id=c1e31ffc317e4c28d242b1d961c9c6fe673c0377
>>>
>>
>> Great to hear.  I recommend just using my for-linus-4.1 branch, since it
>> has all the good things  in one place.
> 
> Trying the current integration-4.1 branch, I ran into the following
> during xfstests/btrfs/049:
> 

Ugh, I must not be waiting correctly in one of the inode cache writeout
sections.  But I've run 049 a whole bunch of times without triggering,
can you get this to happen consistently?

-chris

