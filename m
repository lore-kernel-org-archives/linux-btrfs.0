Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:48715 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751795AbcGRSoC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 18 Jul 2016 14:44:02 -0400
Subject: Re: [PATCH 0/3] Btrfs: fix free space tree bitmaps+tests on
 big-endian systems
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1468538030.git.osandov@fb.com>
 <48955009.Up9FeqXyzx@localhost.localdomain>
 <20160715191515.GA13357@vader.DHCP.thefacebook.com>
 <3006396.dOAW6WHiJC@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
From: Chris Mason <clm@fb.com>
Message-ID: <399ec92c-9905-0ede-d5b0-ea3b0bf922e4@fb.com>
Date: Mon, 18 Jul 2016 14:43:26 -0400
MIME-Version: 1.0
In-Reply-To: <3006396.dOAW6WHiJC@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 07/17/2016 08:19 AM, Chandan Rajendra wrote:
> On Friday, July 15, 2016 12:15:15 PM Omar Sandoval wrote:
>> On Fri, Jul 15, 2016 at 12:34:10PM +0530, Chandan Rajendra wrote:
>>> On Thursday, July 14, 2016 07:47:04 PM Chris Mason wrote:
>>>> On 07/14/2016 07:31 PM, Omar Sandoval wrote:
>>>>> From: Omar Sandoval <osandov@fb.com>
>>>>>
>>>>> So it turns out that the free space tree bitmap handling has always been
>>>>> broken on big-endian systems. Totally my bad.
>>>>>
>>>>> Patch 1 fixes this. Technically, it's a disk format change for
>>>>> big-endian systems, but it never could have worked before, so I won't go
>>>>> through the trouble of any incompat bits. If you've somehow been using
>>>>> space_cache=v2 on a big-endian system (I doubt anyone is), you're going
>>>>> to want to mount with nospace_cache to clear it and wait for this to go
>>>>> in.
>>>>>
>>>>> Patch 2 fixes a similar error in the sanity tests (it's the same as the
>>>>> v2 I posted here [1]) and patch 3 expands the sanity tests to catch the
>>>>> oversight that patch 1 fixes.
>>>>>
>>>>> Applies to v4.7-rc7. No regressions in xfstests, and the sanity tests
>>>>> pass on x86_64 and MIPS.
>>>>
>>>> Thanks for fixing this up Omar.  Any big endian friends want to try this
>>>> out in extended testing and make sure we've nailed it down?
>>>>
>>>
>>> Hi Omar & Chris,
>>>
>>> I will run fstests with this patchset applied on ppc64 BE and inform you about
>>> the results.
>>>
>>
>> Thanks, Chandan! I set up my xfstests for space_cache=v2 by doing:
>>
>>     mkfs.btrfs "$TEST_DEV"
>>     mount -o space_cache=v2 "$TEST_DEV" "$TEST_DIR"
>>     umount "$TEST_DEV"
>>
>> and adding
>>
>>     export MOUNT_OPTIONS="-o space_cache=v2"
>>
>> to local.config. btrfsck also needs the patch here [1].
>>
>>
>
> Hi,
>
> I did execute the fstests tests suite on ppc64 BE as per above configuration
> and there were no new regressions. Also, I did execute fsx (via generic/127)
> thrice on the same filesystem instance,
> 1. With the unpatched kernel and later
> 2. With the patched kernel and again
> 3. With the unpatched kernel
> ... there were no new regressions when executing the above steps.

Thanks Chandan!  But I'm a little confused.  If the patch is helping, we 
should be storing bitmaps wrong on disk unpatched.  There should be 
problems going back and forth.

-chris
