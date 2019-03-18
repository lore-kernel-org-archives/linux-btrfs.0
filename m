Return-Path: <SRS0=8Q4i=RV=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4905FC10F00
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 17:15:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 247E020863
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Mar 2019 17:15:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbfCRRPc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Mar 2019 13:15:32 -0400
Received: from drutsystem.com ([84.10.39.251]:47822 "EHLO drutsystem.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726626AbfCRRPb (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Mar 2019 13:15:31 -0400
Subject: Re: mounting raid1 btrfs - occasional devid missing / open_ctree
 failed
From:   Michal Soltys <soltys@ziu.info>
To:     Andrei Borzenkov <arvidjaar@gmail.com>,
        Hans van Kranenburg <hans@knorrie.org>,
        linux-btrfs@vger.kernel.org
References: <b6e6db9d-c81a-498b-508e-581f924ff573@ziu.info>
 <eb16d309-7e81-8afb-ae2c-bd93862e1ace@knorrie.org>
 <ff6e0ace-72fb-0dc0-8fdb-8e12b2907680@ziu.info>
 <964e3bcd-730a-c186-c0e1-cd538a3c0e83@ziu.info>
 <49202dac-6ae2-b49f-f946-a64dce3115a3@gmail.com>
 <0ff19749-3e19-a78f-5560-d20e8177478c@ziu.info>
Message-ID: <a0fb1af2-105b-5ee4-e5ca-feb143076001@ziu.info>
Date:   Mon, 18 Mar 2019 18:15:21 +0100
MIME-Version: 1.0
In-Reply-To: <0ff19749-3e19-a78f-5560-d20e8177478c@ziu.info>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
X-MailScanner-ID: F40D36C5066.AF70C
X-MailScanner: Not scanned: please contact your Internet E-Mail Service Provider for details
X-MailScanner-From: soltys@ziu.info
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 3/15/19 10:36 AM, Michal Soltys wrote:
> On 19/03/15 04:59, Andrei Borzenkov wrote:
>> 14.03.2019 19:17, Michal Soltys пишет:
>>> On 3/14/19 5:09 PM, Michal Soltys wrote:
>>>> On 3/14/19 4:57 PM, Hans van Kranenburg wrote:
>>>>> On 3/14/19 4:44 PM, Michal Soltys wrote:
>>>>>>
>>>>>> <cut>
> 
> That would point to some really weird thing [not] being done in 
> initramfs in its debian variation. I'll look closer into it.
> 
> Thanks for pointing that out, the 'btrfs device scan' requirement 
> completely slipped my mind.
> 
>> What "dmesg | grep -i btrfs" shows before and after these commands?
>>
> 
> Will verify and report.
> 

Turned out to be a peculiar race issue with debian's initrams-tools's btrfs script (basically executing device scan during its local-premount stage). As it turned out it can be executed very early - in my case, before any block device is even visible in /dev. So no wonder later root mounting didn't work correctly.

Hans, Andrei - thanks for help.

For the record:

[   15.445002] scsi 0:0:7:0: atapi(n), ncq(y), asyn_notify(n), smart(y), fua(y), sw_preserve(y)
[   15.545118] input:   USB Keyboard as /devices/pci0000:00/0000:00:1d.0/usb2/2-1/2-1.1/2-1.1.3/2-1.1.3:1.0/0003:09DA:0260.0003/input/input2
->>> [   15.754962] ::: Starting BTRFS pre-mount
[   15.801450] scsi 0:0:8:0: Direct-Access     ATA      ST2000VX000-1CU1 CV22 PQ: 0 ANSI: 6
->>> [   15.803632] ::: Finishing BTRFS pre-mount
[   15.851614] scsi 0:0:8:0: SATA: handle(0x000f), sas_addr(0x5003048000b28b90), phy(16), device_name(0x0000000000000000)
[   15.854133] hid-generic 0003:09DA:0260.0003: input,hidraw2: USB HID v1.10 Keyboard [  USB Keyboard] on usb-0000:00:1d.0-1.1.3/input0

.... then a bit later devices become available:

[   19.691841] sd 0:0:0:0: Power-on or device reset occurred
[   19.692125] sd 0:0:1:0: Power-on or device reset occurred
[   19.740664] sd 0:0:2:0: Power-on or device reset occurred
[   19.740803] scsi 1:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB08 0370 PQ: 0 ANSI: 5
[   19.741009] sd 0:0:12:0: Power-on or device reset occurred
[   19.741166] scsi 2:0:0:0: Direct-Access     ATA      INTEL SSDSC2BB08 0370 PQ: 0 ANSI: 5
[   19.741348] sd 0:0:3:0: Power-on or device reset occurred
[   19.742136] sd 0:0:0:0: [sda] 7814037168 512-byte logical blocks: (4.00 TB/3.64 TiB)

... and finally:

[   25.221537] md127: detected capacity change from 0 to 5401587744768
[   25.363978] PM: Image not found (code -22)
[   25.424970] BTRFS: device label xs22_root devid 1 transid 33775 /dev/sds2
[   25.455095] BTRFS info (device sds2): disk space caching is enabled
[   25.483435] BTRFS info (device sds2): has skinny extents
[   25.513225] BTRFS error (device sds2): devid 2 uuid c93d387c-1acc-4bea-aeae-59a440ac7991 is missing
[   25.546619] BTRFS error (device sds2): failed to read the system array: -2
[   25.602175] BTRFS error (device sds2): open_ctree failed

