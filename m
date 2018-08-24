Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33982 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726673AbeHXPnP (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 24 Aug 2018 11:43:15 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <c79f9ff1-e451-d2b4-a800-738053e47df8@jp.fujitsu.com>
References: <c79f9ff1-e451-d2b4-a800-738053e47df8@jp.fujitsu.com> <22614.1535039351@warthog.procyon.org.uk> <450873e0-2a8a-d757-4c68-f24e6a0466a1@jp.fujitsu.com>
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>
Cc: dhowells@redhat.com, Qu Wenruo <wqu@suse.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs: ctree.h: Fix suspicious rcu usage warning in btrfs_debug_in_rcu()
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Fri, 24 Aug 2018 13:08:51 +0100
Message-ID: <24038.1535112531@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Misono Tomohiro <misono.tomohiro@jp.fujitsu.com> wrote:

> commit 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
> duplicate code") replaces some open coded rcu string handling with macro.
> 
> It turns out that btrfs_debug_in_rcu() is used for the first time and
> the macro lacks lock/unlock of rcu string for non debug case
> (i.e. when message is not printed), leading suspicious RCU usage warning
> when CONFIG_PROVE_RCU is on.
> 
> Fix this by adding a wrapper to call lock/unlock for non debug case too.
> 
> Fixes: 672d599041c8 ("btrfs: Use wrapper macro for rcu string to remove
> duplicate code")
> Reported-by: David Howells <dhowells@redhat.com>
> Signed-off-by: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>

Tested-by: David Howells <dhowells@redhat.com>
