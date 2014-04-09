Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:50674 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932461AbaDIPpx (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 9 Apr 2014 11:45:53 -0400
Message-ID: <53456B45.8050906@fb.com>
Date: Wed, 9 Apr 2014 11:46:13 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Upgrade to 3.14.0 messed up raid0 array (btrfs cleaner crashes
 in fs/btrfs/extent-tree.c:5748 and fs/btrfs/free-space-cache.c:1183 )
References: <20140408153609.GE23524@merlins.org> <20140408220903.GV9923@merlins.org> <53448AFA.4080601@fb.com> <20140409043125.GI10789@merlins.org> <20140409053139.GJ10789@merlins.org> <20140409154259.GM10789@merlins.org>
In-Reply-To: <20140409154259.GM10789@merlins.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/09/2014 11:42 AM, Marc MERLIN wrote:
> On Tue, Apr 08, 2014 at 10:31:39PM -0700, Marc MERLIN wrote:
>> On Tue, Apr 08, 2014 at 09:31:25PM -0700, Marc MERLIN wrote:
>>> On Tue, Apr 08, 2014 at 07:49:14PM -0400, Chris Mason wrote:
>>>>
>>>>
>>>> On 04/08/2014 06:09 PM, Marc MERLIN wrote:
>>>>> I forgot to add that while I'm not sure if anyone ended up looking at the
>>>>> last image I made regarding
>>>>> https://urldefense.proofpoint.com/v1/url?u=https://bugzilla.kernel.org/show_bug.cgi?id%3D72801&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=6%2FL0lzzDhu0Y1hL9xm%2BQyA%3D%3D%0A&m=dQHW2ddzMXNlRthusH4o6nZVMltGycqZ8zO5AgwPphE%3D%0A&s=783fd1cd39566becdfb62904889cd7459c81dd2793d19538b2ab093bb8d06f88
>>>>>
>>>>> I can generate a an image of that filesystem if that helps, or try other
>>>>> commands which hopefully won't crash my running server :)
>>>>> (filesystem is almost 2TB, so the image will again be big)
>>>>>
>>>>
>>>> Hi Marc,
>>>>
>>>> So from the messages it looks like your space cache is corrupted.  Lets
>>>> start with clearing the space cache and running fsck and seeing exactly
>>>> what is wrong.
>>>
>>> gargamel:~# mount  -o clear_cache /dev/dm-4 /mnt/mnt
>>> [48132.661274] BTRFS: device label btrfs_raid0 devid 1 transid 50567 /dev/mapper/raid0d1
>>> [48132.703063] BTRFS info (device dm-5): force clearing of disk cache
>>> [48132.724780] BTRFS info (device dm-5): disk space caching is enabled
>
> So, I tried again this morning, mounted with clear_cache, let the clearer
> process work a bit:
> root     25187  0.0  0.0      0     0 ?        S    07:56   0:00 [btrfs-freespace]
> but even though I did not have the FS mounted, after just one minute, the
> kernel went into that death loop again.
>
> Then (2nd log below), I tried mounting with -o clear_cache,nospace_cache and
> had the same problem too.
>
> I'll wait on your next suggestion, with maybe how you'd like me to run btrfsck

Downloading the image now.  I'd just run a readonly btrfsck /dev/xxx

-chris
