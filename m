Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:40399 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161392AbaJaBie (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 30 Oct 2014 21:38:34 -0400
Message-ID: <5452E811.1080001@oracle.com>
Date: Fri, 31 Oct 2014 09:38:25 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
References: <1413334270-25766-2-git-send-email-anand.jain@oracle.com> <1414045808-6930-1-git-send-email-anand.jain@oracle.com> <20141030141833.GA15771@twin.jikos.cz>
In-Reply-To: <20141030141833.GA15771@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

  Thanks for the review..


On 30/10/2014 22:18, David Sterba wrote:
> On Thu, Oct 23, 2014 at 02:30:08PM +0800, Anand Jain wrote:
>>    introduce a global variable scan_done, which is set when scan is
>>    done succssfully per thread. So that following calls to this function
>>    will just return success.
>
> The rest is good, I'm a bit concerned about the global variable. It
> sholud be at least declared static and not visible outside of utils.c.

oh yes.

> The function btrfs_scan_lblkid is called indirectly from various
> callchains. For a moment I was thinking about declaring a variable to
> hold the scanning status, but btrfs_scan_lblkid is not always called
> from a scope of one cmd_something function. Eg. from btrfs_scan_fs_devices
> that in turn is called from several other functions. As we're not
> concerned about multi-threading, we can use the global variable.

yes. initially I was thinking the threads which needs the btrfs
device list would do something like init_device_list in the beginning
of the thread. And  the init device_list has to be created in
collaboration with the kernel, progs should take the mounted device
list from the kernel and read the unmounted devices only.
So I had the proposal of either

btrfs: introduce procfs interface for the device list
OR
btrfs: introduce BTRFS_IOC_GET_DEVS

but most suggest sysfs. sysfs is a state-full it does not suite the
purpose. previously we had sysfs bugs when device change its state.
we don't have that issue with profs/ioctl.

anyway for now I think btrfs_scan_done provides a simple workaround
fix as we don't have multi thread with in a process.

the other proposal I was thinking to make any device related operation
only thru the kernel, for example 'btrfs dev scan' will be only command
which will scan the system for the btrfs devices and register them with
the kernel (exclude the maintenance commands like btrfs check for now,
or move them into the kernel in the long run). And all further device
reporting will be from the kernel. With this progs can be very sleek..


>>    Further if any function needs to force scan after scan_done is set,
>>    then it can be done when there is such a requirement, but as of now there
>>    isn't any such requirement.
>
> Right, then we could introduce something like btrfs_scan_reset_status
> and then btrfs_scan_lblkid would work as usual.

Sent out V3 with this changes, Thanks.

>> --- a/utils.c
>> +++ b/utils.c
>> @@ -52,6 +52,8 @@
>>   #define BLKDISCARD	_IO(0x12,119)
>>   #endif
>>
>> +int scan_done = 0;
>
> I'll change it to the following and add to integration.
>
> int btrfs_scan_done = 0;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
