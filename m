Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54523 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752159AbeC3WBB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 18:01:01 -0400
Date: Fri, 30 Mar 2018 23:58:33 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH 0/5] libbtrfsutil: misc fixes
Message-ID: <20180330215833.GX30422@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1522309741.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <cover.1522309741.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 29, 2018 at 12:53:52AM -0700, Omar Sandoval wrote:
> From: Omar Sandoval <osandov@fb.com>
> This is a handful of minor fixes for libbtrfsutil that would be good to
> get in before the release. Patch 1 fixes an issue reported by Tomohiro a
> few weeks back. Patch 2 fixes a memory leak I noticed while writing
> patch 1. Patch 3 makes us use the local mkfs.btrfs so that the tests can
> run on the CI system. Patch 4 fixes an issue I noticed while testing
> that fix. Patch 5 fixes a test failure caused by "btrfs-progs: mkfs: add
> uuid and otime to ROOT_ITEM of, FS_TREE".
> 
> Based on your devel branch. Please apply!

Done, thanks.
