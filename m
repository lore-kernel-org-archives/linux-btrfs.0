Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:55198 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3BZSMc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 13:12:32 -0500
Date: Tue, 26 Feb 2013 19:12:30 +0100
From: David Sterba <dsterba@suse.cz>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Cc: linux-btrfs@vger.kernel.org, zab@redhat.com
Subject: Re: [RFC] Btrfs: Allow the compressed extent size limit to be
 modified v2
Message-ID: <20130226181229.GZ27541@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1360273114-4672-1-git-send-email-mitch.harder@sabayonlinux.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 07, 2013 at 03:38:34PM -0600, Mitch Harder wrote:
> @@ -361,6 +361,7 @@ static match_table_t tokens = {
>  	{Opt_check_integrity, "check_int"},
>  	{Opt_check_integrity_including_extent_data, "check_int_data"},
>  	{Opt_check_integrity_print_mask, "check_int_print_mask=%d"},
> +	{Opt_max_compr_extent_kb, "max_compressed_extent_kb=%d"},

Can we possibly find a name that one can remember? I had to copy&paste
it each time. Let's say something with 'compress-' prefix, maybe
compress-extent-kb (or with underscores for "consistency").

david
