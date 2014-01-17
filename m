Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37639 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751701AbaAQOg0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 17 Jan 2014 09:36:26 -0500
Date: Fri, 17 Jan 2014 15:36:24 +0100
From: David Sterba <dsterba@suse.cz>
To: ivo.welch@gmail.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs FAQ
Message-ID: <20140117143624.GU6498@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPr7RtX2NGWssKd=Z8MHt4QpfHt+uUy3wyVcwCSpKwTTE7J2dg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPr7RtX2NGWssKd=Z8MHt4QpfHt+uUy3wyVcwCSpKwTTE7J2dg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 16, 2014 at 08:02:58PM -0800, ivo welch wrote:
> FAQ:
> 
> [1] where should I send FAQ questions or suggestions?

Good question, we need some place for that. Do you think that a section
on the FAQ page would be good enough? I'm not the right person to judge
that, my POV is different.

> [2] mixed HDD and SSD setups are becoming very common.  hybrid drives
> even have two partitions.  is it possible to use the HDD to keep
> backup sector information for crc scrubbing?  I do not want to RAID1
> the SSD with the HDD for obvious speed reasons.  rather, I want to use
> the HDD as an asynchronously-updated less important quasi-backup
> location for SSD sectors to protect against bitrot.

Nothing of that sort is implemented ATM.
