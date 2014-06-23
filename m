Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50746 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753715AbaFWPEp (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Jun 2014 11:04:45 -0400
Date: Mon, 23 Jun 2014 17:04:42 +0200
From: David Sterba <dsterba@suse.cz>
To: Nils Steinger <git@n-st.de>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: Add uninstall targets to Makefiles.
Message-ID: <20140623150442.GK1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <53A78988.7050602@jp.fujitsu.com>
 <1403490228-3513-1-git-send-email-git@n-st.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1403490228-3513-1-git-send-email-git@n-st.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jun 23, 2014 at 04:23:48AM +0200, Nils Steinger wrote:
> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(man8dir)

> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(libdir)

> +	rmdir -p --ignore-fail-on-non-empty $(DESTDIR)$(bindir)

I don't think it's right to remove the systemwide directories: bindir,
libdir and man8dir. There rest are btrfs subdirs (eg. incdir), that's
fine.
