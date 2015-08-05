Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:34240 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801AbbHEVvm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Aug 2015 17:51:42 -0400
Message-ID: <55C28554.708@oracle.com>
Date: Thu, 06 Aug 2015 05:51:16 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.com, linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 0/6] sysfs-part2 Add seed device representation on the
 sysfs
References: <1436340774-10909-1-git-send-email-anand.jain@oracle.com> <20150805172908.GI31669@twin.jikos.cz>
In-Reply-To: <20150805172908.GI31669@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi David,

  Thanks. more below.

On 08/06/2015 01:29 AM, David Sterba wrote:
> On Wed, Jul 08, 2015 at 03:32:48PM +0800, Anand Jain wrote:
>> This patch adds the support to show seed device on the btrfs sysfs.
>> This is a revamped version of the previously single patch 6/6, and plus
>> incorporates David suggestion to add seed fsid under the 'seed' kobject.
>>
>> Since this adds new patches and to bring in seed kobject it needed
>> quite a lot of revamp I am resetting the patch set version to 1.
>>
>> Anand Jain (6):
>>    Btrfs: rename btrfs_sysfs_add_one to btrfs_sysfs_add_mounted
>>    Btrfs: rename btrfs_sysfs_remove_one to btrfs_sysfs_remove_mounted
>>    Btrfs: rename btrfs_kobj_add_device to btrfs_sysfs_add_device_link
>>    Btrfs: rename btrfs_kobj_rm_device to btrfs_sysfs_rm_device_link
>>    Btrfs: rename super_kobj to fsid_kobj

  these can go in.

>>    Btrfs: sysfs: support seed devices in the sysfs layout
>
> Sorry for late reply, the patches look good. I'm going to prepare a
> branch for pull into 4.3. Thanks.

I suggested if this can wait.
on the 2nd thought, I am preparing to conduct a survey to know most 
preferred sysfs layout for btrfs.
  mainly between
  one, less invasive overlays on the existing layout (current method).
  the other, separates FS and Volume attributes (old method).

  sorry that I am going back a bit, but i think its worth as these API 
are forever.

thanks, Anand
