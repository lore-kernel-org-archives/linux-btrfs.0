Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from slmp-550-94.slc.westdc.net ([50.115.112.57]:49325 "EHLO
	slmp-550-94.slc.westdc.net" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1422757Ab3FUFkO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 21 Jun 2013 01:40:14 -0400
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: hang on 3.9, 3.10-rc5
From: Chris Murphy <lists@colorremedies.com>
In-Reply-To: <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
Date: Thu, 20 Jun 2013 23:40:06 -0600
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-Id: <9CF14E27-2366-4C12-8DAF-DAC618C172B2@colorremedies.com>
References: <alpine.DEB.2.00.1306110841550.15858@cobra.newdream.net> <20130618163706.GC19183@localhost.localdomain> <loom.20130618T190955-784@post.gmane.org> <20130621011137.4477.1347@localhost.localdomain> <CAKuK5J3TBDNgHJ_YUWupB4rO_ixG0LnZFE=K5Uo5Wbo=76rT+A@mail.gmail.com>
To: Jon Nelson <jnelson@jamponi.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Jun 20, 2013, at 7:46 PM, Jon Nelson <jnelson@jamponi.net> wrote:

> Is this what you are looking for?

If you're able to reproduce while you're remoted in via ssh, then if you get the dmesg at least you won't have to spend time trying to save it somewhere since you'll have it on the remote system's terminal window.

https://www.kernel.org/doc/Documentation/sysrq.txt

So basically:
echo w > /proc/sysrq-trigger
dmesg




Chris Murphy

