Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:59533 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752413AbaAGUKR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Jan 2014 15:10:17 -0500
Message-ID: <52CC5F27.1090602@sandeen.net>
Date: Tue, 07 Jan 2014 14:10:15 -0600
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: Ben Myers <bpm@sgi.com>, Eric Sandeen <sandeen@redhat.com>,
        Josef Bacik <jbacik@fb.com>
CC: linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: kill lib/random.c
References: <1389038323-8304-1-git-send-email-jbacik@fb.com>	<52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com>	<52CB2452.70507@redhat.com> <20140107200135.GD1935@sgi.com>
In-Reply-To: <20140107200135.GD1935@sgi.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/7/14, 2:01 PM, Ben Myers wrote:
> Hey Gents,
> 
> On Mon, Jan 06, 2014 at 03:46:58PM -0600, Eric Sandeen wrote:
>> On 1/6/14, 3:42 PM, Josef Bacik wrote:
>>>
>>> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
>>>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
>>>>> I was trying to reproduce something with fsx and I noticed that no matter what
>>>>> seed I set I was getting the same file.  Come to find out we are overloading
>>>>> random() with our own custom horribleness for some unknown reason.  So nuke the
>>>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
>>>>> actually does something with fsx.  Thanks,
>>>> Hm, old comments seem to indicate that this was done <handwave> to make random
>>>> behave the same on different architectures (i.e. same result from same seed,
>>>> I guess?)  I . . . don't know if that is true of glibc's random(), is it?
>>>>
>>>> I'd like to dig into the history just a bit before we yank this, just to
>>>> be sure.
>>>
>>> I think that if we need the output to match based on a predictable
>>> random() output then we've lost already. We shouldn't be checking for
>>> specific output (like inode numbers or sizes etc) that are dependant
>>> on random()'s behaviour, and if we are we need to fix those tests. So
>>> even if that is why it was put in place originally I'd say it is high
>>> time we ripped it out and fixed up any tests that rely on this
>>> behaviour. Thanks,
>>
>> Yeah, you're probably right.  And the ancient xfstests history seems to
>> be lost in the mists of time, at least as far as I can see.  So I'm ok
>> with this but let's let Dave & SGI chime in too just to be certain.
> 
> I did not have success locating the history prior to what we have posted on
> oss.  I agree that it was likely added so that tests that expose output from
> random into golden output files will have the same results across arches.
> Maybe this is still of concern for folks who use a different c library with the
> kernel.  
> 
> Looks there are quite a few callers.  IMO if we're going to remove this we
> should fix the tests first.

Or first, determine if they really need fixing.  Did you find tests which
actually contain the random results in the golden output?

-Eric

> -Ben
> 
> _______________________________________________
> xfs mailing list
> xfs@oss.sgi.com
> http://oss.sgi.com/mailman/listinfo/xfs
> 

