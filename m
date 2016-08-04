Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38205 "EHLO
	mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932168AbcHDTF1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 4 Aug 2016 15:05:27 -0400
Received: by mail-it0-f48.google.com with SMTP id j124so4262056ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 04 Aug 2016 12:05:27 -0700 (PDT)
Subject: Re: How to stress test raid6 on 122 disk array
To: Martin <rc6encrypted@gmail.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <274e0a56-086f-23c4-7ae9-2b6cb68ec6c8@gmail.com>
Date: Thu, 4 Aug 2016 15:05:10 -0400
MIME-Version: 1.0
In-Reply-To: <CAGQ70Ye3Ly0N5cZHe3_D0RX8yW6ZzcN7fVhoLnnXrPXjOKPa1Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-08-04 13:43, Martin wrote:
> Hi,
>
> I would like to find rare raid6 bugs in btrfs, where I have the following hw:
>
> * 2x 8 core CPU
> * 128GB ram
> * 70 FC disk array (56x 500GB + 14x 1TB SATA disks)
> * 24 FC or 2x SAS disk array (1TB SAS disks)
> * 16 FC disk array (1TB SATA disks)
> * 12 SAS disk array (3TB SATA disks)
>
> The test can run for a month or so.
>
> I prefer CentOS/Fedora, but if someone will write a script that
> configures and compiles a preferred kernel, then we can do that on any
> preferred OS.
>
> Can anyone give recommendations on how the setup should be configured
> to most likely find rare raid6 bugs?
>
> And does there exist a script that is good for testing this sort of thing?
I'm glad to hear there people interested in testing BTRFS for the 
purpose of finding bugs.  Sadly I can't provide much help in this 
respect (I do testing, but it's all regression testing these days).

Regarding OS, I'd avoid CentOS for testing something like BTRFS unless 
you specifically want to help their development team fix issues.  They 
have a large number of back-ported patches, and it's not all that 
practical for us to chase down bugs in such a situation, because it 
could just as easily be a bug introduced by the back-porting process or 
may be fixed in the mainline kernel anyway.  Fedora should be fine 
(they're good about staying up to date), but if possible you should 
probably use Rawhide instead of a regular release, as that will give you 
quite possibly one of the closest distribution kernels to a mainline 
Linux kernel available, and will make sure everything is as up to date 
as possible.

As far as testing, I don't know that there are any scripts for this type 
of thing, you may want to look into dbench, fio, iozone, and similar 
tools though, as well as xfstests (which is more about regression 
testing, but is still worth looking at).

Most of the big known issues with RAID6 in BTRFS at the moment involve 
device failures and array recovery, but most of them aren't well 
characterized and nobody's really sure why they're happening, so if you 
want to look for something specific, figuring out those issues would be 
a great place to start (even if they aren't rare bugs).
