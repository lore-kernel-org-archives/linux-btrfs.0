Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40418 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448AbcGHK23 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 8 Jul 2016 06:28:29 -0400
Date: Fri, 8 Jul 2016 12:28:46 +0200
From: David Sterba <dsterba@suse.cz>
To: Luis Henriques <henrix@camandro.org>
Cc: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH] btrfs-progs: tests: 006-image-on-missing-device: fix
 btrfs tool path
Message-ID: <20160708102846.GD13336@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20160704224838.GA18686@charon>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20160704224838.GA18686@charon>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 04, 2016 at 11:48:47PM +0100, Luis Henriques wrote:
> If btrfs isn't in the path, this test will fail with:
> 
>     [TEST/misc]   006-image-on-missing-device
> failed: btrfs fi show /dev/loop0
> test failed for case 006-image-on-missing-device
> Makefile:226: recipe for target 'test-misc' failed
> make: *** [test-misc] Error 1
> 
> Fix the test script by adding $TOP to the path.
> 
> Signed-off-by: Luis Henriques <henrix@camandro.org>

Applied, thanks.
