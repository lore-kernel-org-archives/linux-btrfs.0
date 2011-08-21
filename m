From: Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH] Btrfs: fix 64 bit divide problem
Date: Sun, 21 Aug 2011 09:19:55 +0200
Message-ID: <20110821071951.GA4013@kernel.org>
References: <1313843391-3904-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	torvalds@linux-foundation.org, liubo2009@cn.fujitsu.com
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313843391-3904-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


* Josef Bacik <josef@redhat.com> wrote:

> This fixes a regression introduced by
> 
> cdcb725c05fe0cb71777c66ddc2445fedbbb3c59
> 
> In cases where we need to divide/multiply by 2 we should just left/right shift
> respectively, and in cases where theres N number of devices use do_div.  Also
> make the counters u64 to match up with rw_devices.  Thanks,
> 
> Signed-off-by: Josef Bacik <josef@redhat.com>

Acked-and-tested-by: Ingo Molnar <mingo@elte.hu>

Thanks,

	Ingo
