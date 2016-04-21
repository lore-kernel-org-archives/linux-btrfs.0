Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:38395 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751565AbcDURll (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 13:41:41 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1atIbZ-0003Qd-GD
	for linux-btrfs@vger.kernel.org; Thu, 21 Apr 2016 19:41:29 +0200
Received: from p50908ea2.dip0.t-ipconnect.de ([80.144.142.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 19:41:29 +0200
Received: from matthias by p50908ea2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 19:41:29 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 21 Apr 2016 19:40:10 +0200
Message-ID: <nfb39q$iv0$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
 <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
 <nf9o32$7r4$1@ger.gmane.org>
 <180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <180d89ae-32cf-ad59-2b6e-56ed82e9f439@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 21.04.2016 um 07:43 schrieb Qu Wenruo:
> There are already unmerged patches which will partly do the mdadm level behavior, like automatically change to degraded mode without making the fs RO.
> 
> The original patchset:
> http://comments.gmane.org/gmane.comp.file-systems.btrfs/48335

The description of thix patch says: 

"Although the one-size-fit-all solution is quite safe, it's too strict if
data and metadata has different duplication level." 
...
"This patchset will introduce a new per-chunk degradable check for btrfs,
allow above case to succeed, and it's quite small anyway."


My raid1 is "-m raid1 -d raid1". Both the same duplication level. Would that patch make any difference?

And: What do I need to do to test this in "debian stable"? I am not a programmer - but I know how to use git and how to compile with proper configuration directions.

Matthias


> Or the latest patchset inside Anand Jain's auto-replace patchset:
> http://thread.gmane.org/gmane.comp.file-systems.btrfs/55446
> 
> Thanks,
> Qu
>>
>>
>> -- 
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
> 
> 
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


