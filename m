Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:43911 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399AbaLXPmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 24 Dec 2014 10:42:19 -0500
Message-ID: <549ADF7D.2030505@oracle.com>
Date: Wed, 24 Dec 2014 23:45:01 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Florian Uekermann <florian@uekermann.me>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Device only missing if unmounted
References: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store> <5487B3FB.4070109@oracle.com> <932711394.78334.1418480696257.JavaMail.open-xchange@patina.store> <54922623.50602@oracle.com> <1184043001.122994.1419096721838.JavaMail.open-xchange@ptangptang.store>
In-Reply-To: <1184043001.122994.1419096721838.JavaMail.open-xchange@ptangptang.store>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Very strange, user space reads num_device as 4 but kernel
reads it as 3 (total_device), thus a device missing when
mounted.
Not sure what kind of hardware at your end, Can cache be
issue ? could you drop cache and check for me.
  echo 3 > /proc/sys/vm/drop_cache

Thanks, Anand

On 21/12/2014 01:32, Florian Uekermann wrote:
>
>  > > I checked this for all three devices and num_devices is 4 for all
> of them.
>  > > The full output is below.
>  >
>  > so now if you mount and run 'btrfs fi show <mnt>' that should tell
>  > device missing, which then 'btrfs device missing <mnt>' should be
>  > successful theoretically.
>
> No it doesn't. It says:
> root@oot:/home/shared# btrfs device delete missing /srv/storage/
> ERROR: error removing the device 'missing' - no missing devices found to
> remove
> and btrfs fi show /srv/storage doesn't report a missing device either
> (after mount).
> This behavior is the reason why I wrote here in the first place. It
> seems like a bug to me.
> Could the btrfs command line utility be the problem here (I am using the
> version the upcoming debian 8 ships)?
> Best regards,
> Florian
