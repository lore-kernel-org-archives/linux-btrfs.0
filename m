Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:30092 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751815AbdEPJrK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 16 May 2017 05:47:10 -0400
From: Anand Jain <anand.jain@oracle.com>
Subject: Re: [PATCH v2] btrfs: add framework to handle device flush error as a
 volume
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
References: <20170425085831.14999-1-anand.jain@oracle.com>
 <20170505231754.9201-1-anand.jain@oracle.com>
 <20170509171235.GH5491@twin.jikos.cz>
Message-ID: <7dc65862-fc06-93dc-49d5-2d0c84ea42ad@oracle.com>
Date: Tue, 16 May 2017 17:52:52 +0800
MIME-Version: 1.0
In-Reply-To: <20170509171235.GH5491@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/10/2017 01:12 AM, David Sterba wrote:
> On Sat, May 06, 2017 at 07:17:54AM +0800, Anand Jain wrote:
>> This adds comments to the flush error handling part of
>> the code, and hopes to maintain the same logic with a
>> framework which can be used to handle the errors at the
>> volume level.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>
> Reviewed-by: David Sterba <dsterba@suse.com>

  Thanks.

> So the next step is to preallocate the flush_bio and remove the ENOMEM
> handling.

  one or the other way ENOMEM is going to go away. Thinking to fix
  blkdev_issue_flush(), which IMO is the right way, its RFC is sent out.


> submit_bio can fail, the error code will be stored to the bio and this
> will be checked in the waiting side.
>
> Then write_dev_flush can be split into 2 functions by the parameter
> 'wait', as the paths are completely independent.

  The new KPI blkdev_issue_flush_no_wait() makes it much simpler,
  I have sent out the btrfs part of the RFC patch as well. Thanks.

>> +static int check_barrier_error(struct btrfs_fs_devices *fsdevs)
>> +{
>> +	int submit_flush_error = 0;
>> +	int dev_flush_error = 0;
>> +	struct btrfs_device *dev;
>> +	int tolerance;
>> +
>> +	list_for_each_entry_rcu(dev, &fsdevs->devices, dev_list) {
>> +		if (!dev->bdev) {
>> +			submit_flush_error++;
>> +			dev_flush_error++;
>> +			continue;
>> +		}
>> +		if (dev->last_flush_error == -ENOMEM)
>> +			submit_flush_error++;
>> +		if (dev->last_flush_error && dev->last_flush_error != -ENOMEM)
>> +			dev_flush_error++;
>> +	}
>> +
>> +	tolerance = fsdevs->fs_info->num_tolerated_disk_barrier_failures;
>> +	if (submit_flush_error > tolerance || dev_flush_error > tolerance)
>> +		return -EIO;
>
> Actually, after reading submit_bio and the comment above, do we need to
> care about the submission errors? As submit_bio could return -EIO
> immeditaelly, but does not help us anyway. We'll wait and check again
> later.  It's the bio completion what counts.
>
> This should simplify the code.

  Yeah. we don;t have to worry about the send part of the error, when
  all the error that may encounter is all related to the device itself.

  There are RFC patches for the device state: offline and failed, now
  depending on whether the flush returned EIO or transport error ENXIO
  I intend to choice the device state such as of failed or offline
  respectively.

Thanks, Anand
