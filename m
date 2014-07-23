Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57307 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752798AbaGWNZ4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jul 2014 09:25:56 -0400
Message-ID: <53CFB7D6.1040203@fb.com>
Date: Wed, 23 Jul 2014 09:25:42 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Mark Fasheh <mfasheh@suse.de>,
        Zach Brown <zab@zabbo.net>, Dave Chinner <david@fromorbit.com>,
        <fstests@vger.kernel.org>, <linux-btrfs@vger.kernel.org>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH] xfstests/btrfs: add test for quota groups and drop snapshot
References: <20140709224150.GA5484@wotan.suse.de> <20140710004330.GG4453@dastard> <20140710173614.GB5484@wotan.suse.de> <20140710183228.GD17201@lenny.home.zabbo.net> <20140710190055.GC5484@wotan.suse.de> <20140722190532.GI1553@twin.jikos.cz> <20140723123056.GL1553@twin.jikos.cz>
In-Reply-To: <20140723123056.GL1553@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/23/2014 08:30 AM, David Sterba wrote:
> On Tue, Jul 22, 2014 at 09:05:32PM +0200, David Sterba wrote:
>> On Thu, Jul 10, 2014 at 12:00:55PM -0700, Mark Fasheh wrote:
>>> On Thu, Jul 10, 2014 at 11:32:28AM -0700, Zach Brown wrote:
>>>> What interfaces would be needed for this to work precisely so we don't
>>>> have to play this game ever again?
>>>
>>> Well there's also the 'sleep 45' below because we need to be certain that
>>> btrfs_drop_snapshot gets run. This was all a bit of a pain during debugging
>>> to be honest.
>>>
>>> So in my experience, an interface to make debugging easier would involve
>>> running every delayed action in the file system to completion, including a
>>> sync of dirty blocks to disk. In theory, this would include any delayed
>>> actions that were kicked off as a result of the actions you are syncing.
>>> You'd do it all from a point in time of course so that we don't spin forever
>>> on a busy filesystem. I do not know whether this is feasible.
>>>
>>> Given something like that, you'd just replace the calls to sleep with 'btrfs
>>> fi synctheworldandwait' and know that on return, the actions you just queued
>>> up completed.
>>
>> Waiting until some subvolume gets completely removed needs some work. In
>> your case the cleaner thread sleeps and is woken up at the transaction
>> commit time. As there is no other activity on the filesystem this
>> happens at the periodic commit time, usually 30 seconds. 'sync' will not
>> help, because it needs a transaction in progress.
>>
>> I have patchset in works that addresses a different problem but
>> introduces a functionality that keeps track of some global pending
>> actions. This could be easily enhanced to trigger the commit with sync
>> if there was a snapshot deletion since last commit regardless of a
>> transaction running status.
>>
>> This still does not cover the part where we want a command that waits
>> until a given subvolume is completely removed, but I have a draft for
>> that as well.
>>
>> Unfortunatelly until both parts are in place the sleep is the only
>> reliable way. Oh well.
>
> And it turned out to be much simpler, I was wrong about transaction
> commit poking the cleaner thread. It's actually the transaction commit
> thread that wakes up cleaner and that's why it's always at the periodic
> commit time.
>
> The proposed fix is to wake up transaction thread from the sync ioctl
> (not the generic sync call through).
>
> For the qgroup test needs it's enough to delete subvolumes, issue 'btrfs
> fi sync' and wait until there are no subvols listed (btrfs list -d).
>
> Without the fix, this will take up to 30 seconds, with the fix it's
> immediate. The test script will not need any change.
>

I'll just add a sync flag to the snapshot creation and then Mark can 
redo this test to use the sync flag once that stuff is in.  Thanks,

Josef
