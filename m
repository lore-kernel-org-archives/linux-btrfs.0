Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:23685 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754848AbbDGOnP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 7 Apr 2015 10:43:15 -0400
Message-ID: <5523ECFC.9030506@fb.com>
Date: Tue, 7 Apr 2015 10:43:08 -0400
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: <linux-btrfs@vger.kernel.org>, <linux-fsdevel@vger.kernel.org>,
        <dm-devel@redhat.com>, <zab@redhat.com>, <fstests@vger.kernel.org>
Subject: Re: [PATCH 1/3] dm: log writes target
References: <1426797070-27463-1-git-send-email-jbacik@fb.com> <1426797070-27463-2-git-send-email-jbacik@fb.com> <20150321215051.GP10105@dastard>
In-Reply-To: <20150321215051.GP10105@dastard>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/21/2015 05:50 PM, Dave Chinner wrote:
> On Thu, Mar 19, 2015 at 04:31:08PM -0400, Josef Bacik wrote:
>> This creates a new target that is meant for file system developers to test file
>> system integrity at particular points in the life of a file system.  We capture
>> all write requests and the data and log the requests and the data to a separate
>> device for later replay.  There is a userspace utility to do this replay.  The
>> idea behind this is to give file system developers to verify that the file
>> system is always consistent.  Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
>> ---
>>   Documentation/device-mapper/dm-log-writes.txt | 136 +++++
>>   drivers/md/Kconfig                            |  16 +
>>   drivers/md/Makefile                           |   1 +
>>   drivers/md/dm-log-writes.c                    | 809 ++++++++++++++++++++++++++
>>   4 files changed, 962 insertions(+)
>>   create mode 100644 Documentation/device-mapper/dm-log-writes.txt
>>   create mode 100644 drivers/md/dm-log-writes.c
>>
>> diff --git a/Documentation/device-mapper/dm-log-writes.txt b/Documentation/device-mapper/dm-log-writes.txt
>> new file mode 100644
>> index 0000000..f3a9fa2
>> --- /dev/null
>> +++ b/Documentation/device-mapper/dm-log-writes.txt
>> @@ -0,0 +1,136 @@
>> +dm-log-writes
>> +=============
>> +
>> +This target takes 2 devices, one to pass all IO to normally, and one to log all
>> +of the write operations to.  This is intended for file system developers wishing
>> +to verify the integrity of metadata or data as the file system is written to.
>> +There is a log_writes_entry written for every WRITE request and the target is
>> +able to take arbitrary data from userspace to insert into the log.  The data
>> +that is in the WRITE requests is copied into the log to make the replay happen
>> +exactly as it happened originally.
>
> Hmm - terminology thing here - "log writes" have specific meaning to
> any application that does write ahead logging. E.g. journalling
> filesystems, databases, etc. So I find this name extremely confusing
> because a dm-log-write device has nothing to do with write ahead
> logging, log writes or journalling...
>
> I'm sure lots of other people are going to have the same problem
> understanding what this device is for because of that.
>
> I know this is effectively bikeshedding, but I think a less
> ambiguous name would be a good thing to have. e.g. dm-iotracer.
> Nobody will get confused that way....
>

Hey Dave,

Sorry I sent this patch and then promptly went on vacation.  Mike has 
already pulled the patch in and I've already gotten all this tooling 
built around the original name.  It is probably a little confusing, but 
since only a few of us are going to mess with it and it's mostly going 
to be used in an xfstests context I'm not too worried about it.  Thanks,

Josef

