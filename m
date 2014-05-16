Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43273 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756380AbaEPPFv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 16 May 2014 11:05:51 -0400
Date: Fri, 16 May 2014 17:05:50 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: linux-btrfs@vger.kernel.org, Josef Bacik <jbacik@fb.com>,
        Chris Mason <clm@fb.com>
Subject: Re: [PATCH 3/3] btrfs-progs: add quota group verify code
Message-ID: <20140516150550.GX6917@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1399493237-19740-1-git-send-email-mfasheh@suse.de>
 <1399493237-19740-4-git-send-email-mfasheh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1399493237-19740-4-git-send-email-mfasheh@suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, May 07, 2014 at 01:07:17PM -0700, Mark Fasheh wrote:
> +struct ref {
> +	u64			bytenr;
> +	u64			num_bytes;
> +	u64			parent;
> +	u64			root;
> +
> +	struct rb_node		bytenr_node;
> +};

A way too generic name, though it's only local to the qgroup verifier,
one can't easily grep for it etc.

The rest looks ok or can be addressed later.
