Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35319 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751537AbcCONHZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Mar 2016 09:07:25 -0400
Date: Tue, 15 Mar 2016 14:07:23 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        David Sterba <dsterba@suse.com>
cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org, jack@suse.cz,
        mhocko@suse.cz
Subject: Re: [PATCH 1/2] btrfs: cleaner_kthread() doesn't need explicit
 freeze
In-Reply-To: <alpine.LNX.2.00.1603151126080.3656@cbobk.fhfr.pm>
Message-ID: <alpine.LNX.2.00.1603151400460.3656@cbobk.fhfr.pm>
References: <alpine.LNX.2.00.1603151126080.3656@cbobk.fhfr.pm>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 15 Mar 2016, Jiri Kosina wrote:

> cleaner_kthread() is not marked freezable, and therefore calling 
> try_to_freeze() in its context is a pointless no-op.
> 
> In addition to that, as has been clearly demonstrated by 80ad623edd2d 
> ("Revert "btrfs: clear PF_NOFREEZE in cleaner_kthread()"), it's perfectly 
> valid / legal for cleaner_kthread() to stay scheduled out in an arbitrary 
> place during suspend (in that particular example that was waiting for 
> reading of extent pages), so there is no need to leave any traces of 
> freezer in this kthread.

Given some questions I've received offline, let me clarify a little bit 
more here.

Currently, the try_to_freeze() call is completely useless here, because it 
will never actually try to freeze the kthread (as it's PF_NOFREEZE).

When attempted to make the kthread properly freezable, it turned out (see 
e.g. 80ad623edd2d) that it's actually sleeping in various places during 
suspend for long periods of time (my guess would be that it doesn't really 
matter whether the cleaning happens before or after suspend, but this'd be 
something I'd like to have clarified from btrfs folks).

So in a nutshell, this patch (a) doesn't make things worse, as it's an 
equivalent code transformation (b) brings more sanity to how the kthread 
freezing API is used throughout the kernel.
It might very well be that the code was broken before; but it's not more 
broken after this patch, and the API usage is sane.

The ultimate goal is first to bring some sanity into how the freezer API 
is used throughout the kernel, and then eventually get rid of it 
completely in favor of fs freezing (currently it's not even possible to 
analyze all the uses in the kernel, as there are way too many and most of 
them are totally broken).

-- 
Jiri Kosina
SUSE Labs
