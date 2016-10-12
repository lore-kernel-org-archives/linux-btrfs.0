Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from email.routify.me ([162.208.10.182]:56101 "EHLO
        cartman.routify.me" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753915AbcJLWaT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 12 Oct 2016 18:30:19 -0400
Date: Wed, 12 Oct 2016 18:29:55 -0400
From: Sean Greenslade <sean@seangreenslade.com>
To: Btrfs List <linux-btrfs@vger.kernel.org>
Subject: Incremental send robustness question
Message-ID: <20161012222955.GB2412@fox.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi, all. I have a question about a backup plan I have involving
send/receive. As far as I can tell, there's no way to to resume a send
that has been interrupted. In this case, my interruption comes from an
overbearing firewall that doesn't like long-lived connections. I'm
trying to do the initial (non-incremental) sync of the first snapshot
from my main server to my backup endpoint. The snapshot is ~900 GiB, and
the internet link is 25 Mbps, so this'll be going for quite a long time.

What I would like to do is "fake" the first snapshot transfer by
rsync-ing the files over. So my question is this: if I rsync a subvolume
(with the -a option to make all file times, permissions, ownerships,
etc. the same), is that good enough to then be used as a parent for
future incremental sends?

And while we're at it, what are the failure modes for incremental sends?
Will it throw an error if the parents don't match, or will there just be
silent failures? I would imagine receive would barf if it was told to
reference a file that didn't exist, but what if the referenced file is
there but contains different data? Are there checks for this sort of
thing, or is it always assumed that the parent subvols are identical and
if they're not, you're in undefined behavior land?

Thanks,

--Sean
