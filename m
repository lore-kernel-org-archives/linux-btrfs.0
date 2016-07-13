Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38118 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751305AbcGMNfc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Jul 2016 09:35:32 -0400
Date: Wed, 13 Jul 2016 15:35:10 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Anatoly Pugachev <matorola@gmail.com>,
        Feifei Xu <xufeifei@linux.vnet.ibm.com>
Subject: Re: [PATCH] Btrfs: fix extent buffer bitmap tests on big-endian
 systems
Message-ID: <20160713133510.GL10595@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e6dc753c434a6570251d68d4233d05e6fa84ac67.1468365157.git.osandov@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <e6dc753c434a6570251d68d4233d05e6fa84ac67.1468365157.git.osandov@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 12, 2016 at 04:21:48PM -0700, Omar Sandoval wrote:
> +		for (j = 0; j < BITS_PER_LONG; j++) {
> +			if (x & (1 << j)) {

			if (x & (1UL << j)) {
