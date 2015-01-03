Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:42163 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038AbbACTDs (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 3 Jan 2015 14:03:48 -0500
Received: by mail-ie0-f169.google.com with SMTP id y20so18150405ier.28
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Jan 2015 11:03:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <54A83A95.2070108@shiftmail.org>
References: <CAAe=sHWT9G9PNYUh8yxG0dS7xCjy0Fhv03GATvkQHq64kM0oBA@mail.gmail.com>
	<54A7D3D1.10508@shiftmail.org>
	<pan$872b8$2e173aaa$59613c61$c4e30dfd@cox.net>
	<54A83A95.2070108@shiftmail.org>
Date: Sat, 3 Jan 2015 13:03:47 -0600
Message-ID: <CAAe=sHVNcCfe-AVBZ1mJV+uYN3F+s6kVQTgv8htw-_WWnK+Q=w@mail.gmail.com>
Subject: Re: I need to P. are we almost there yet?
From: "sys.syphus" <syssyphus@gmail.com>
To: Bob Marley <bobmarley@shiftmail.org>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Which is really not bad, considering the chance that something gets corrupt.
> Already it is an exceedingly rare event. Detection without correction can be
> more than enough. Since always things have worked in the computer science
> field without even the detection feature.
> Most likely even your bank account and mine are held in databases which are
> located in filesystems or blockdevices which do not even have the corruption
> detection feature.
> And, last but not least, as of now a btrfs bug is more likely than hard
> disks' silent data corruption.
>
>

I think thats dangerous thinking and what has gotten us here.

The whole point of zfs / btrfs is that due to the current size of
storage, what was previously unlikely is now a statistical certitude.
In short, Murphy's law.

We are now using green drives and s3 fuse and shitty flash media, the
era of trusting the block device is over.
