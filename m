Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim2.fusionio.com ([66.114.96.54]:54836 "EHLO
	dkim2.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754956Ab3C1NTm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Mar 2013 09:19:42 -0400
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim2.fusionio.com (Postfix) with ESMTP id 614549A069C
	for <linux-btrfs@vger.kernel.org>; Thu, 28 Mar 2013 07:19:42 -0600 (MDT)
Date: Thu, 28 Mar 2013 09:19:39 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: =?iso-8859-1?Q?Sw=E2mi?= Petaramesh <swami@petaramesh.org>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: This time HD LED doesn't come up at all :-(
Message-ID: <20130328131939.GN28030@localhost.localdomain>
References: <51542EB6.7030403@petaramesh.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
In-Reply-To: <51542EB6.7030403@petaramesh.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 28, 2013 at 05:51:18AM -0600, Swâmi Petaramesh wrote:
> (Resending without the attachment which didn't seem to make it thru...)
> 
> Hi folks,
> 
> This time, at reboot, one of my machines won't come up.
> 
> Starting it in "single and verbose" mode shows that BTRFS looks dead (or
> at least seriously wounded) :
> 
> Kernel seems to mount BTRFS, then swap, then sits there doing nothing
> for quite a while (HD LED is OFF).
> 
> Then it starts spitting ugly messages about init being blocked for more
> than 120 seconds, btrfs-cleaner (the same) etc. - please see attached
> screenshot.
> 
> Any clue for getting out of this annoying situation without resorting to
> reinstall from backups ?
> 

Can you capture the output and post it somewhere so I can see it?  Thanks,

Josef
