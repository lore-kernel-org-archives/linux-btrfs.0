Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:47172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932619AbaDBR3V (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 2 Apr 2014 13:29:21 -0400
Date: Wed, 2 Apr 2014 19:29:20 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
Message-ID: <20140402172920.GK29256@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
> Convert the old btrfs man pages to new asciidoc and split the huge
> btrfs man page into subcommand man page.

Excellent!

> The asciidoc style and Makefile things are mostly simplified from git
> Documentation, which only supports man page output and remove html output,
> since html output is somewhat overkilled for btrfs.

Well, I've been thinking about automatically pushing the man pages to
wiki, with asciidoc it would be much easier, the formatting capabilities
are better than what *roff provides.

> 1) More human-readable raw documentations.
>   The roff grammar is not so easy to read, especially mixed with a lot
>   of special words.
> 
> 2) Easier to modify man page.
>   The old huge btrfs man page makes it hard to maintain.
>   It's common that some one adds some new options, but only modifies
>   the detailed options but not the 'SYNOPSIS' section.

I hope both points will encourage more people to contribute to the
documentation.
