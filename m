Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:43765 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932365Ab3LaArU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Dec 2013 19:47:20 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VxnUM-0003HS-SF
	for linux-btrfs@vger.kernel.org; Tue, 31 Dec 2013 01:47:18 +0100
Received: from 37-4-166-128-dynip.superkabel.de ([37.4.166.128])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 01:47:18 +0100
Received: from hurikhan77+btrfs by 37-4-166-128-dynip.superkabel.de with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 31 Dec 2013 01:47:18 +0100
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Migrate to bcache: A few questions
Date: Tue, 31 Dec 2013 01:31:26 +0100
Message-ID: <vrf9pa-hug.ln1@hurikhan77.spdns.de>
References: <kof6pa-akd.ln1@hurikhan77.spdns.de> <45EA1F82-A774-4729-9279-D58ACF819B05@colorremedies.com> <fgu6pa-f1b.ln1@hurikhan77.spdns.de> <20131230090125.GN19863@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Marc MERLIN <marc@merlins.org> schrieb:

> On Mon, Dec 30, 2013 at 02:22:55AM +0100, Kai Krakow wrote:
>> These thought are actually quite interesting. So you are saying that data
>> may not be fully written to SSD although the kernel thinks so? This is
> 
> That, and worse.
> 
> Incidently, I have just posted on my G+ about this:
> https://plus.google.com/106981743284611658289/posts/Us8yjK9SPs6
> 
> which is mostly links to
> http://lkcl.net/reports/ssd_analysis.html
> https://www.usenix.org/conference/fast13/understanding-robustness-ssds-under-power-fault
> 
> After you read those, you'll never think twice about SSDs and data loss
> anymore :-/
> (I kind of found that out myself over time too, but these have much more
> data than I got myself empirically on a couple of SSDs)

The bad thing here is: Even battery-backed RAID controllers won't help you 
here. I start to understand why I still don't trust this new technology 
entirely.

Thanks,
Kai

