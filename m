Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:60016 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751462AbaLSXSV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 19 Dec 2014 18:18:21 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Sat, 20 Dec 2014 00:18:17 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Josef Bacik <jbacik@fb.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 3.18.0: kernel BUG at fs/btrfs/relocation.c:242!
In-Reply-To: <54949CEA.7020905@fb.com>
References: <e4a8d9ba015981b895919256a2223950@admin.virtall.com>
 <542EE83D.8050701@fb.com>
 <999a300ed462a1e1388aee4d6f03a30e@admin.virtall.com>
 <438e043f73392614d1453892b7fe225c@admin.virtall.com>
 <0f30c49c7d208903ef84e31a928e4051@admin.virtall.com>
 <54949CEA.7020905@fb.com>
Message-ID: <b6f6a562e6b67a3bc28b02237a2878d5@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-12-19 22:47, Josef Bacik wrote:
> On 12/12/2014 09:37 AM, Tomasz Chmielewski wrote:
>> FYI, still seeing this with 3.18 (scrub passes fine on this 
>> filesystem).
>> 
>> # time btrfs balance start /mnt/lxc2
>> Segmentation fault
>> 
> 
> Ok now I remember why I haven't fix this yet, the images you gave me
> restore but then they don't mount because the extent tree is corrupted
> for some reason.  Could you re-image this fs and send it to me and I
> promise to spend all of my time on the problem until its fixed.

(un)fortunately one filesystem stopped crashing on balance with some 
kernel update, and the other one I had crashing on balance was fixed 
with btrfs - so I'm not able to reproduce anymore / produce an image 
which is crashing.

-- 
Tomasz Chmielewski
http://www.sslrack.com
