Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sender163-mail.zoho.com ([74.201.84.163]:24921 "EHLO
	sender163-mail.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751708AbcFEQdk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 5 Jun 2016 12:33:40 -0400
From: "James Johnston" <johnstonj.public@codenest.com>
To: "'Mladen Milinkovic'" <maxrd2@smoothware.net>,
        "'Chris Murphy'" <lists@colorremedies.com>,
        "'Austin S. Hemmelgarn'" <ahferroin7@gmail.com>
Cc: "'Martin'" <rc6encrypted@gmail.com>,
        "'Btrfs BTRFS'" <linux-btrfs@vger.kernel.org>
References: <CAGQ70Yc=HHxJspMCKFBpEURRu=53pZW3k3rVDVO3QPGP_b9Tkw@mail.gmail.com> <aeade1fe-825c-6fc2-7f6d-85f4c5400b38@gmail.com> <CAJCQCtQ4i0PWisxi708EmrTuPHH7hNEkKfY28GjTG2s4Sk3DYQ@mail.gmail.com> <73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
In-Reply-To: <73123a36-6502-d735-c813-fce43b620e5a@smoothware.net>
Subject: RE: Recommended why to use btrfs for production?
Date: Sun, 5 Jun 2016 16:33:34 -0000
Message-ID: <0aaf01d1bf48$020d4670$0627d350$@codenest.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/05/2016 10:46 AM, Mladen Milinkovic wrote:
> On 06/03/2016 04:05 PM, Chris Murphy wrote:
> > Make certain the kernel command timer value is greater than the driver
> > error recovery timeout. The former is found in sysfs, per block
> > device, the latter can be get and set with smartctl. Wrong
> > configuration is common (it's actually the default) when using
> > consumer drives, and inevitably leads to problems, even the loss of
> > the entire array. It really is a terrible default.
> 
> Since it's first time i've heard of this I did some googling.
> 
> Here's some nice article about these timeouts:
> http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-
> timeouts/comment-page-1/
> 
> And some udev rules that should apply this automatically:
> http://comments.gmane.org/gmane.linux.raid/48193

I think the first link there is a good one.  On my system:

/sys/block/sdX/device/timeout

defaults to 30 seconds - long enough for a drive with short TLER setting
but too short for a consumer drive.

There is a Red Hat link on setting up a udev rule for it here:
https://access.redhat.com/documentation/en-US/Red_Hat_Enterprise_Linux/5/html/Online_Storage_Reconfiguration_Guide/task_controlling-scsi-command-timer-onlining-devices.html

I thought it looked a little funny, so I combined the above with one of the
VMware udev rules pre-installed on my Ubuntu system and came up with this:

# Update timeout from 180 to one of your choosing:
ACTION=="add|change", SUBSYSTEMS=="scsi", ATTRS{type}=="0|7|14", \
RUN+="/bin/sh -c 'echo 180 >/sys$DEVPATH/device/timeout'"

Now my attached drives automatically get this timeout without any scripting
or manual setting of the timeout.

James


