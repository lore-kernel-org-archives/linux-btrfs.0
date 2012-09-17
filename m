Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:34784 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756127Ab2IQPAD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 11:00:03 -0400
Date: Mon, 17 Sep 2012 16:59:57 +0200
From: David Sterba <dave@jikos.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
Message-ID: <20120917145957.GQ17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <5052C5A0.4090803@oracle.com>
 <20120914110432.GE17430@twin.jikos.cz>
 <5056AB8A.6000500@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5056AB8A.6000500@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Sep 17, 2012 at 12:48:10PM +0800, Anand Jain wrote:
> >>  btrfs send introduced a part of code to read kernel-data
> >>  from user-end using pipe. We need this part of code to be
> >>  useable outside of send sub-cmd, so that developing
> >>  service sub-cmd can use it.
> >
> >What's 'service sub-cmd' please?
> 
>   at the moment 'btrfs service history <mnt>|<dev>'
>   to show logs of maintenance.
>   comments/suggestions welcome.

Sorry, but without a more detailed description I can hardly give useful
comments.  The patch looks ok but stands alone, you can post it with
your proposed feature together.

david
