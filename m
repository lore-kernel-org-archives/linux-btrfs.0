Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41846 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756335AbaAFVrF (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Jan 2014 16:47:05 -0500
Message-ID: <52CB2452.70507@redhat.com>
Date: Mon, 06 Jan 2014 15:46:58 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org, xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: kill lib/random.c
References: <1389038323-8304-1-git-send-email-jbacik@fb.com> <52CB20ED.1010705@redhat.com> <52CB2336.2060009@fb.com>
In-Reply-To: <52CB2336.2060009@fb.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 1/6/14, 3:42 PM, Josef Bacik wrote:
> 
> On 01/06/2014 04:32 PM, Eric Sandeen wrote:
>> On 1/6/14, 1:58 PM, Josef Bacik wrote:
>>> I was trying to reproduce something with fsx and I noticed that no matter what
>>> seed I set I was getting the same file.  Come to find out we are overloading
>>> random() with our own custom horribleness for some unknown reason.  So nuke the
>>> damn thing from orbit and rely on glibc's random().  With this fix the -S option
>>> actually does something with fsx.  Thanks,
>> Hm, old comments seem to indicate that this was done <handwave> to make random
>> behave the same on different architectures (i.e. same result from same seed,
>> I guess?)  I . . . don't know if that is true of glibc's random(), is it?
>>
>> I'd like to dig into the history just a bit before we yank this, just to
>> be sure.
> 
> I think that if we need the output to match based on a predictable
> random() output then we've lost already. We shouldn't be checking for
> specific output (like inode numbers or sizes etc) that are dependant
> on random()'s behaviour, and if we are we need to fix those tests. So
> even if that is why it was put in place originally I'd say it is high
> time we ripped it out and fixed up any tests that rely on this
> behaviour. Thanks,

Yeah, you're probably right.  And the ancient xfstests history seems to
be lost in the mists of time, at least as far as I can see.  So I'm ok
with this but let's let Dave & SGI chime in too just to be certain.

Thanks,
-Eric

> Josef

