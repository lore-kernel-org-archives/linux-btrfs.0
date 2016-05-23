Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47283 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932171AbcEWLAH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 May 2016 07:00:07 -0400
Date: Mon, 23 May 2016 12:59:30 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <josef@toxicpanda.com>
Cc: fdmanana@kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/6] Btrfs: fix race between readahead and device
 replace/removal
Message-ID: <20160523105930.GI29147@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1463719450-30601-1-git-send-email-fdmanana@kernel.org>
 <CAEzrpqdTitp=RXyV8VF5bvvg0b5_wojyTCsTrEn1JcrbBRYC0w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAEzrpqdTitp=RXyV8VF5bvvg0b5_wojyTCsTrEn1JcrbBRYC0w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 20, 2016 at 11:11:57AM -0400, Josef Bacik wrote:
> On Fri, May 20, 2016 at 12:44 AM,  <fdmanana@kernel.org> wrote:
> > So fix this by taking the device_list_mutex in the readahead code. We
> > can't use here the lighter approach of using a rcu_read_lock() and
> > rcu_read_unlock() pair together with a list_for_each_entry_rcu() call
> > because we end up doing calls to sleeping functions (kzalloc()) in the
> > respective code path.
> 
> I think it might be time to change this to a rwsem as well as we use
> it in a bunch of places that are read only like statfs and readahead.
> But this works for now.

Sounds good to me.
