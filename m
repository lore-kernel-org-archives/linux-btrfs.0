Return-Path: <SRS0=qFN0=RR=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9EA5C43381
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:17:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B19DB2184C
	for <linux-btrfs@archiver.kernel.org>; Thu, 14 Mar 2019 16:17:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727281AbfCNQRn (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 14 Mar 2019 12:17:43 -0400
Received: from drutsystem.com ([84.10.39.251]:47947 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727175AbfCNQRn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 14 Mar 2019 12:17:43 -0400
Subject: Re: mounting raid1 btrfs - occasional devid missing / open_ctree
 failed
From:   Michal Soltys <soltys@ziu.info>
To:     Hans van Kranenburg <hans@knorrie.org>, linux-btrfs@vger.kernel.org
References: <b6e6db9d-c81a-498b-508e-581f924ff573@ziu.info>
 <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
 <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
Message-ID: <964e3bcd-730a-c186-c0e1-cd538a3c0e83@ziu.info>
Date:   Thu, 14 Mar 2019 17:17:38 +0100
MIME-Version: 1.0
In-Reply-To: <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
X-MailScanner-ID: 022FB6BEEF7.A1E44
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/14/19 5:09 PM, Michal Soltys wrote:
> On 3/14/19 4:57 PM, Hans van Kranenburg wrote:
>> On 3/14/19 4:44 PM, Michal Soltys wrote:
>>> 
>>> <cut>
>>>
>>> Occasionally, during reboots (all of them clean of course) I get:
>>>
>>> devid 2 uuid <uuid> is missing
>>> failed to ready system array: -2
>>> open_ctree faield
>>>
>>> Which drops me into initramfs commandline.
>>
>> It might try to mount before all disks are visible. This can happen when
>> e.g. a raid controller needs a little bit more time to initialize.
>>
>> Try adding rootdelay=10 to your linux command line, or any other number,
>> and then look at logging when booting (so no quiet on your linux command
>> line).
>>
> 
> It remains unmountable from initramfs's commandline with both disks 
> (partitions) present. Filesystem is mounted formally via uuid, so it 
> needs both disks present before udev/blkid can pick the correct devices.
> 

E.g.

mount /dev/sdr2 /newroot -> fails
mount /dev/sds2 /newroot -> ok
umount /newroot
mount /dev/sdr2 /newroot -> ok

>>> When that happens, one of the partitions is mountable, the other is not.
>>> Mounting the filesystem via the "good" one also fixes the "bad" one.
>>>
>>> Tested with 4.20.11 and 5.0.2 kernels.
>>>
>>> Any idea what could be wrong ?
>>> Does btrfs require full umount via pivoted initramfs during shutdown ?
>> Hans
>>
> 
> 

