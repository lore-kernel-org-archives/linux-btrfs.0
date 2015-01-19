Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60296 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751465AbbASRp2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 19 Jan 2015 12:45:28 -0500
Date: Mon, 19 Jan 2015 18:45:26 +0100
From: David Sterba <dsterba@suse.cz>
To: Zach Brown <zab@zabbo.net>
Cc: dsterba@suse.cz, Sandy McArthur Jr <sandymac@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs scrub status reports not running when it is
Message-ID: <20150119174525.GC13289@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAPs0BijZX-BcM7uRq58TwSUqsNRqsySXeHYRezgVQcfXw-d22g@mail.gmail.com>
 <20150114222717.GA9900@lenny.home.zabbo.net>
 <20150115112441.GA3685@twin.jikos.cz>
 <20150115180237.GA28510@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150115180237.GA28510@lenny.home.zabbo.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jan 15, 2015 at 10:02:37AM -0800, Zach Brown wrote:
> > > It says that scrub isn't running if any devices have completed.  If you drop
> > > all those ret < 0 conditional branches that are either noops or wrong, does it
> > > work like you'd expect?
> > 
> > Why wrong? The ioctl callback returns -ENODEV or -ENOTCONN that get
> > translated to the errno values and ioctl(...) returns -1 in both cases.
> 
> Wrong because returning 0 on the first ENOTCONN, instead of continuing
> to find more devices which might still be scrubbing, leads to this
> confusing status message.

You're right, fix on the way.
