Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:2811 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753735Ab3JFRYj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 6 Oct 2013 13:24:39 -0400
Received: from c-67-165-243-162.hsd1.co.comcast.net ([67.165.243.162]:54019 helo=[192.168.1.126])
	by slmp-550-94.slc.westdc.net with esmtpsa (TLSv1:AES128-SHA:128)
	(Exim 4.80.1)
	(envelope-from <lists@colorremedies.com>)
	id 1VSs4L-001uHr-NT
	for linux-btrfs@vger.kernel.org; Sun, 06 Oct 2013 11:24:38 -0600
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: btrfs device delete problem
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com>
Date: Sun, 6 Oct 2013 11:24:38 -0600
Message-Id: <E44857E1-210F-4F7B-85A1-10DF26E6A552@colorremedies.com>
References: <CAKZ=RP9a6A8ni-4s7WdUWfqUhhRHyFGFVkN42kmYOJqnu=4dyA@mail.gmail.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Oct 6, 2013, at 5:10 AM, Alfredo Esteban <aedelatorre@gmail.com> wrote:
> 
>> btrfs device delete /dev/sdh1 /mnt/raid-data/
> ERROR: error removing the device '/dev/sdh1' - Inappropriate ioctl for device

It's sortof a generic error, I think it's fixed since I haven't seen this recently with newer kernels. What do you get in dmesg? Any other messages at the time this command was issued?

> 
> Raid has been working fine for a long time. Both devices are present
> but /dev/sdh1 is a new empty btrfs partition at the moment.

>From your post:
>> devid    2 size 149.05GB used 109.01GB path /dev/sdh1

109GB used isn't exactly empty.


> I should like to know whether this is an error or "btrfs device
> delete" command is not the appropriate one. I just want to know how to
> delete sdh1 from raid, add a new partition and balance.
> 
> My kernel version is: 3.8.0-31

I'd upgrade the kernel to 3.10.14 or wait for some balance fixes to get into 3.11.x and the next 3.12 rc.


Chris Murphy