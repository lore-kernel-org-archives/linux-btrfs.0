Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:55540 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726743AbeHURDu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Aug 2018 13:03:50 -0400
From: David Howells <dhowells@redhat.com>
In-Reply-To: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com>
References: <4b5b0a92-8a51-e516-b14a-74557b002d71@gmx.com> <20180816130515.GR24025@twin.jikos.cz> <31114.1534417285@warthog.procyon.org.uk> <32208.1534767847@warthog.procyon.org.uk>
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: dhowells@redhat.com, dsterba@suse.cz, clm@fb.com,
        linux-btrfs@vger.kernel.org, wqu@suse.de
Subject: Re: Are the btrfs mount options inconsistent?
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Date: Tue, 21 Aug 2018 14:43:35 +0100
Message-ID: <341.1534859015@warthog.procyon.org.uk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:

> But to be more clear, NOSSD shouldn't be a special case.
> In fact currently NOSSD only affects whether we will output the message
> "enabling ssd optimization", no real effect if I didn't miss anything.

That's not quite true.  In:

	if (!btrfs_test_opt(fs_info, NOSSD) &&
	    !fs_info->fs_devices->rotating) {
		btrfs_set_and_info(fs_info, SSD, "enabling ssd optimizations");
	}

the call to btrfs_set_and_info() will turn on SSD.

What this seems to me is that, normally, SSD will be turned on automatically
unless at least one of the devices is a rotating medium - but this appears to
be explicitly suppressed by the NOSSD option.

David
