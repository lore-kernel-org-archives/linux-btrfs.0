Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:52433 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932271AbcHITWY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Aug 2016 15:22:24 -0400
Subject: Re: btrfs dev del hangs on 4.7
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
References: <20160809172758.GB9644@carfax.org.uk>
 <23be7ecd-500b-76ed-ea91-88885872031e@fb.com>
 <20160809182356.GC9644@carfax.org.uk>
 <b325a93d-47ca-be69-04b2-271cd7387506@fb.com>
 <20160809182733.GD9644@carfax.org.uk> <20160809191134.GE9644@carfax.org.uk>
From: Chris Mason <clm@fb.com>
Message-ID: <4d0c6117-da81-b13f-667a-d36dcae7e979@fb.com>
Date: Tue, 9 Aug 2016 15:22:03 -0400
MIME-Version: 1.0
In-Reply-To: <20160809191134.GE9644@carfax.org.uk>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 08/09/2016 03:11 PM, Hugo Mills wrote:
> On Tue, Aug 09, 2016 at 06:27:33PM +0000, Hugo Mills wrote:
>> On Tue, Aug 09, 2016 at 02:26:14PM -0400, Chris Mason wrote:
>>> On 08/09/2016 02:23 PM, Hugo Mills wrote:
>>>>   Hi, Chris,
>>>>
>>>> On Tue, Aug 09, 2016 at 02:02:20PM -0400, Chris Mason wrote:
>>>>> On 08/09/2016 01:27 PM, Hugo Mills wrote:
>>>>>>  Over the weekend, I started doing some maintenance on my server: I
>>>>>> upgraded to 4.7.0, and I started deleting a device from my array,
>>>>>> preparatory to putting in a larger one. About halfway through the
>>>>>> operation, several kernel threads hung up for a while (resulting in
>>>>>> "blocked for 120s" messages), and then the delete process seems to
>>>>>> have stopped entirely, although several kernel threads are at maximum
>>>>>> usage.
>>>>>>
>>>>>>  After a few hours, I rebooted the machine, and left it for a day or
>>>>>> so. I tried the delete again this afternoon, and it's done the same
>>>>>> thing again. The full log is included below. I have a kworker and a
>>>>>> btrfs-transaction pegged at close to 100% of a core each, and a
>>>>>> btrfs-cleaner (and the btrfs dev del process) in D state.
>>>>>>
>>>>>>  The FS was not under load at the time of the failure, and it passes
>>>>>> scrub. I haven't tried a btrfs check yet.
>>>>>
>>>>> Thanks Hugo, can you nail down which line of code belongs to:
>>>>>
>>>>> btrfs_async_run_delayed_refs+0xc6
>>>>
>>>>   I'm having a spot of trouble with this. The btrfs on this kernel is
>>>> built-in, and I've lost the contents of the build directory (it's done
>>>> by an overnight build script, and it's already built a 4.8-rc1 for one
>>>> of my other machines).
>>>>
>>>> (gdb) file /boot/vmlinuz-4.7.0-dirty
>>>> BFD: /boot/vmlinuz-4.7.0-dirty: Warning: Ignoring section flag IMAGE_SCN_MEM_NOT_PAGED in section .bss
>>>> Reading symbols from /boot/vmlinuz-4.7.0-dirty...(no debugging symbols found)...done.
>>>> (gdb) list *btrfs_async_run_delayed_refs+0xc6
>>>> No symbol table is loaded.  Use the "file" command.
>>>>
>>>>   There must be a way of getting this info from here, but I'm not
>>>> sure I know what it is. Build a new kernel from 4.7 with this
>>>> machine's config and run gdb on the btrfs.o file? Not a problem to do,
>>>> but it might take a little while.
>>>
>>> As long as you use the same gcc and config file, it'll almost always
>>> generate the same offsets/code.  You can recompile with debug
>>> symbols on and it'll be accurate.
>>
>>    OK. Back later.
>
> (gdb) file fs/btrfs/btrfs.o
> Reading symbols from fs/btrfs/btrfs.o...done.
> (gdb) list *btrfs_async_run_delayed_refs+0xc6
> 0x13dae is in btrfs_async_run_delayed_refs (fs/btrfs/extent-tree.c:2915).
> 2910	
> 2911		btrfs_queue_work(root->fs_info->extent_workers, &async->work);
> 2912		
> 2913			if (wait) {
> 2914			   	  wait_for_completion(&async->wait);
> 2915						ret = async->error;
> 2916						      kfree(async);
> 2917								return ret;
> 2918								       }
> 2919									return 0;

So its waiting on the actual delayed ref work but we don't see them in 
the stack trace.

Can you please sysrq-w and sysrq-t?

-chris

