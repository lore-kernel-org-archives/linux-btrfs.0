Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw8a-maryann.wadns.net ([41.185.62.88]:9558 "EHLO
	fw8a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752613AbaKZNgy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 26 Nov 2014 08:36:54 -0500
Message-ID: <5475D76A.8060603@swiftspirit.co.za>
Date: Wed, 26 Nov 2014 15:36:42 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: bo.li.liu@oracle.com
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com> <1416859665.3019.6@mail.thefacebook.com> <20141125113023.GD23574@localhost.localdomain>
In-Reply-To: <20141125113023.GD23574@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014/11/25 13:30, Liu Bo wrote:
> This is actually inspired by ZFS, who offers checksum functions ranging
> from the simple-and-fast fletcher2 to the slower-but-secure sha256.
>
> Back to btrfs, crc32c is the only choice.
>
> And also for the slowness of sha256, Intel has a set of instructions for
> it, "Intel SHA Extensions", that may help a lot.

I think the advantage will be in giving a choice with some strong 
suggestions:

An example of suggestions - if using sha256 on an old or "low-power" 
CPU, detect that the CPU doesn't support the appropriate acceleration 
functions and print a warning at mount or a warning-and-prompt at mkfs-time.

The default could even be changed based on the architecture - though I 
suspect crc32c is already a good default on most architectures.

The choice allowance gives flexibility where admins know it optimally 
could be used - and David's suggestion (separate thread) would be able 
to take advantage of that.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

