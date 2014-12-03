Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37432 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751124AbaLCTMk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Dec 2014 14:12:40 -0500
Date: Wed, 3 Dec 2014 20:12:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Shriramana Sharma <samjnaa@gmail.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141203191240.GZ12140@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
 <547D663A.3020201@jp.fujitsu.com>
 <CAH-HCWV8upw8prPvCiJcpL2NRmuiWaAM+5ZEayD3OoEZrcsyaw@mail.gmail.com>
 <547E5544.7090907@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <547E5544.7090907@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Dec 03, 2014 at 09:11:48AM +0900, Satoru Takeuchi wrote:
> It's not a Btrfs itself's feature. It's a snapper's feature.
> It works as a helper of snapshot management.
> 
> 1. You takes /snap by "snapper create" command.
> 2. You delete /snap by "snapper delete" command by mistake.
>     Then snapper takes a "pre" snapshot just before deleting
>     /snap.
> 3. Now /snap is deleted, however, a "pre" snapshot which is
>     the same as /snap before deleting, is still alive.

Can you please post exact commands how you achieve that?

The 'create' subcommand may take a --type parameter, without it it
creates 'single', and does not create pre or post snapshots
automatically.
