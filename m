Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:57440 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752710AbaAXOxG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 24 Jan 2014 09:53:06 -0500
Message-ID: <52E27E4D.6070107@fb.com>
Date: Fri, 24 Jan 2014 09:53:01 -0500
From: Josef Bacik <jbacik@fb.com>
MIME-Version: 1.0
To: <bo.li.liu@oracle.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: throttle delayed refs better
References: <1390500472-15144-1-git-send-email-jbacik@fb.com> <20140124073448.GC31638@localhost.localdomain>
In-Reply-To: <20140124073448.GC31638@localhost.localdomain>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 01/24/2014 02:34 AM, Liu Bo wrote:
> On Thu, Jan 23, 2014 at 01:07:52PM -0500, Josef Bacik wrote:
>> On one of our gluster clusters we noticed some pretty big lag spikes.  This
>> turned out to be because our transaction commit was taking like 3 minutes to
>> complete.  This is because we have like 30 gigs of metadata, so our global
>> reserve would end up being the max which is like 512 mb.  So our throttling code
>> would allow a ridiculous amount of delayed refs to build up and then they'd all
>> get run at transaction commit time, and for a cold mounted file system that
>> could take up to 3 minutes to run.  So fix the throttling to be based on both
>> the size of the global reserve and how long it takes us to run delayed refs.
>> This patch tracks the time it takes to run delayed refs and then only allows 1
>> seconds worth of outstanding delayed refs at a time.  This way it will auto-tune
>> itself from cold cache up to when everything is in memory and it no longer has
>> to go to disk.  This makes our transaction commits take much less time to run.
>> Thanks,
> Which version of btrfs is the patch made for?
>
> I checked the code and it doesn't seem to be btrfs-next, either...we don't
> have a __btrfs_run_delayed_refs().

It depends on the patch I sent before where I move delayed refs onto a 
delayed ref head rb tree.  Thanks,

Josef
