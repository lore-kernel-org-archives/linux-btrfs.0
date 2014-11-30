Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:39938 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbaK3EZC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 29 Nov 2014 23:25:02 -0500
Date: Sat, 29 Nov 2014 20:24:59 -0800
From: Marc MERLIN <marc@merlins.org>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20141130042459.GF8916@merlins.org>
References: <CAH-HCWX--nvGJPZBS=XAAqXeFai_1UiAVv82eqDLacJdes0bAA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAH-HCWX--nvGJPZBS=XAAqXeFai_1UiAVv82eqDLacJdes0bAA@mail.gmail.com>
Subject: Re: Experimental tag in FAQ?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 09:16:38AM +0530, Shriramana Sharma wrote:
> https://btrfs.wiki.kernel.org/index.php/FAQ#Is_btrfs_stable.3F still
> reads experimental whereas the warning has been removed in the tools
> recently IIUC. The FAQ item to be updated, no?

I would say no.
Btrfs is still unstable, still gets changed heavily, and stability/no
data loss doesn't seem to be the prime directive.

Given that, it is experimental still.
And I'm not just saying that, it does break.
3.15 and 3.16.0 had serious stability issues, 3.17.0 also broke other
stuff, and so on (they get fixed later, but if you say btrfs is stable,
users will scream)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
