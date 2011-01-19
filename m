From: Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] Btrfs: Fix page count calculation
Date: Tue, 18 Jan 2011 20:15:58 -0500
Message-ID: <1295399733-sup-2734@think>
References: <4D352670.4040603@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: "Yan, Zheng" <zheng.z.yan@linux.intel.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4D352670.4040603@linux.intel.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Yan, Zheng's message of 2011-01-18 00:34:40 -0500:
> take offset of start position into account when calculating page count.

Thanks Yan, do you have a test case that exposes this?  I'd like to add
it to xfsqa if it makes sense.

-chris
