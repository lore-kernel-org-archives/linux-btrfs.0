Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:58292 "EHLO
	mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751595Ab3L3JCG (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 04:02:06 -0500
Date: Mon, 30 Dec 2013 01:01:25 -0800
From: Marc MERLIN <marc@merlins.org>
To: Kai Krakow <hurikhan77+btrfs@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Migrate to bcache: A few questions
Message-ID: <20131230090125.GN19863@merlins.org>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de>
 <45EA1F82-A774-4729-9279-D58ACF819B05@colorremedies.com>
 <fgu6pa-f1b.ln1@hurikhan77.spdns.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <fgu6pa-f1b.ln1@hurikhan77.spdns.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 30, 2013 at 02:22:55AM +0100, Kai Krakow wrote:
> These thought are actually quite interesting. So you are saying that data 
> may not be fully written to SSD although the kernel thinks so? This is 

That, and worse.

Incidently, I have just posted on my G+ about this:
https://plus.google.com/106981743284611658289/posts/Us8yjK9SPs6

which is mostly links to
http://lkcl.net/reports/ssd_analysis.html
https://www.usenix.org/conference/fast13/understanding-robustness-ssds-under-power-fault

After you read those, you'll never think twice about SSDs and data loss
anymore :-/
(I kind of found that out myself over time too, but these have much more
data than I got myself empirically on a couple of SSDs)

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
