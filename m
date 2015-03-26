Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [63.223.84.64] ([63.223.84.64]:55254 "EHLO vkenny.zootboy.com"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752124AbbCZCTf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 22:19:35 -0400
Date: Wed, 25 Mar 2015 21:10:54 -0500
From: Sean Greenslade <sean@seangreenslade.com>
To: Anand Patil <anand.prabhakar.patil@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Metadata about to fill up, how to make it bigger next time?
Message-ID: <20150326021054.GA28470@coach.innovationfirst.com>
References: <CAFzWkZGytSfhvx8zts=pwBseua-Hdpp+ZXmDPNLrpwJqhiaU_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAFzWkZGytSfhvx8zts=pwBseua-Hdpp+ZXmDPNLrpwJqhiaU_A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 25, 2015 at 04:45:09PM -0700, Anand Patil wrote:
> Hi everyone,
> 
> When I run btrfs fi df /path/to/fs, I see:
> 
> Data, single: total=53.01GiB, used=51.79GiB
> System, DUP: total=32.00MiB, used=16.00KiB
> Metadata, DUP: total=16.00GiB, used=14.72GiB
> 
> My most pressing question is, does that metadata line really mean that
> the filesystem is going to become unusable soon?

No. If you total up your allocations, you will notice that you have
~69GiB allocated, far shy of your total 1000GiB available. BTRFS
allocates in chunks as needed, so once it needs more space for metadata,
it will allocate some. You only get into trouble if there is no free
space to allocate from, and you are far from having that issue.

--Sean
