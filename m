Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:9353 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750743Ab2GSBLc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 21:11:32 -0400
Message-ID: <50075EAA.9030806@cn.fujitsu.com>
Date: Thu, 19 Jul 2012 09:11:06 +0800
From: Liu Bo <liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
To: David Sterba <dave@jikos.cz>
CC: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com
Subject: Re: [PATCH v3] Btrfs: improve multi-thread buffer read
References: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com> <20120718115735.GI11226@twin.jikos.cz>
In-Reply-To: <20120718115735.GI11226@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/18/2012 07:57 PM, David Sterba wrote:

> On Mon, Jul 16, 2012 at 02:05:25PM -0400, Liu Bo wrote:
>> v2->v3: adopt kernel native pagevec instead of kmalloc.
> 
> Do we really use the pagevec features here? It looks more like a fancy
> way to employ a simple array ...
> 
> And with a simple array we could use 16 page pointers covering 16 * 4k =
> 64k bytes which looks more friendly than 14 * 4K = 56K (available in a
> pagevec). This may have a negative effect on the troughput, but I
> haven't measured that. Can you please benchmark it against pagevec?
> 


Thanks for the advice.

Yes, it is a simple array that is needed.

Indeed I even tried 128 page array, with which I can get the biggest improvement on my box.
Basically in range [1, 128], the more pages in the array, the bigger improvement we'll get.

But as Chris suggested, my test is really a race case in practical use, half of improvement
is somehow enough, so we turn to use pagevec struct because it is closer to how we solve
similar problems in other parts of the kernel.

thanks,
liubo

> 
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


