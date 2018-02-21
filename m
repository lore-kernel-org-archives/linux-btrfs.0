Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45007 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752181AbeBUSjS (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 21 Feb 2018 13:39:18 -0500
Date: Wed, 21 Feb 2018 16:13:38 +0100
From: David Sterba <dsterba@suse.cz>
To: dsterba@suse.cz, Omar Sandoval <osandov@osandov.com>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 00/27] btrfs-progs: introduce libbtrfsutil,
 "btrfs-progs as a library"
Message-ID: <20180221151338.GF1469@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1518720598.git.osandov@fb.com>
 <20180220185048.GR10193@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180220185048.GR10193@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Feb 20, 2018 at 07:50:48PM +0100, David Sterba wrote:
> I have more comments or maybe questions about the future development
> workflow, but at this point the patchset is in a good shape for
> incremental merge.

After removnig the first patch adding subvolume.c (with
linux/btrfs_tree.h) and what depends on it, I'm left with:

Omar Sandoval (4):
      Add libbtrfsutil
      libbtrfsutil: add Python bindings
      libbtrfsutil: add qgroup inheritance helpers
      libbtrfsutil: add filesystem sync helpers

with some context updates. That builds and passes the CI tests.
