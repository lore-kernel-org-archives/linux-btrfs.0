Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:53255 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750836AbaBCVIg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 3 Feb 2014 16:08:36 -0500
Message-ID: <52F00538.3010505@fb.com>
Date: Mon, 3 Feb 2014 16:08:08 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: Johannes Hirte <johannes.hirte@datenkhaos.de>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
References: <1390500472-15144-1-git-send-email-jbacik@fb.com> <20140203192811.72866921@datenkhaos.de>
In-Reply-To: <20140203192811.72866921@datenkhaos.de>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 02/03/2014 01:28 PM, Johannes Hirte wrote:
> On Thu, 23 Jan 2014 13:07:52 -0500
> Josef Bacik <jbacik@fb.com> wrote:
>
>> On one of our gluster clusters we noticed some pretty big lag
>> spikes.  This turned out to be because our transaction commit was
>> taking like 3 minutes to complete.  This is because we have like 30
>> gigs of metadata, so our global reserve would end up being the max
>> which is like 512 mb.  So our throttling code would allow a
>> ridiculous amount of delayed refs to build up and then they'd all get
>> run at transaction commit time, and for a cold mounted file system
>> that could take up to 3 minutes to run.  So fix the throttling to be
>> based on both the size of the global reserve and how long it takes us
>> to run delayed refs. This patch tracks the time it takes to run
>> delayed refs and then only allows 1 seconds worth of outstanding
>> delayed refs at a time.  This way it will auto-tune itself from cold
>> cache up to when everything is in memory and it no longer has to go
>> to disk.  This makes our transaction commits take much less time to
>> run. Thanks,
>>
>> Signed-off-by: Josef Bacik <jbacik@fb.com>
> This one breaks my system. Shortly after boot the btrfs-freespace
> thread goes up to 100% CPU usage and the system is nearly unresponsive.
> I've seen it first with the full pull request for 3.14-rc1 and was able
> to track it down to this patch.
Could you turn on the softlockup timer and see if you can get a 
backtrace of where it is stuck?  In the meantime I will go through and 
see if I can pinpoint where it may be happening.  Thanks,

Josef
