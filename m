Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:58212 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753178Ab3EUNXj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 May 2013 09:23:39 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 9631A7C0687
	for <linux-btrfs@vger.kernel.org>; Tue, 21 May 2013 07:23:38 -0600 (MDT)
Date: Tue, 21 May 2013 09:23:09 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Matteo Fortini <matteo.fortini@gmail.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Regression in kernel v3.9.3
Message-ID: <20130521132309.GL1765@localhost.localdomain>
References: <CAC_9p+9mBbLfPjuL0Rqf=8A0pdqm3LTuxto04H=F--XL6eR+6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAC_9p+9mBbLfPjuL0Rqf=8A0pdqm3LTuxto04H=F--XL6eR+6w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 21, 2013 at 05:53:10AM -0600, Matteo Fortini wrote:
> Hi,
> I just built and installed kernel v3.9.3 (was using v3.9.0 before) and
> if I do a git fetch on a quite small (<1MB) directory, the system
> starts thrashing and I can't even kill -9 git.
> It's a btrfs partition with no fancy mount options (just relatime) on
> a core i7 with 8GB RAM, Debian testing.
> 
> Please tell me if there's any test I can do to help.

Yeah could you try and bisect where the problem starts happening?  3.9.2 was the
only stable version that had btrfs patches in it, so if you could test 3.9.1 and
then 3.9.2 and see if the problem is in either of those that would be good, then
we can be sure wether its even related to the btrfs patches that were sent back.
Thanks,

Josef
