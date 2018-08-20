Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:51358 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726197AbeHTPvL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 20 Aug 2018 11:51:11 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <32208.1534767847@warthog.procyon.org.uk>
References: <32208.1534767847@warthog.procyon.org.uk> <20180816130515.GR24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk>
Cc: dhowells@redhat.com, dsterba@suse.cz, clm@fb.com,
        linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Mon, 20 Aug 2018 13:35:41 +0100
Message-ID: <525.1534768541@warthog.procyon.org.uk>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

David Howells <dhowells@redhat.com> wrote:

> Can I get rid of BTRFS_MOUNT_NOSSD as it would appear to be superfluous with
> BTRFS_MOUNT_SSD?

Ah...  I guess it's not quite superfluous:

	if (!btrfs_test_opt(fs_info, NOSSD) &&
	    !fs_info->fs_devices->rotating) {
		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
	}

It appears to be more of a four-state thing: definitely no, maybe no, yes and
yes+spread.

David
