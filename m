Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:9577 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753722AbaAGVSE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 16:18:04 -0500
Message-ID: <52CC6F00.3060907@fb.com>
Date: Tue, 7 Jan 2014 16:17:52 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@sandeen.net>
CC: Eric Sandeen <sandeen@redhat.com>, <linux-btrfs@vger.kernel.org>,
        <xfs@oss.sgi.com>
Subject: Re: [PATCH] xfstests: kill lib/random.c
References: <1389038323-8304-1-git-send-email-jbacik@fb.com> <52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com> <52CB2452.70507@redhat.com> <20140107200135.GD1935@sgi.com> <52CC5F27.1090602@sandeen.net> <20140107204015.GJ10553@sgi.com>
In-Reply-To: <20140107204015.GJ10553@sgi.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/07/2014 03:40 PM, Ben Myers wrote:
> On Tue, Jan 07, 2014 at 02:10:15PM -0600, Eric Sandeen wrote:
>> On 1/7/14, 2:01 PM, Ben Myers wrote:
>>> Hey Gents,
>>>
>>> On Mon, Jan 06, 2014 at 03:46:58PM -0600, Eric Sandeen wrote:
>>>> On 1/6/14, 3:42 PM, Josef Bacik wrote:
>>>>> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
>>>>>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
>>>>>>> I was trying to reproduce something with fsx and I noticed that no matter what
>>>>>>> seed I set I was getting the same file.  Come to find out we are overloading
>>>>>>> random() with our own custom horribleness for some unknown reason.  So nuke the
>>>>>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
>>>>>>> actually does something with fsx.  Thanks,
>>>>>> Hm, old comments seem to indicate that this was done <handwave> to make random
>>>>>> behave the same on different architectures (i.e. same result from same seed,
>>>>>> I guess?)  I . . . don't know if that is true of glibc's random(), is it?
>>>>>>
>>>>>> I'd like to dig into the history just a bit before we yank this, just to
>>>>>> be sure.
>>>>> I think that if we need the output to match based on a predictable
>>>>> random() output then we've lost already. We shouldn't be checking for
>>>>> specific output (like inode numbers or sizes etc) that are dependant
>>>>> on random()'s behaviour, and if we are we need to fix those tests. So
>>>>> even if that is why it was put in place originally I'd say it is high
>>>>> time we ripped it out and fixed up any tests that rely on this
>>>>> behaviour. Thanks,
>>>> Yeah, you're probably right.  And the ancient xfstests history seems to
>>>> be lost in the mists of time, at least as far as I can see.  So I'm ok
>>>> with this but let's let Dave & SGI chime in too just to be certain.
>>> I did not have success locating the history prior to what we have posted on
>>> oss.  I agree that it was likely added so that tests that expose output from
>>> random into golden output files will have the same results across arches.
>>> Maybe this is still of concern for folks who use a different c library with the
>>> kernel.
>>>
>>> Looks there are quite a few callers.  IMO if we're going to remove this we
>>> should fix the tests first.
>> Or first, determine if they really need fixing.  Did you find tests which
>> actually contain the random results in the golden output?
> At one point random.c was modified because it was returning different test
> results on i386 and ia64 with test 007.  Looks like nametest.c is a good
> candidate.
>

Ugh you're right.  Just ignore this patch for now, I'll be in the corner 
banging my head against the wall.  Thanks,

Josef
