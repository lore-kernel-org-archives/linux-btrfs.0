Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:35622 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751613Ab3JHBvr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Oct 2013 21:51:47 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 34E1C9A0681
	for <linux-btrfs@vger.kernel.org>; Mon,  7 Oct 2013 19:51:47 -0600 (MDT)
Date: Mon, 7 Oct 2013 21:51:45 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Jan Killius <tmpnerd@gmail.com>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: kernel BUG at mm/page-writeback.c:2317!
Message-ID: <20131008015145.GB16461@localhost.localdomain>
References: <CACe732uTQrbVTV_Ov-0U4hLtdx8==2+9uXtzoVxFhteF3rr1ag@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CACe732uTQrbVTV_Ov-0U4hLtdx8==2+9uXtzoVxFhteF3rr1ag@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 08, 2013 at 12:36:11AM +0200, Jan Killius wrote:
> Hello,
> I'm hitting similar bug with the patch from Lui Bo.
> But If I revert: 573aecafca1cf7a974231b759197a1aebcf39c2a,
> Btrfs: actually limit the size of delalloc range) everything works fine.
> 
> Here are the 2 backtraces from my machines with 3.12-rc4:
> http://imgur.com/sVkjGK6,mWUtzMV#0
> http://imgur.com/sVkjGK6,mWUtzMV#1
> 
> Sorry for the screenshots but It was the only way to capture the backtraces.
> I get the bug at the end of a 2GB scp transfer almost everytime.

Well that's just a bummer.  Let me try and see if I can work out what is going
on here.  Thanks,

Josef
