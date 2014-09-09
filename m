Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40229 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171AbaIIDWP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Sep 2014 23:22:15 -0400
Message-ID: <540E7359.4050000@oracle.com>
Date: Tue, 09 Sep 2014 11:26:17 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: kreijack@inwind.it, dsterba@suse.cz, Chris Mason <clm@fb.com>
CC: Miao Xie <miaox@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] Scan all devices to build fs device list
References: <1409751393-5403-1-git-send-email-miaox@cn.fujitsu.com> <540B6900.7000307@fb.com> <20140908090946.GI5636@twin.jikos.cz> <540D8D45.6000608@oracle.com> <540DE427.4040008@inwind.it>
In-Reply-To: <540DE427.4040008@inwind.it>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>>   Since we are on the topic of scanning. A point on improving the
>>   btrfs-progs scan method which I am working on...
>>
>>     - Scan of all system devices is an expensive task. But btrfs-progs
>>       do it very liberally. Due to this there are some serious problem
>>       like - btrfs fi show is too slow when scrub is running.
>>
>>     - The worst is Single btrfs-progs thread scans for btrfs
>>       devices multiple times. Mainly because most of the functions
>>       uses check_mounted() which in turn calls scan, think of
>>       multi device btrfs config.
>
> Using libblkid (see your proposal below) would help in this case,
> because the values would be cached.

   may be, let me try / report. but first I need to search for a system
   with at least 100+  LUNs.


>>     - The problem would be more prominent in larger server with 1000's
>>       of LUNs / devices.
>>
>>     - lblkid can be the only method to scan for devices. (The other
>>       method we have as of now is of canning /proc/partitions, which
>>       lblkid also does).
>>
>>    what I am planning -
>>      Use btrfs control ioctl to help btrfs-progs check_mounted() to know
>>        if a (multi) device is mounted.
>>      Build kernel's fs_devices list in the user-space using btrfs
>>        control ioctl.
>>      Do device scan only once per btrfs-progs thread.
>
> You are talking about a ioctl: why not use (extending them when needed)
> the sysfs information ?

  yeah, I understand I am the only person talking about ioctl,
  and all others recommend sysfs. I understand I am wrong, but
  just by mass. and I still have no idea why not ioctl ?
  Problem with sysfs:
   - Note that sysfs supports only one parameter value with max length
   u64, to rebuilt entire kernel's fs_uuid list in the user space
   that would be quite a lot of sysfs files. should that be fine ?
   Further we would need another traverser tool (python ?) to read
   all these sysfs files. ? so that we could create fs_uuid list
   in the user-space.

   - we would need all info about the kernel fs_uuid, even when the
  device is not mounted.

   - thinking of nested seed with sysfs is more complicated, as we would
  have same btrfs_device at multiple fs_devices. still we must represent
  them in the sysfs.

   - as of now fs_uuid can grow infinite with just "a" device.
    ref: [PATCH 1/2] btrfs: device list could grow infinite
    can't imagine anybody traversing through /sysfs to understand
    what btrfs-kernel think of devices. user would prefer a cli
    to know that instead.

   - sysfs layout has to be dynamic based on fs_uuids list changes,
   devices added, removed, mounted replaced etc.. isn't it making
   more unstable ?


appreciate your comments

Anand
