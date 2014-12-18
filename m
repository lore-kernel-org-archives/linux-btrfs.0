Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38323 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLRAx3 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Dec 2014 19:53:29 -0500
Message-ID: <54922623.50602@oracle.com>
Date: Thu, 18 Dec 2014 08:56:03 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: Florian Uekermann <florian@uekermann.me>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Device only missing if unmounted
References: <708100218.650154.1418123709778.JavaMail.open-xchange@omgreatgod.store> <5487B3FB.4070109@oracle.com> <932711394.78334.1418480696257.JavaMail.open-xchange@patina.store>
In-Reply-To: <932711394.78334.1418480696257.JavaMail.open-xchange@patina.store>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> I checked this for all three devices and num_devices is 4 for all of them.
> The full output is below.

  so now if you mount and run 'btrfs fi show <mnt>' that should tell
  device missing, which then 'btrfs device missing <mnt>' should be
  successful theoretically.

>> It may fail if you are mounting more than one subvol during boot and if
>> you don't have this patch.
>>
>> commit 0f23ae74f589304bf33233f85737f4fd368549eb
>> Author: Chris Mason <clm@fb.com>
>> Date: Thu Sep 18 07:49:05 2014 -0700
>>
>> Revert "Btrfs: device_list_add() should not update list when mounted"
>>
>> This reverts commit b96de000bc8bc9688b3a2abea4332bd57648a49f.
>
> I am running 3.18-rc5+ from linus tree. If I am not mistaken,
>   that commit is his tree in since 3.17-rc6.

  Ah yes. sorry i just missed that point.

