Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751594AbbJGITq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 7 Oct 2015 04:19:46 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1Zjjwu-0001t8-8o
	for linux-btrfs@vger.kernel.org; Wed, 07 Oct 2015 10:19:44 +0200
Received: from host-78-149-212-66.as13285.net ([78.149.212.66])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2015 10:19:44 +0200
Received: from samtygier by host-78-149-212-66.as13285.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 07 Oct 2015 10:19:44 +0200
To: linux-btrfs@vger.kernel.org
From: sam tygier <samtygier@yahoo.co.uk>
Subject: Re: [PATCH v2] Btrfs: Check metadata redundancy on balance
Date: Wed, 07 Oct 2015 09:19:32 +0100
Message-ID: <5614D594.50905@yahoo.co.uk>
References: <muotgb$4mf$1@ger.gmane.org> <5611E169.1060902@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <5611E169.1060902@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 05/10/15 03:33, Anand Jain wrote:
> 
> Sam,
> 
> On 10/03/2015 11:50 PM, sam tygier wrote:
>> Currently BTRFS allows you to make bad choices of data and
>> metadata levels. For example -d raid1 -m raid0 means you can
>> only use half your total disk space, but will loose everything
>> if 1 disk fails. It should give a warning in these cases.
> 
>   Nice test case. however the way we calculate the impact of
>   lost device would be per chunk, as in the upcoming patch -set.
> 
>      PATCH 1/5] btrfs: Introduce a new function to check if all chunks a OK for degraded mount
> 
>   The above patch-set should catch the bug here. Would you be able to
>   confirm if this patch is still needed Or apply your patch on top of
>   it ?
> 
> Thanks, Anand
> 

If I understand the per-chunk work correctly it is to handle the case 
where although there are not enough disks remaining to guarantee being
able to mount degraded, the arrangement of existing chunks happens to 
allow it (e.g. all the single chunks happen to be on a surviving disk).
So while the example case in "[PATCH 0/5] Btrfs: Per-chunk degradable 
check", can survive a 1 disk loss, the raid levels do not guarantee
survivability of a 1 disk loss after more data is written.

My patch is preventing combinations of raid levels that have poor 
guarantees when loosing disks, but waste disk space. For example
data=raid1 metadata=single, which wastes space by writing the data
twice, but would not guarantee survival of a 1 disk loss (even if the
per-chuck patches allow some 1 disk losses to survive) and could loose
everything if a bit flip happened in a critical metadata chunk.

So I think my patch is useful with or without per-chunk work.

Thanks,
Sam

