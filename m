Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:51127 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753315AbaEPUll (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 16:41:41 -0400
Date: Fri, 16 May 2014 21:41:35 +0100
From: Tomasz Chmielewski <tch@virtall.com>
To: Calvin Walton <calvin.walton@kepstin.ca>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: RAID-1 - suboptimal write performance?
Message-ID: <20140516214135.23fefc39@s9>
In-Reply-To: <1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com>
References: <20140516164815.1c33149b@s9>
	<1400263584.979.17.camel@sasami.ottawa.blindsidenetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 16 May 2014 14:06:24 -0400
Calvin Walton <calvin.walton@kepstin.ca> wrote:

> No comment on the performance issue, other than to say that I've seen
> similar on RAID-10 before, I think.
> 
> > Also, what happens when the system crashes, and one drive has
> > several hundred megabytes data more than the other one?
> 
> This shouldn't be an issue as long as you occasionally run a scrub or
> balance. The scrub should find it and fix the missing data, and a
> balance would just rewrite it as proper RAID-1 as a matter of course.

It's similar (writes to just one drive, while the other is idle) when
removing (many) snapshots. 

Not sure if that's optimal behaviour.

-- 
Tomasz Chmielewski
http://wpkg.org
