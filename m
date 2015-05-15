Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:42369 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753478AbbEOQU7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 15 May 2015 12:20:59 -0400
Message-ID: <55561CE6.3080807@oracle.com>
Date: Sat, 16 May 2015 00:20:54 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Christian <cdysthe@gmail.com>, linux-btrfs@vger.kernel.org
Subject: Re: Mysterious device (id 0).
References: <mj3dg9$h3k$1@ger.gmane.org>
In-Reply-To: <mj3dg9$h3k$1@ger.gmane.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/15/2015 08:09 AM, Christian wrote:
> Hi,
>
> My laptop has a small ext4 /boot partition /dev/sda1 and a large btrfs
> partition containing / and /home as a sub volume /dev/sda3
>
> When I run scrub on /dev/sda3 and check status with sudo btrfs scrub
> status -d /dev/sda3 I get:
>
> scrub status for 3d52dc93-c89f-453f-965d-8601d11e7710
> scrub device /dev/sda3 (id 1) history
>      scrub started at Thu May 14 19:54:02 2015 and finished after 235
> seconds
>      total bytes scrubbed: 111.03GiB with 0 errors
> scrub device  (id 0) history
>      scrub started at Thu May 14 19:54:02 2015 and was aborted after 0
> seconds
>      total bytes scrubbed: 0.00B with 0 errors

  we are reading an uninitialized device struct and that uninitialized
  devid happens to be 0. looks like num_devices count went haywire.

  in this config was there any device delete ? or a reduce in # of
  devices? and has the system been rebooted after that ?

Thanks, Anand


> As device (id 0) is indicated, but I have no idea what it is.
>
> When I run scrub with a script (cron) the same device (id 0) shows up in
> a warning:
>
> /etc/cron.daily/btrfs-scrub:
> WARNING: device 0 not present
> scrub device /dev/sda3 (id 1) done
>      scrub started at Sat May  2 08:03:46 2015 and finished after 241
> seconds
>      total bytes scrubbed: 109.06GiB with 0 errors
> scrub device  (id 0) canceled
>      scrub started at Sat May  2 08:03:46 2015 and was aborted after 0
> seconds
>      total bytes scrubbed: 0.00B with 0 errors
>
> What is this device (id 0) which never gets scrubbed but always shows up?
>
> I'm running Ubuntu 15.04 with the 3.19.0-16-generic kernel.
>
> P.S. I am not a developer.
>
