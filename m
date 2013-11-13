Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38221 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab3KMRNp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 13 Nov 2013 12:13:45 -0500
Date: Wed, 13 Nov 2013 18:13:37 +0100
From: David Sterba <dsterba@suse.cz>
To: Dieter Ries <lists@dieterries.net>
Cc: Ian Kumlien <pomac@demius.net>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH 2/6] Btrfs-progs: add btrfsck functionality to btrfs
Message-ID: <20131113171337.GD18494@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1360283822-23452-1-git-send-email-pomac@demius.net>
 <1360283822-23452-3-git-send-email-pomac@demius.net>
 <51AB691A.90605@dieterries.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51AB691A.90605@dieterries.net>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Sun, Jun 02, 2013 at 05:47:38PM +0200, Dieter Ries wrote:
> For this to have any effect, 'h' must be added to getopt_long(), see
> attached patch 1.
> 
> However, this results in btrfsck -h and --help doing different things:
> 
> --help prints the usage message to stdout and exits with exit(0).
> -h prints the usage message to stderr and exits with exit(129).
> 
> I made a patch to fix this, see attached patch 2.
> What it doesn't fix though is, that -h/--help and -? don't do the same
> thing. This is more complicated, as getop_long returns '?' for unknown
> options.

FYI, both patchess added to integration.

david
