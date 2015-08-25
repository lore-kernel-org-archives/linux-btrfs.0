Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:42058 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196AbbHYEnN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 00:43:13 -0400
Message-ID: <55DBF1D2.2020708@oracle.com>
Date: Tue, 25 Aug 2015 12:40:50 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org, eguan@redhat.com,
        fdmanana@gmail.com
Subject: Re: [PATCH v6 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1439549224-29784-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-1-git-send-email-anand.jain@oracle.com> <1439566305-12460-2-git-send-email-anand.jain@oracle.com> <20150816235218.GD20596@dastard> <55D2B40E.5040801@oracle.com> <20150818221157.GE3902@dastard> <55D3F4FA.6080309@oracle.com> <20150819064529.GJ3902@dastard> <55D57D11.8050508@oracle.com> <20150820214511.GP3902@dastard>
In-Reply-To: <20150820214511.GP3902@dastard>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



Dave,

On 08/21/2015 05:45 AM, Dave Chinner wrote:
> On Thu, Aug 20, 2015 at 03:09:05PM +0800, Anand Jain wrote:
>>
>>   (thanks for the off-ML emails from the people who helped me
>>   to understand).
>>
>> Dave,
>>
>>   looks like you are suggesting something like..
>>
>> -------
>> +_dmerror_mount_options()
>> +{
>> +       _scratch_options mount
>> +       echo $SCRATCH_OPTIONS $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS \
>> +                                       $* $DMERROR_DEV $SCRATCH_MNT
>> +}
>> +
>> +_dmerror_mount()
>> +{
>> +       _mount -t $FSTYP `_dmerror_mount_options $*`
>> +}
>> --------
>
> Very close. :)
>
> You've got the structure right, but missed one more thing: the
> options are still cut'n'paste from _scratch_mount_options, and so
> should be /factored/ into a common function...
>
> _scratch_options is only useful to XFS to set external log/realtime
> devices, and we don't want to do that for the dmerror device.
> Everthing else is almost the same as _scratch_mount_options(),
> however.  So:
>
> # Used for mounting non-scratch devices (e.g. loop, dm constructs)
> # with the safe set of scratch mount options (e.g. loop image may be
> # hosted on $SCRATCH_DEV, so can't use external scratch devices).
> _common_dev_mount_options()
> {
> 	echo $MOUNT_OPTIONS $SELINUX_MOUNT_OPTIONS $*
> }
>
> _scratch_mount_options()
> {
> 	_scratch_options mount
>
> 	echo `_common_dev_mount_options $*` $SCRATCH_OPTIONS \
> 					    $SCRATCH_DEV $SCRATCH_MNT
>
> }


> _dmerror_mount_options()
> {
>         echo `_common_dev_mount_options $*` $DMERROR_DEV $SCRATCH_MNT
> }


   this would make test cases nice and sleek. Thanks. I have this in v8.


> And to demonstrate why factoring like this is useful, this can also
> be applied to _mount_flakey(), and we could also replace most of the
> open-coded loop device mounts with a generic "mount device" function
> like:

   yes indeed. I suggest if these could be handled in a separate patch
   as this would deviate from the intentions of this patch set ?

Thanks, Anand


> _mount_dev()
> {
> 	_mount `_common_dev_mount_options $*`
> }
>
> and call it like:
>
> _mount_dev $LOOP_DEV $MNT_POINT
>
> or even
>
> _mount_dev -o loop $MNT_POINT
>
> We can then take it further: if we have a _mount_dev() wrapper we
> can factor _common_dev_mount_options() from all the
> _*_mount_options() functions. i.e:
>
> _scratch_mount_options()
> {
> 	_scratch_options mount
>
> 	echo $SCRATCH_OPTIONS $SCRATCH_DEV $SCRATCH_MNT
> }
>
> _scratch_mount()
> {
> 	_mount_dev $* `_scratch_mount_options`
> }
>
> The result is we end up with a much cleaner set of mount functions
> that are more generic, more extensible and easier to use, as well as
> being more maintainable....
>
>>   Sorry that the word 'should mirror _scratch_mount()' confused me.
>
> Ok, I'll try to be more clear in future.
>
> Cheers,
>
> Dave.
>
