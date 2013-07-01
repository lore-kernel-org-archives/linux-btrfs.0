Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:43095 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3GAMyi (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Jul 2013 08:54:38 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 2ADA57C0428
	for <linux-btrfs@vger.kernel.org>; Mon,  1 Jul 2013 06:54:38 -0600 (MDT)
Date: Mon, 1 Jul 2013 08:54:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Zach Brown <zab@redhat.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130701125435.GE4288@localhost.localdomain>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1370384280-28652-1-git-send-email-zab@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 04, 2013 at 06:17:54PM -0400, Zach Brown wrote:
> Hi gang,
> 
> I finally sat down to fix that readdir hang that has been in the back
> of my mind for a while.  I *hope* that the fix is pretty simple: just
> don't manufacture a fake f_pos, I *think* we can abuse f_version as an
> indicator that we shouldn't return entries.  Does this look reasonable?
> 
> We still have the problem that we can generate valid large f_pos values
> that can confuse 32bit userspace, but that's a different problem.  I
> think we'll want filldir generation of EOVERFLOW like what exists for
> large inodes. 
> 
> The rest of the patches are cleanups that I saw when absorbing the
> code.  It's all lightly tested with xfstests but it wouldn't surprise
> me if I missed something so review is appreciated.
> 
> Thanks!
> 

One of these patches is making new entries not show up in readdir.  This was
discovered while running stress.sh overnight, it complained about files not
matching but when they were checked the files matched.  Dropping the entire
series made stress.sh run fine.  So I'm dropping these for the next merge window
but I'll dig into it and try and figure out what was causing the problem.
Thanks,

Josef
