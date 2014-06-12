Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:50012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932845AbaFLJle (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Jun 2014 05:41:34 -0400
Date: Thu, 12 Jun 2014 11:41:32 +0200
From: David Sterba <dsterba@suse.cz>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] btrfs-progs: make pretty Documentation/ build match the
 rest
Message-ID: <20140612094132.GL1903@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <5388B162.6070601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5388B162.6070601@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 30, 2014 at 11:27:14AM -0500, Eric Sandeen wrote:
> This is the most important patch ever.  ;)

Oh it is :)

> I found this to be less aesthetically pleasing than it was before:
> 
>      [CC]     btrfstune.o
>  Making all in Documentation
>      ASCIIDOC btrfs-convert.xml
>      [LD]     btrfstune
>      XMLTO btrfs-convert.8
>      [CC]     btrfs-show-super.o
>      GZIP btrfs-convert.8.gz
>      [LD]     btrfs-show-super
>      ASCIIDOC btrfs-debug-tree.xml
>      XMLTO btrfs-debug-tree.8
> 
> If folks don't like the 2-letter abbreviations, obviously the
> patch just isn't that important.

I like the prettyfied output, but XT or AD look unfamiliar in this context.
I've tried a few tweaks, is this change ok for you?

    [LD]     btrfs-show-super
    [ASCII]  btrfs-property.xml
    [XMLTO]  btrfs-debug-tree.8
    [XMLTO]  btrfstune.8
    [LD]     btrfs-image

Full ASCIIDOC would need to update all the two-letter strings, does not
seem justified.
