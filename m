Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:36953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949Ab3HESd1 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 14:33:27 -0400
Date: Mon, 5 Aug 2013 20:33:25 +0200
From: David Sterba <dsterba@suse.cz>
To: Mike Audia <mikey_a@gmx.com>
Cc: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org,
        sbehrens@giantdisaster.de, zab@redhat.com
Subject: Re: [PATCH v2] btrfs: add mount option to set commit interval
Message-ID: <20130805183325.GG5284@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20130802211249.157550@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20130802211249.157550@gmx.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Aug 02, 2013 at 05:12:49PM -0400, Mike Audia wrote:
> > v2:
> > * Stefan pointed out a missing break and that /proc/mounts does not show
> >  the option.
> > * fixed missing goto and extra printk parameter after failed match_int
> 
> Forgive my naive question: I am using gmx's webclient which doesn't
> seem to identify your patch as an attachment.  I can simply copy/paste
> into vim and apply the patch.  Is there are more elegant way to obtain
> the code, a git tree perhaps or ...?

The standard way in linux kernel community is to send patches in emails
inline. If you can't apply the patches from the mail, a git-friendly way
of applying patches is the patchwork.kernel.org interface, see

https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories#Patches_sent_to_mailinglist

how to use it.

david
