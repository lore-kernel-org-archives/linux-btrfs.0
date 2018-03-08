Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36096 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754052AbeCHP4Y (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 8 Mar 2018 10:56:24 -0500
Date: Thu, 8 Mar 2018 16:54:01 +0100
From: David Sterba <dsterba@suse.cz>
To: Filipe Manana <fdmanana@gmail.com>
Cc: David Sterba <dsterba@suse.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 18/22] btrfs: move allocation after simple tests in
 tree_mod_log_insert_key
Message-ID: <20180308155401.GN23693@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1520518876.git.dsterba@suse.com>
 <0792f4331c42c57426d02f897bc68b7c7820219a.1520518876.git.dsterba@suse.com>
 <CAL3q7H5ozx0vyDQxY+H7JJNRu2JhuKmR+QS2MLYpXO9=BMjtZQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAL3q7H5ozx0vyDQxY+H7JJNRu2JhuKmR+QS2MLYpXO9=BMjtZQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 08, 2018 at 03:26:11PM +0000, Filipe Manana wrote:
> On Thu, Mar 8, 2018 at 2:33 PM, David Sterba <dsterba@suse.com> wrote:
> > The allocation of tree_mod_elem can be delayed after tree_mod_dont_log.
> > In case it causes the function to return, the allocation would be
> > redundant. Otherwise it could cause unnecessary failure if there's not
> > enough memory.
> 
> Nop, the allocation must be made before calling tree_mod_dont_log(),
> as that function acquires a write lock.
> That's why there's a call to tree_mod_need_log() before the allocation
> and a call to tree_mod_dont_log() after (they do the same checks).

Ah right, thanks, it's even documented, dunno why I missed it.
