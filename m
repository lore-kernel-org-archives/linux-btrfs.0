Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:60693 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755937Ab2HFUZa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 Aug 2012 16:25:30 -0400
Date: Mon, 6 Aug 2012 16:25:27 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Alexander Block <ablock84@googlemail.com>
CC: "Chris L. Mason" <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Btrfs send/receive fixes and PULL request
Message-ID: <20120806202527.GG8417@shiny>
References: <CAB9VWqBk9CMHhJKq1rOeDXwDmoEVW7LiLCdbb+rbxmM--LOUKA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAB9VWqBk9CMHhJKq1rOeDXwDmoEVW7LiLCdbb+rbxmM--LOUKA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 02, 2012 at 03:55:18AM -0600, Alexander Block wrote:
> Hello Chris,
> 
> You can find and pull a lot of fixes for btrfs send/receive in my git repo:
> 
>         git://github.com/ablock84/linux-btrfs.git for-chris
> 
> These fixes are mostly the results of the reviews from Arne and Alex
> that I got here on the list. I'm not posting the patches to the list
> at the moment as they got quite a lot (23 patches). If anyone thinks I
> should still post them, please tell me. The branch is based on current
> master of Linus repo. As I already announced, I won't have time to
> work on btrfs starting from now.

Great, I'm pulling these in now.  For any future pulls, please do them
against my tree instead of Linus' git.  That way we can play with the
latest btrfs code on top of the current stable kernel, instead of the
devel kernel.

I'm rebasing this one against my current tree.

-chris

