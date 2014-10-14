Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from extserverfr1.prnet.org ([188.165.43.41]:44941 "EHLO
	extserverfr1.prnet.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751076AbaJNRWO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Oct 2014 13:22:14 -0400
Message-ID: <543D5BC3.9080008@prnet.org>
Date: Tue, 14 Oct 2014 19:22:11 +0200
From: David Arendt <admin@prnet.org>
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, linux-btrfs@vger.kernel.org
Subject: Re: Random file system corruption in 3.17 (not BTRFS related...?)
References: <543D555B.50708@pobox.com>
In-Reply-To: <543D555B.50708@pobox.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I didn't notice a corruption on other filesystems with kernel 3.17.0. 
Also I didn't experience any hangs except when trying to mount a 
corrupted btrfs but this was causing a hang within less than 10 seconds. 
It could be that your problem is unrelated and that the corruption you 
are experiencing is due to an unrelated hang followed by a hard 
powerdown. Have you been able to capture any btrfs related kernel panics ?

On 10/14/14 6:54 PM, Robert White wrote:
> Howdy,
>
> So I run several gentoo systems and I upgraded two of them to kernel 
> 3.17.0
>
> One using BTRFS for root.
> One using ext3 for root (via the ext4 driver)
>
> _Both_ systems exhibited strange behavior (long pauses and then hangs 
> requiring hard-power) within several hours. Both then had random 
> filesystem damage.
>
> On the BTRFS system much of my browser settings for firefox were 
> trashed, particularly the cookies and saved conifigurations for 
> add-ons (like which sites had scripts enabled/disabled in no-script) etc.
>
> On the ext3/4 system there were several corruptions including a 
> pipe/special file with a large non-zero size that required I do a 
> "fsck -fyD /dev/sda3" to repair. (one comment from fsck was that the 
> pipe/special file "looked like a directory" or some such)
>
> So I can say that corruption is taking place, but I suspect it is 
> _not_ happening in the BTRFS specific code.
>
> (ASIDE: both systems are older amd64 using built-in radeon display 
> hardware.)
>
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

