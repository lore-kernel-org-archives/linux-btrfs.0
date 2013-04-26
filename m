Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab3DZNFq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Apr 2013 09:05:46 -0400
Date: Fri, 26 Apr 2013 15:05:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: various abort cleanups
Message-ID: <20130426130542.GN16427@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366912087-4146-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366912087-4146-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Apr 25, 2013 at 01:48:07PM -0400, Josef Bacik wrote:
> +	printk(KERN_ERR "release %Lu for %p\n", trans->bytes_reserved, trans);

for (i=0; i<100; i++)
	say "printing u64 type requires typecast to unsigned long long"
