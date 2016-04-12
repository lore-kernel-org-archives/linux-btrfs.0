Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57974 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S966244AbcDLRzm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Apr 2016 13:55:42 -0400
Subject: Re: [PATCH] Btrfs: track transid for delayed ref flushing
To: <bo.li.liu@oracle.com>
References: <1460410660-17430-1-git-send-email-jbacik@fb.com>
 <20160412174312.GB3524@localhost.localdomain>
CC: <linux-btrfs@vger.kernel.org>, <kernel-team@fb.com>
From: Josef Bacik <jbacik@fb.com>
Message-ID: <570D3690.3010701@fb.com>
Date: Tue, 12 Apr 2016 13:55:28 -0400
MIME-Version: 1.0
In-Reply-To: <20160412174312.GB3524@localhost.localdomain>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/12/2016 01:43 PM, Liu Bo wrote:
> On Mon, Apr 11, 2016 at 05:37:40PM -0400, Josef Bacik wrote:
>> Using the offwakecputime bpf script I noticed most of our time was spent waiting
>> on the delayed ref throttling.  This is what is supposed to happen, but
>> sometimes the transaction can commit and then we're waiting for throttling that
>> doesn't matter anymore.  So change this stuff to be a little smarter by tracking
>> the transid we were in when we initiated the throttling.  If the transaction we
>> get is different then we can just bail out.  This resulted in a 50% speedup in
>> my fs_mark test, and reduced the amount of time spent throttling by 60 seconds
>> over the entire run (which is about 30 minutes).  Thanks,
>
> Does the bpf script show where it's waiting on?  delayed_refs spinlock?

We are waiting on the wait_for_completion() in 
btrfs_async_run_delayed_refs.  The script only catches where we're in 
TASK_UNINTERRUPTIBLE for longer than 100ms.

>
> Maybe we can make it even smarter.
>
> In __btrfs_end_transaction(), the only case it won't wait for running delayed refs
> is when trans is JOIN_NOLOCK or ATTACH and "must_run_delayed_refs = 2".
>
> In other cases, even we queue a work into helper worker to do async
> delayed refs processing, __btrfs_end_transaction() still waits there.
>
> Since it's a 50% speedup, it looks like at least 50% of __btrfs_end_transaction()
> are waiting for other trans's queued delayed refs, can we do the check
> a little bit earlier, in btrfs_async_run_delayed_refs()?

We'd have to start another transaction, we don't want to have to do 
that.  What I want to do later is have the flushing stuff running all 
the time, so we notice way sooner if we end up with a bunch of people 
all trying to throttle at once.  So we drop below the throttle watermark 
and everybody wakes up, instead of everybody does their work no matter 
what and then wakes up.  But this was quick and easy and I've got other 
stuff to do so this is what I posted ;).  Thanks,

Josef

