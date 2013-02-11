Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:49393 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757255Ab3BKPNy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Feb 2013 10:13:54 -0500
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id C70027C035D
	for <linux-btrfs@vger.kernel.org>; Mon, 11 Feb 2013 08:13:53 -0700 (MST)
Date: Mon, 11 Feb 2013 10:13:51 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Gordon Manning <jgordon.manning@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: experimental raid5/6 code in git
Message-ID: <20130211151351.GA10679@shiny>
References: <20130202160212.GB4694@shiny>
 <CAM_ZMPCAcKtOH4UapR8HbSN6Woi7Lh7mqy+e14TDY+8tM386iQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
In-Reply-To: <CAM_ZMPCAcKtOH4UapR8HbSN6Woi7Lh7mqy+e14TDY+8tM386iQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 10, 2013 at 03:35:05PM -0700, Gordon Manning wrote:
>    Hi,
>    Is the BTRFS raid code susceptible to RAID-5 write holes? �I think with
>    the original plan, the problem was avoided by always giving full stripe
>    writes to the raid layers. �Does the current plan deal with the hole in a
>    different manner?

The current code in my git tree does not deal with the raid-5 write
hole.  That's the part I'm finishing off now.

-chris
