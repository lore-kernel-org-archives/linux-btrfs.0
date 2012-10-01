Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:35444 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab2JAAKy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Sep 2012 20:10:54 -0400
Date: Mon, 1 Oct 2012 02:10:42 +0200
From: David Sterba <dave@jikos.cz>
To: Itaru Kitayama <kitayama@cl.bb4u.ne.jp>
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: shrink_delalloc check bdi write congested
Message-ID: <20121001001042.GS14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CANW9uyu_-DFmggZUyAc1OOd0knMxEp-O3GPcs_8ZsoXAxm0DZg@mail.gmail.com>
 <20120929162140.GI14582@twin.jikos.cz>
 <CANW9uys+9BHixw-sG3xbH5AyaOCFYW_o5XyAgBTiioczygcsfg@mail.gmail.com>
 <CANW9uytWQ2DmpkAEg+Q=ZOenqdhe=NiRL9=Yq-7-Y6QVXQRFLQ@mail.gmail.com>
 <20120930222916.GK14582@twin.jikos.cz>
 <CANW9uyvdTthEvEwEDJeVRFKNm+3OF+cUS8Y22fmvKokL-Je4-w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CANW9uyvdTthEvEwEDJeVRFKNm+3OF+cUS8Y22fmvKokL-Je4-w@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 01, 2012 at 08:55:28AM +0900, Itaru Kitayama wrote:
> Thank you for your comments. I wanted to fix a lockdep warning on a
> possible deadlock
> case encountered during the xfstests with a scratch space almost full.

This is the known cleaner/writeback deadlock and avoiding writeback
under device congestion may avoid it, but not in all cases and we want
to fix it properly (Miao sent the patches, but they're not merged so
far).

> You are right I encountered the worst scenario you described below, I
> drop this patch and
> I'll look at btrfs_congested_fn more to examine the mechanisms
> implemented there are
> working as expected.

I'm not sure what you want to achieve with the congestion checks (other
than avoid the cleaner deadlock).

david
