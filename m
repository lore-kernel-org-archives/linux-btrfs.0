Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53421 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933975AbdKGVRY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 16:17:24 -0500
Date: Tue, 7 Nov 2017 22:15:31 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com
Subject: Re: [PATCH] btrfs: Reduce scope of delayed_rsv->lock in
 may_commit_trans
Message-ID: <20171107211531.GH27557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1510046574-15541-1-git-send-email-nborisov@suse.com>
 <20171107201804.GD27557@twin.jikos.cz>
 <c38c64d8-4b6b-4bd1-52a5-df9ee7b7cdd6@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <c38c64d8-4b6b-4bd1-52a5-df9ee7b7cdd6@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 07, 2017 at 10:42:26PM +0200, Nikolay Borisov wrote:
> 
> 
> On  7.11.2017 22:18, David Sterba wrote:
> > On Tue, Nov 07, 2017 at 11:22:54AM +0200, Nikolay Borisov wrote:
> >> After commit ('btrfs: change how we decide to commit transactions during
> > 
> > 996478ca9c460886ac1
> 
> That commit is still not pulled by linus so is this id stable?

Oh right, it's in the pending pull request branch. I don't expect any
changes so the id should be stable, but will keep it in mind anyway.
