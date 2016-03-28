Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ud10.udmedia.de ([194.117.254.50]:37767 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753198AbcC1OOv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Mar 2016 10:14:51 -0400
Date: Mon, 28 Mar 2016 16:14:46 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Josef Bacik <jbacik@fb.com>
Cc: Dave Jones <davej@codemonkey.org.uk>,
        Linux Kernel <linux-kernel@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs_destroy_inode WARN_ON.
Message-ID: <20160328141446.GB308@x4>
References: <20160324225411.GA1612@codemonkey.org.uk>
 <20160325082526.GA314@x4>
 <56F93A1B.2060701@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56F93A1B.2060701@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016.03.28 at 10:05 -0400, Josef Bacik wrote:
> >Mar 24 10:37:27 x4 kernel: WARNING: CPU: 3 PID: 11838 at fs/btrfs/inode.c:9261 btrfs_destroy_inode+0x22b/0x2a0
> 
> I saw this running some xfstests on our internal kernels but haven't been
> able to reproduce it on my latest enospc work (which is obviously perfect).
> What were you doing when you tripped this?  I'd like to see if I actually
> did fix it or if I still need to run it down.  Thanks,

I cannot really tell. Looking at the backtrace, both Dave and I were
running rm. 
This warning happened just once on my machine, so the issue is obviously
very hard to trigger.

-- 
Markus
