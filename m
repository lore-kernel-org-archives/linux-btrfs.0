Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933862AbeCGQYh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 7 Mar 2018 11:24:37 -0500
Date: Wed, 7 Mar 2018 17:22:15 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs: qgroup: Fix root item corruption when multiple
 same source snapshiots are created with quota enabled
Message-ID: <20180307162215.GK23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171219074454.2874-1-wqu@suse.com>
 <CAL3q7H5F36cvDh63PaedAXcarE8EftUj6-QAMqoARh-p2DikHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5F36cvDh63PaedAXcarE8EftUj6-QAMqoARh-p2DikHA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 02, 2018 at 11:45:46AM +0000, Filipe Manana wrote:
> On Tue, Dec 19, 2017 at 7:44 AM, Qu Wenruo <wqu@suse.com> wrote:
> > When multiple pending snapshots referring the same source subvolume are
> > executed, enabled quota will cause root item corruption, where root
> > items are using old bytenr (no backref in extent tree).
> >
> > This can be triggered by fstests btrfs/152.
> >
> > The cause is when source subvolume is still dirty, extra commit
> > (simplied transaction commit) of qgroup_account_snapshot() can skip
> > dirty roots not recorded in current transaction, making root item of
> > source subvolume not updated.
> >
> > Fix it by forcing recording source subvolume in current transaction
> > before qgroup sub-transaction commit.
> >
> > Reported-by: Justin Maggard <jmaggard@netgear.com>
> > Signed-off-by: Qu Wenruo <wqu@suse.com>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

I overlooked the patch, sorry. Added to next now, thanks.
