Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:16892 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1750946AbaDABRr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 31 Mar 2014 21:17:47 -0400
Message-ID: <1396314824.20427.1.camel@localhost.localdomain>
Subject: Re: [PATCH] lib: add size unit t/p/e to memparse
From: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
To: Brendan Hide <brendan@swiftspirit.co.za>
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org
Date: Tue, 01 Apr 2014 09:13:44 +0800
In-Reply-To: <53394EC0.8020007@swiftspirit.co.za>
References: <1396260185-14109-1-git-send-email-guihc.fnst@cn.fujitsu.com>
	 <53394EC0.8020007@swiftspirit.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 2014-03-31 at 13:17 +0200, Brendan Hide wrote:
> On 31/03/14 12:03, Gui Hecheng wrote:
> > - *	potentially suffixed with %K (for kilobytes, or 1024 bytes),
> > - *	%M (for megabytes, or 1048576 bytes), or %G (for gigabytes, or
> > - *	1073741824).  If the number is suffixed with K, M, or G, then
> > + *	potentially suffixed with
> > + *	%K (for kilobytes, or 1024 bytes),
> > + *	%M (for megabytes, or 1048576 bytes),
> > + *	%G (for gigabytes, or 1073741824),
> > + *	%T (for terabytes, or 1099511627776),
> > + *	%P (for petabytes, or 1125899906842624 bytes),
> > + *	%E (for exabytes, or 1152921504606846976 bytes).
> 
> My apologies, I should have noticed this in your earlier mail. This 
> could be updated to specifically refer to the "bi"nary prefixes rather 
> than the old SI-conflicting names:
> kibibyte, mebibyte, gibibyte, tebibyte, pebibyte, and exbibyte
Yes, indeed, I will send a V2.

Thanks!
-Gui


