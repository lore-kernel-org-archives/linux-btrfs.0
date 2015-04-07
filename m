Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:8306 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbbDGOlt (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 10:41:49 -0400
Message-ID: <5523ECA6.3070902@fb.com>
Date: Tue, 7 Apr 2015 10:41:42 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Mike Snitzer <snitzer@redhat.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <dm-devel@redhat.com>, <fstests@vger.kernel.org>, <zab@redhat.com>
Subject: Re: [PATCH 1/3] dm: log writes target V2
References: <20150319231655.GA6751@lenny.home.zabbo.net> <1426863037-5870-1-git-send-email-jbacik@fb.com> <20150324153338.GA2055@redhat.com>
In-Reply-To: <20150324153338.GA2055@redhat.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/24/2015 11:33 AM, Mike Snitzer wrote:
> On Fri, Mar 20 2015 at 10:50am -0400,
> Josef Bacik <jbacik@fb.com> wrote:
>
>> This creates a new target that is meant for file system developers to test file
>> system integrity at particular points in the life of a file system.  We capture
>> all write requests and the data and log the requests and the data to a separate
>> device for later replay.  There is a userspace utility to do this replay.  The
>> idea behind this is to give file system developers to verify that the file
>> system is always consistent.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>
> Hey Josef,
>
> Nice job with this target, you need to contribute to DM more ;)
>
> I've staged your target for the 4.1 merge in linux-dm.git's 'for-next'
> branch (with a few small fixes for nits/typos).
>
> FYI, I'll likely rebase 'for-next' once more for 4.1 given a conflicting
> 4.0 change to DM core still needs to land upstream (you can see the
> merge conflict in 'for-next' at the moment).  But that won't impact your
> target at all (other than changing the 4.1 commit id).
>

Great thanks Mike!

Josef

