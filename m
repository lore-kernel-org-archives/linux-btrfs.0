Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:41962 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753141AbcGDLhO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Jul 2016 07:37:14 -0400
Date: Mon, 4 Jul 2016 13:37:38 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis Henriques <henrix@camandro.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: tests: 001-simple-unmounted: fix test
 failure due to bashism
Message-ID: <20160704113738.GB13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160624234729.GA29145@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160624234729.GA29145@charon>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Jun 25, 2016 at 12:47:29AM +0100, Luis Henriques wrote:
> The usage of 'source' is a bashism, and '.' should be used instead.  This
> is causing fuzz-tests/001-simple-unmounted to fail in systems where
> /bin/sh isn't bash:
> 
>     [TEST/fuzz]   001-simple-unmounted
> ./test.sh: 5: ./test.sh: source: not found
> ./test.sh: 7: ./test.sh: setup_root_helper: not found
> ./test.sh: 8: ./test.sh: check_prereq: not found
> ./test.sh: 18: ./test.sh: check_all_images: not found
> 
> Since most (all?) tests actually use /bin/bash, change this test to use
> bash too.
> 
> Signed-off-by: Luis Henriques <henrix@camandro.org>

Applied, thanks.
