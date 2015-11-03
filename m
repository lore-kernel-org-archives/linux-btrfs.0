Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:49685 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbbKCXbR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 3 Nov 2015 18:31:17 -0500
Date: Tue, 3 Nov 2015 15:31:15 -0800
From: Mark Fasheh <mfasheh@suse.de>
To: Stefan Priebe <s.priebe@profihost.ag>
Cc: Qu Wenruo <quwenruo@cn.fujitsu.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        jbacik@fb.com, Chris Mason <clm@fb.com>
Subject: Re: Regression in: [PATCH 4/4] btrfs: qgroup: account shared subtree
 during snapshot delete
Message-ID: <20151103233115.GF15575@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <56367AE8.9030509@profihost.ag>
 <5636BDA0.4020200@cn.fujitsu.com>
 <20151103192625.GE15575@wotan.suse.de>
 <56390E29.5030702@profihost.ag>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56390E29.5030702@profihost.ag>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 03, 2015 at 08:42:33PM +0100, Stefan Priebe wrote:
> Sorry don't know much about the btrfs internals.
> 
> I just can reproduce this. Switching to a kernel with this patch and
> without. With it takes ages - without it's super fast. I prooved
> this several times by just rebooting to the other kernel.

That's fine, disregard my previous e-mail - I just saw the mail Qu sent me.
There's a problem in the code that the patch calls which is causing your
performance issues. I'll CC you when I put out a fix.

Thanks,
	--Mark


--
Mark Fasheh
