Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A87CC43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 17:54:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7247220811
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 17:54:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728045AbfCNRyf (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 13:54:35 -0400
Received: from drutsystem.com ([84.10.39.251]:48231 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728039AbfCNRyf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 13:54:35 -0400
Subject: Re: mounting raid1 btrfs - occasional devid missing / open_ctree
 failed
To:     Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
References: <b6e6db9d-c81a-498b-508e-581f924ff573@ziu.info>
 <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
 <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
 <964e3bcd-730a-c186-c0e1-cd538a3c0e83@ziu.info>
 <4fa8cdbb-63bc-69a2-53bb-43835bf8ab5f@knorrie.org>
From:   Michal Soltys <soltys@ziu.info>
Message-ID: <355a0070-8464-dd56-b2a2-9654c3a898a6@ziu.info>
Date:   Thu, 14 Mar 2019 18:54:28 +0100
MIME-Version: 1.0
In-Reply-To: <4fa8cdbb-63bc-69a2-53bb-43835bf8ab5f@knorrie.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-MailScanner-ID: E914D6BF18B.A2E9C
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/14/19 5:21 PM, Hans van Kranenburg wrote:
> On 3/14/19 5:17 PM, Michal Soltys wrote:
>> On 3/14/19 5:09 PM, Michal Soltys wrote:
>>> On 3/14/19 4:57 PM, Hans van Kranenburg wrote:
>>>> On 3/14/19 4:44 PM, Michal Soltys wrote:
>>>>>
>>>>> <cut>
>>>>>
>>>>> Occasionally, during reboots (all of them clean of course) I get:
>>>>>
>>>>> devid 2 uuid <uuid> is missing
>>>>> failed to ready system array: -2
>>>>> open_ctree faield
>>>>>
>>>>> Which drops me into initramfs commandline.
>>>>
>>>> It might try to mount before all disks are visible. This can happen when
>>>> e.g. a raid controller needs a little bit more time to initialize.
>>>>
>>>> Try adding rootdelay=10 to your linux command line, or any other number,
>>>> and then look at logging when booting (so no quiet on your linux command
>>>> line).
>>>>
>>>
>>> It remains unmountable from initramfs's commandline with both disks
>>> (partitions) present. Filesystem is mounted formally via uuid, so it
>>> needs both disks present before udev/blkid can pick the correct devices.
> 
> When using UUID in fstab/initramfs, all btrfs devices show up having the
> same UUID, so if any of them is present, it can try mounting.
> 
>> E.g.
>>
>> mount /dev/sdr2 /newroot -> fails
> 
> Are you typing this manually? And what's the error? Does it complain
> about the devid of sds2?

Yes.

Output captured via serial console (debug level) below.

> 
>> mount /dev/sds2 /newroot -> ok
> 
> While doing this you trigger the system to have a look, and at that
> moment it will suddenly discover the disk, and now it sees them both and
> it mounts...
> 
>> umount /newroot
>> mount /dev/sdr2 /newroot -> ok
> 
> ...even when using sdr2, because when doing the things above all disks
> got discovered.
> 
> It's of course possible you have another problem.My suggestion was just
> a been-there-done-that. But, in that case posting more logging might help.
> 

[   25.579637] md127: detected capacity change from 0 to 5401587744768
[   25.728050] PM: Image not found (code -22)
[   25.779465] BTRFS: device label xs22_root devid 1 transid 25364 /dev/sds2
[   25.810606] BTRFS info (device sds2): disk space caching is enabled
[   25.841015] BTRFS info (device sds2): has skinny extents
[   25.870085] BTRFS error (device sds2): devid 2 uuid c93d387c-1acc-4bea-aeae-59a440ac7991 is missing
[   25.903337] BTRFS error (device sds2): failed to read the system array: -2
[   25.957884] BTRFS error (device sds2): open_ctree failed
[   26.002614] printk: systemd-udevd: 53 output lines suppressed due to ratelimiting


BusyBox v1.22.1 (Debian 1:1.22.0-19+b3) built-in shell (ash)
Enter 'help' for a list of built-in commands.

(initramfs) mount /dev/sds2 /root
[   42.638417] BTRFS info (device sds2): disk space caching is enabled
[   42.673164] BTRFS info (device sds2): has skinny extents
[   42.706947] BTRFS error (device sds2): devid 2 uuid c93d387c-1acc-4bea-aeae-59a440ac7991 is missing
[   42.743085] BTRFS error (device sds2): failed to read the system array: -2
[   42.789905] BTRFS error (device sds2): open_ctree failed
mount: mounting /dev/sds2 on /root failed: Invalid argument
(initramfs) mount /dev/sdr2 /root
[   54.216006] BTRFS: device label xs22_root devid 2 transid 25364 /dev/sdr2
[   54.249603] BTRFS info (device sds2): disk space caching is enabled
[   54.281158] BTRFS info (device sds2): has skinny extents
[   54.318920] BTRFS info (device sds2): enabling ssd optimizations
[   54.352494] BTRFS info (device sds2): checking UUID tree
(initramfs) umount /root
(initramfs) mount /dev/sds2 /root
[   63.458869] BTRFS info (device sds2): disk space caching is enabled
[   63.490016] BTRFS info (device sds2): has skinny extents
[   63.529345] BTRFS info (device sds2): enabling ssd optimizations
