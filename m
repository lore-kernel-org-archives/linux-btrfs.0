Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53369 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752666Ab3EFMiv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 6 May 2013 08:38:51 -0400
Date: Mon, 6 May 2013 14:38:49 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        chris.mason@fusionio.com
Subject: Re: [PATCH 3/4] btrfs: Introduce extent_read_full_page_nolock()
Message-ID: <20130506123849.GC16456@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1366150535-18750-1-git-send-email-mfasheh@suse.de>
 <1366150535-18750-4-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366150535-18750-4-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 16, 2013 at 03:15:34PM -0700, Mark Fasheh wrote:
> @@ -2625,7 +2625,7 @@ static int __extent_read_full_page(struct extent_io_tree *tree,
>  	}
>  
>  	end = page_end;
> -	while (1) {
> +	while (1 && !parent_locked) {

the patch is ok, just this caught my eye :)
