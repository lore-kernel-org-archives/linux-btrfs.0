Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw6a-delilah.wadns.net ([196.220.39.210]:14502 "EHLO
	fw6a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751982AbaCaLRl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 07:17:41 -0400
Message-ID: <53394EC0.8020007@swiftspirit.co.za>
Date: Mon, 31 Mar 2014 13:17:20 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] lib: add size unit t/p/e to memparse
References: <1396260185-14109-1-git-send-email-guihc.fnst@cn.fujitsu.com>
In-Reply-To: <1396260185-14109-1-git-send-email-guihc.fnst@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 31/03/14 12:03, Gui Hecheng wrote:
> - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> - *	1073741824).  If the number is suffixed with K, M, or G, then
> + *	potentially suffixed with
> + *	%K (for kilobytes, or 1024 bytes),
> + *	%M (for megabytes, or 1048576 bytes),
> + *	%G (for gigabytes, or 1073741824),
> + *	%T (for terabytes, or 1099511627776),
> + *	%P (for petabytes, or 1125899906842624 bytes),
> + *	%E (for exabytes, or 1152921504606846976 bytes).

My apologies, I should have noticed this in your earlier mail. This 
could be updated to specifically refer to the "bi"nary prefixes rather 
than the old SI-conflicting names:
kibibyte, mebibyte, gibibyte, tebibyte, pebibyte, and exbibyte

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

