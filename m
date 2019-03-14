Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1B3FC10F06
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B6B462186A
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727590AbfCNQJq (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:09:46 -0400
Received: from drutsystem.com ([84.10.39.251]:47907 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbfCNQJp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 12:09:45 -0400
Subject: Re: mounting raid1 btrfs - occasional devid missing / open_ctree
 failed
To:     Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
References: <b6e6db9d-c81a-498b-508e-581f924ff573@ziu.info>
 <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
From:   Michal Soltys <soltys@ziu.info>
Message-ID: <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
Date:   Thu, 14 Mar 2019 17:09:36 +0100
MIME-Version: 1.0
In-Reply-To: <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-MailScanner-ID: 6BF456BEE83.A3BDE
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/14/19 4:57 PM, Hans van Kranenburg wrote:
> On 3/14/19 4:44 PM, Michal Soltys wrote:
>> Hi,
>>
>> I have btrfs set for root filesystem using two separate partitions,
>> essentially:
>>
>> abel: 'xs22_root'  uuid: 3754849d-46ab-4db6-8434-2c578b1f6bba
>>          Total devices 2 FS bytes used 8.39GiB
>>          devid    1 size 34.00GiB used 14.01GiB path /dev/sdb2
>>          devid    2 size 34.00GiB used 14.01GiB path /dev/sda2
>>
>>
>> Data,RAID1: Size:12.00GiB, Used:8.13GiB
>>     /dev/sda2      12.00GiB
>>     /dev/sdb2      12.00GiB
>>
>> Metadata,RAID1: Size:2.00GiB, Used:256.62MiB
>>     /dev/sda2       2.00GiB
>>     /dev/sdb2       2.00GiB
>>
>> System,RAID1: Size:8.00MiB, Used:16.00KiB
>>     /dev/sda2       8.00MiB
>>     /dev/sdb2       8.00MiB
>>
>> Unallocated:
>>     /dev/sda2      19.99GiB
>>     /dev/sdb2      19.99GiB
>>
>>
>> Occasionally, during reboots (all of them clean of course) I get:
>>
>> devid 2 uuid <uuid> is missing
>> failed to ready system array: -2
>> open_ctree faield
>>
>> Which drops me into initramfs commandline.
> 
> It might try to mount before all disks are visible. This can happen when
> e.g. a raid controller needs a little bit more time to initialize.
> 
> Try adding rootdelay=10 to your linux command line, or any other number,
> and then look at logging when booting (so no quiet on your linux command
> line).
> 

It remains unmountable from initramfs's commandline with both disks 
(partitions) present. Filesystem is mounted formally via uuid, so it 
needs both disks present before udev/blkid can pick the correct devices.

>> When that happens, one of the partitions is mountable, the other is not.
>> Mounting the filesystem via the "good" one also fixes the "bad" one.
>>
>> Tested with 4.20.11 and 5.0.2 kernels.
>>
>> Any idea what could be wrong ?
>> Does btrfs require full umount via pivoted initramfs during shutdown ?
> Hans
> 

