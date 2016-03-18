Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752215AbcCRR6k (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 18 Mar 2016 13:58:40 -0400
Date: Fri, 18 Mar 2016 18:58:02 +0100
From: David Sterba <dsterba@suse.cz>
To: Hugo Mills <hugo@carfax.org.uk>,
        Btrfs mailing list <linux-btrfs@vger.kernel.org>
Subject: Re: The *right* algorithm for determining the amount of free space
Message-ID: <20160318175802.GE21722@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160311221703.GJ17196@carfax.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160311221703.GJ17196@carfax.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 11, 2016 at 10:17:03PM +0000, Hugo Mills wrote:
>    I know I promised this a while ago and didn't get round to it, but
> Henk's tinkering reminded me of it. I note specifically that the
> algorithm used to give the free space to plain old df gives incorrect
> results -- probably because it's not using the algorithm below.

So the algorithm is supposed to implement btrfs_calc_avail_data_space,
the raid5/6 parts are missing from there, otherwise the structure of the
function follows the proposed algorithm.

>    There is an algorithm that (seems to) give the correct number of
> block groups which can be allocated, given a current allocation state
> of the FS. I haven't been able to prove it correct, but it seems to
> work. Here's some pseudocode for it:

It does sound correct to me. Thanks for writing it up.
