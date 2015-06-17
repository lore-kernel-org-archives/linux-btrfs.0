Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52693 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932397AbbFQPlQ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 17 Jun 2015 11:41:16 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1Z5FSa-0006E0-FN
	for linux-btrfs@vger.kernel.org; Wed, 17 Jun 2015 17:41:04 +0200
Received: from c-73-47-108-123.hsd1.ma.comcast.net ([73.47.108.123])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 17:41:04 +0200
Received: from cdysthe by c-73-47-108-123.hsd1.ma.comcast.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Wed, 17 Jun 2015 17:41:04 +0200
To: linux-btrfs@vger.kernel.org
From: Christian <cdysthe@gmail.com>
Subject: Re: trim not working and irreparable errors from btrfsck
Date: Wed, 17 Jun 2015 11:40:33 -0400
Message-ID: <mls4dj$2oh$1@ger.gmane.org>
References: <mlpb8i$dus$1@ger.gmane.org>	<CAJCQCtQGzwQ=L4Vh19tsqSqPoPJuNaLyTo7q0SsbMteb2=tdMw@mail.gmail.com>	<55816E7B.5040905@gmail.com>	<CAJCQCtQnSSATHPkX-NgQVkXHB0Z+VJrt14sMk4bHaoQ4nS=Jcw@mail.gmail.com>	<mls0gb$s7m$1@ger.gmane.org> <CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
In-Reply-To: <CAJCQCtTJU3z4je=CBWDP6qE7_rDt46ivYBs9T1NNj3b-5Fy_PA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/17/2015 11:28 AM, Chris Murphy wrote:

>>
>> However, fstrim still gives me "0 B (0 bytes) trimmed, so that may be
>> another problem. Is there a way to check if trim works?
>
> That sounds like maybe your SSD is blacklisted for trim, is all I can
> think of. So trim shouldn't be the cause of the problem if it's being
> blacklisted. The recent problems appear to be around newer SSDs that
> support queue trim and newer kernels that issue queued trim. There
> have been some patches related to trim to the kernel, but the
> existence of blacklisting and claims of bugs in firmware make it
> difficult to test and isolate.
>
> http://techreport.com/news/28473/some-samsung-ssds-may-suffer-from-a-buggy-trim-implementation
>
This is an Intel SSD in a Lenovo Thinkpad X1 Carbon. Trim worked until a 
few weeks ago and still works for my small ext4 boot partition (just ran 
it to check). I will keep looking for a solution. Thanks!

-- 
//Christian


