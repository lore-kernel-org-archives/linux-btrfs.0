Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:58871 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751282AbcDUFWx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Apr 2016 01:22:53 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
	id 1at74j-0006yP-OL
	for linux-btrfs@vger.kernel.org; Thu, 21 Apr 2016 07:22:49 +0200
Received: from p50908ea2.dip0.t-ipconnect.de ([80.144.142.162])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 07:22:49 +0200
Received: from matthias by p50908ea2.dip0.t-ipconnect.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Apr 2016 07:22:49 +0200
To: linux-btrfs@vger.kernel.org
From: Matthias Bodenbinder <matthias@bodenbinder.de>
Subject: Re: Question: raid1 behaviour on failure
Date: Thu, 21 Apr 2016 07:22:42 +0200
Message-ID: <nf9o32$7r4$1@ger.gmane.org>
References: <nf1q0j$ug4$1@ger.gmane.org> <57148B2E.6010904@cn.fujitsu.com>
 <nf73cv$7vh$1@ger.gmane.org>
 <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <9ade4472-c99d-82a8-27c9-704b75bd87ab@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 20.04.2016 um 09:25 schrieb Qu Wenruo:

> 
> Unfortunately, this is the designed behavior.
> 
> The fs is rw just because it doesn't hit any critical problem.
> 
> If you try to touch a file and then sync the fs, btrfs will become RO immediately.
> 
....

> Btrfs fails to read space cache, nor make a new dir.
> 
> The failure on cow_block in mkdir is ciritical, and btrfs become RO.
> 
> All expected behavior so far.
> 
> You may try use degraded mount option, but AFAIK it may not handle case like yours.

This really scares me. "Expected bevahour"? 
So you are saying: If one of the drives in the raid1 is going dead without noticing btrfs, the redundancy is lost. 

Lets say, the power unit of a disc is going dead. This disc will disappear from the raid1 pretty much as suddenly as in my test case here. No difference.

You are saying that in this case, btrfs should exactly behave like this? If that is the case I eventually need to rethink my interpretation of redundancy.

Matthias



