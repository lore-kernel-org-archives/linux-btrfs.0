Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f51.google.com ([209.85.215.51]:35799 "EHLO
	mail-lf0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbcFESUl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 14:20:41 -0400
Received: by mail-lf0-f51.google.com with SMTP id w16so82111816lfd.2
        for <linux-btrfs@vger.kernel.org>; Sun, 05 Jun 2016 11:20:40 -0700 (PDT)
Subject: Re: Recommended why to use btrfs for production?
To: James Johnston <johnstonj.public@codenest.com>,
        "'Mladen Milinkovic'" <maxrd2@smoothware.net>,
        "'Chris Murphy'" <lists@colorremedies.com>,
        "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com>
 <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com>
 <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com>
 <73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
 <0aaf01d1bf48$020d4670$0627d350$@codenest.com>
Cc: "'Martin'" <rc6encrypted@gmail.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
From: Andrei Borzenkov <arvidjaar@gmail.com>
Message-ID: <57546D75.8080401@gmail.com>
Date: Sun, 5 Jun 2016 21:20:37 +0300
MIME-Version: 1.0
In-Reply-To: <0aaf01d1bf48$020d4670$0627d350$@codenest.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

05.06.2016 19:33, James Johnston пишет:
> On 06/05/2016 10:46 AM, Mladen Milinkovic wrote:
>> On 06/03/2016 04:05 PM, Chris Murphy wrote:
>>> Make certain the kernel command timer value is greater than the driver
>>> error recovery timeout. The former is found in sysfs, per block
>>> device, the latter can be get and set with smartctl. Wrong
>>> configuration is common (it's actually the default) when using
>>> consumer drives, and inevitably leads to problems, even the loss of
>>> the entire array. It really is a terrible default.
>>
>> Since it's first time i've heard of this I did some googling.
>>
>> Here's some nice article about these timeouts:
>> http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-
>> timeouts/comment-page-1/
>>
>> And some udev rules that should apply this automatically:
>> http://comments.gmane.org/gmane.linux.raid/48193
> 
> I think the first link there is a good one.  On my system:
> 
> /sys/block/sdX/device/timeout
> 
> defaults to 30 seconds - long enough for a drive with short TLER setting
> but too short for a consumer drive.
> 
> There is a Red Hat link on setting up a udev rule for it here:
> https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/task_controlling-scsi-command-timer-onlining-devices.html
> 
> I thought it looked a little funny, so I combined the above with one of the
> VMware udev rules pre-installed on my Ubuntu system and came up with this:
> 
> # Update timeout from 180 to one of your choosing:
> ACTION=="add|change", SUBSYSTEMS=="scsi", ATTRS{type}=="0|7|14", \
> RUN+="/bin/sh -c 'echo 180 >/sys$DEVPATH/device/timeout'"
> 

Last line is actually

ATTR{device/timeout}="100"

to avoid spawning extra process for every device.
