Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55715 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965980AbbDVQxt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:53:49 -0400
Date: Wed, 22 Apr 2015 18:53:47 +0200
From: David Sterba <dsterba@suse.cz>
To: Dan Merillat <dan.merillat@gmail.com>
Cc: BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] btrfs-progs: optionally restore metadata
Message-ID: <20150422165347.GG4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5535E4A8.8040600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5535E4A8.8040600@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 01:48:24AM -0400, Dan Merillat wrote:
> As long as the inode is intact, the file metadata can be restored.
> Directory data is restored at the end of search_dir.  Errors are
> checked and returned, unless ignore_errors is requested.
> 
> Signed-off-by: Dan Merillat <dan.merillat@gmail.com>

Applied, thanks.

In future patches, please stick to the coding style used in progs ([1]),
I've fixed spacing around "=", comments and moved declarations before
the statements.

[1] https://www.kernel.org/doc/Documentation/CodingStyle

> @@ -1168,10 +1275,12 @@ int cmd_restore(int argc, char **argv)
>  		static const struct option long_options[] = {
>  			{ "path-regex", 1, NULL, 256},
>  			{ "dry-run", 0, NULL, 'D'},
> +			{ "metadata", 0, NULL, 'm'},
> +			{ "debug-regex", 0, NULL, 257},

This was unused and I've removed it.
