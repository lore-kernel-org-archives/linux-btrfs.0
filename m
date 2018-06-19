Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51978 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S965688AbeFSOuv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Jun 2018 10:50:51 -0400
Date: Tue, 19 Jun 2018 16:47:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dsterba@suse.cz,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: About more loose parameter sequence requirement
Message-ID: <20180619144758.GR24375@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <dbd36f90-fb00-0da1-b38f-567575c5b02f@gmx.com>
 <20180618113432.GJ24375@twin.jikos.cz>
 <f746bf72-148d-9fc3-6d0d-c7e07f00c099@gmx.com>
 <20180618120200.GK24375@twin.jikos.cz>
 <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <48a89b08-3859-e635-1da2-ce7c9e842d8a@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 18, 2018 at 09:05:59PM +0800, Qu Wenruo wrote:
> > New code needs to be tested, documented and maintained, that's the cost
> > I find too high for something that's convenience for people who are used
> > to some shell builtins.
> 
> The biggest problem is, the behavior isn't even consistent across
> btrfs-progs.
> mkfs.btrfs accept such out-of-order parameters while btrfs not.
> 
> And most common tools, like commands provided by coretutil, they don't
> care about the order.
> The only daily exception is 'scp', which I found it pretty unhandy.
> 
> And just as Paul and Hugo, I think there are quite some users preferring
> out-of-order parameter/options.

Because of the feedback and interest of the relaxed mixed
option/argument syntax, I don't object anymore.
