Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19981 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab3JVFyH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Oct 2013 01:54:07 -0400
Message-ID: <526612EB.1050802@oracle.com>
Date: Tue, 22 Oct 2013 13:53:47 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org, chris.mason@fusionio.com
Subject: Re: [PATCH 1/3 v4] btrfs-progs: use kernel for mounted disk for show
References: <1381203700-17558-1-git-send-email-anand.jain@oracle.com> <20131015171333.GM5787@twin.jikos.cz> <20131021144428.GG6924@localhost.localdomain>
In-Reply-To: <20131021144428.GG6924@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 10/21/13 10:44 PM, Josef Bacik wrote:
> On Tue, Oct 15, 2013 at 07:13:33PM +0200, David Sterba wrote:
>> On Tue, Oct 08, 2013 at 11:41:38AM +0800, Anand Jain wrote:
>>> As of now btrfs filesystem show reads directly from
>>> disks. So sometimes output can be stale, mainly when
>>> user wants to cross verify their operation like,
>>> label or device delete or add... etc. so this
>>> patch will read from the kernel ioctl if it finds
>>> that disk is mounted.
>>
>> Sorry for holding this patch back for so long, I wanted to find out why
>> the output is different before and after. The reason is simple, for my
>> convenience I've added the user to the 'disk' group so I can access the
>> block devices without root. This patch stops to read the block devs
>> directly and uses the ioctl BTRFS_IOC_FS_INFO which gives me a silent
>> EPERM. If I run show with sudo, then all filesystems show up as
>> expected.
>>
>
> This patch needs to be dropped (I imagine the whole series too) as it breaks
> xfstests btrfs/003.  If I do btrfs fi show on a mounted fs I get this
>
> [root@destiny btrfs-progs]# btrfs fi show /dev/sdc
> Btrfs v0.20-rc1-483-ge0173f6
> [root@destiny btrfs-progs]#
>
> Chris this is in integration, so maybe a revert?  Thanks,

  That would be less productive approach as a whole.
  I have sent out the fix for this. Kindly find it.

---
[PATCH 1/2] btrfs-progs: make get_btrfs_mount callable
[PATCH 2/2] btrfs-progs: filesystem show of specified mounted disk 
should work
---

Thanks, Anand
