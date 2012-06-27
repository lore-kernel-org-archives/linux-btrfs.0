Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:45780 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752804Ab2F0STi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Jun 2012 14:19:38 -0400
Date: Wed, 27 Jun 2012 14:19:35 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Frederik Himpe <fhimpe@telenet.be>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 3.5.0-rc4: kernel BUG at fs/btrfs/inode.c:3758!
Message-ID: <20120627181934.GA14033@localhost.localdomain>
References: <4FEB41CE.8070205@telenet.be>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FEB41CE.8070205@telenet.be>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 27, 2012 at 11:24:30AM -0600, Frederik Himpe wrote:
> After an unclean shutdown, Linux 3.5-rc4 fails to mount one of my btrfs 
> file systems. This backtrace can be found in the logs:

Fix is in btrfs-next

http://git.kernel.org/?p=linux/kernel/git/josef/btrfs-next.git;a=summary

Thanks,

Josef 
