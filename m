Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:55922 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756626Ab3B0N1j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Feb 2013 08:27:39 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 4E78D9A03DE
	for <linux-btrfs@vger.kernel.org>; Wed, 27 Feb 2013 06:27:39 -0700 (MST)
Date: Wed, 27 Feb 2013 08:27:36 -0500
From: Josef Bacik <jbacik@fusionio.com>
To: Dave Jones <davej@redhat.com>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs crash when low on memory.
Message-ID: <20130227132736.GH19641@localhost.localdomain>
References: <20130227052247.GA20213@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <20130227052247.GA20213@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 26, 2013 at 10:22:47PM -0700, Dave Jones wrote:
> Something I've yet to repeat managed to leak a whole bunch of memory
> while I was travelling, and locked up my workstation.
> 
> When I got home, this was the last thing printed out before it locked up
> (it did make it into the logs thankfully) after a bunch of instances of
> the oom-killers handywork.

Yeah we have a lot of

ptr = kmalloc();
BUG_ON(ptr);

everywhere.  I'll fix this one up but I really need to sit down and go through
all of them and make sure we do the right thing in all these places.  Thanks,

Josef
