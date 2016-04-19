Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30448 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753168AbcDSJNU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 19 Apr 2016 05:13:20 -0400
Subject: Re: RAID5 Unable to remove Failing HD
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <CAKUFzr8gm-yN01CY=H_j6jdEXJL5b0A_vS6gJ5iH1YN1+ZJAvg@mail.gmail.com>
 <56BAFC15.6080106@oracle.com> <5714A1F7.3050509@bouton.name>
 <pan$d96e4$2cb56bbb$1d5f6612$721cfc21@cox.net>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <5715F6A0.7030707@oracle.com>
Date: Tue, 19 Apr 2016 17:13:04 +0800
MIME-Version: 1.0
In-Reply-To: <pan$d96e4$2cb56bbb$1d5f6612$721cfc21@cox.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>> # btrfs device delete 3 /mnt/store/
>> ERROR: device delete by id failed: Inappropriate ioctl for device
>>
>> Were the patch sets above for btrfs-progs or for the kernel ?
>
> Looks like you're primarily interested in the concern2 patches, device
> delete by devid.
>
> A quick search of the list back-history reveals that an updated patch
> set, 00/15 now (look for [PATCH 00/15] Device delete by id ), was posted
> by dserba on the 15th of February.  It was the kernel patches and was
> slated for the kernel 4.6 dev cycle.  However, the patch set was pulled
> at that time due to test failures, tho they were suspected to actually be
> from something else.

  Thanks Duncan. Yep the reported issue did not point to any
  of the patch in that set. But I am keeping a tab open for
  new users /test cases, anything that is found will help.

  By the way, For Lionel issue, delete missing should work ?
  which does not need any additional patch.

Thanks, Anand

