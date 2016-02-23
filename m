Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59430 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753599AbcBWOlB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Feb 2016 09:41:01 -0500
Date: Tue, 23 Feb 2016 15:40:51 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Anand Jain <anand.jain@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [bug] unable to handle kernel paging request when running
 btrfs/011
Message-ID: <20160223144051.GM4374@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <56C71B9C.8090700@oracle.com>
 <56C914AC.6030107@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <56C914AC.6030107@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 21, 2016 at 09:36:44AM +0800, Qu Wenruo wrote:
> 
> 
> On 02/19/2016 09:41 PM, Anand Jain wrote:
> >
> >
> >   Saw below warn leading to bug when running btrfs/011, not
> >   reproducible. Any idea ?
> >
> Seems like another wq_destroy race.
> 
> But it's hard to locate which wq is the cause from backtrace only.

Name of the workqueue is in the first stacktrasce, it's readahead. The
crash happens in 'umount'.
