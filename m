Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48531 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751894Ab3GaSYi (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 31 Jul 2013 14:24:38 -0400
Date: Wed, 31 Jul 2013 20:24:31 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Fasheh <mfasheh@suse.de>
Cc: Andrew Vagin <avagin@gmail.com>, Chris Mason <chris.mason@fusionio.com>,
        linux-btrfs@vger.kernel.org, kzak@redhat.com, xemul@openvz.org
Subject: Re: btrfs: stat(2) and /proc/pid/maps returns different devices
Message-ID: <20130731182431.GX24343@suse.cz>
Reply-To: dsterba@suse.cz
References: <20130704095138.GB12359@gmail.com>
 <20130708215446.GH18204@twin.jikos.cz>
 <20130710163105.GR32502@wotan.suse.de>
 <20130710174545.GS32502@wotan.suse.de>
 <20130710222650.GI25386@suse.cz>
 <20130719205115.GK32502@wotan.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130719205115.GK32502@wotan.suse.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 19, 2013 at 01:51:15PM -0700, Mark Fasheh wrote:
> Ok checking for the operation is definitely needed. I'll check for
> ->getattr(). The rest of the stuff in our suse patch must have been added
> after my own commit. Do you know why this was added? Since this is all
> internal to proc I didn't think we needed all this extra stuff to replicate
> vfs_gettatr().

I don't remember, probably for code simplicity. The updated version
you've sent looks ok to me.

david
