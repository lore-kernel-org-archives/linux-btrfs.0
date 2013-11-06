Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:42667 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3KFRhk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 6 Nov 2013 12:37:40 -0500
Date: Wed, 6 Nov 2013 18:37:35 +0100
From: David Sterba <dsterba@suse.cz>
To: Himangi Saraogi <himangi774@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs:check-integrity.c: replace kmalloc with
 kmalloc_array
Message-ID: <20131106173735.GA16662@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20131101004559.GA3258@himangi-Inspiron-N5110gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20131101004559.GA3258@himangi-Inspiron-N5110gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 01, 2013 at 06:16:00AM +0530, Himangi Saraogi wrote:
> This patch replaces kmalloc(size * nr, ) with kmalloc_array(nr, size)
> as kmalloc_array() is preferred because it can check that the
> calculation doesn't wrap and won't return a smaller allocation.

Can you please convert all the instances in one patch? Feel free to use
the following cocinelle script, that found ~16 places that could use
the conversion.

$ cat kmalloc_array.cocci
@ @
expression E1, E2, E3;
@@

* \(kmalloc\|kzalloc\)(E1 * E2, E3)
---

The output is not a straight patch, the instances have to be reviewed manually
because the order of nritems and size may differ at each location.

david
