Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:46906 "EHLO
	mx0b-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750791AbbHSSmF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 19 Aug 2015 14:42:05 -0400
Date: Wed, 19 Aug 2015 11:41:55 -0700
From: Omar Sandoval <osandov@fb.com>
To: <kreijack@inwind.it>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [BUG][v4.2-rc7] Problem replacing a "missing" disk for a
 raid5-degraded filesystem
Message-ID: <20150819184155.GA25918@huxley.event.rightround.com>
References: <55D4B8B8.3000806@libero.it>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <55D4B8B8.3000806@libero.it>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 19, 2015 at 07:11:20PM +0200, Goffredo Baroncelli wrote:
> Hi all,
> 
> playing with raid5 and "btrfs replace" I found a BUG. Basically it seems that if I try to replace a "missing" disk of a "degraded" filesystem I got a kernel BUG. This is reproducible at 100% for me.

Hi, Goffredo, this is a known bug. I have a fix here:
http://www.spinics.net/lists/linux-btrfs/msg44874.html
I'll bug Chris to get this in for 4.3. Let me know if you feel like
testing it out and I can add your Tested-by.

Btw, just a heads up, Gmail is convinced that you're spam, it sounds
like you're failing your domain's DMARC checks.

Thanks,
-- 
Omar
