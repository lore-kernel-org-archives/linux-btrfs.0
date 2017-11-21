Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:43724 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751115AbdKUN0g (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Nov 2017 08:26:36 -0500
Received: from relay2.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 54E43ABAE
        for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2017 13:26:35 +0000 (UTC)
Date: Tue, 21 Nov 2017 14:24:40 +0100
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/3] btrfs: update some code documentation
Message-ID: <20171121132440.GH3553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171120202449.22947-1-enadolski@suse.com>
 <20171120202449.22947-3-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171120202449.22947-3-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 20, 2017 at 01:24:48PM -0700, Edmund Nadolski wrote:
> +/*
> + * Reserve some special-case values for the extent_map .start, .block_start,
> + *: and .orig_start fields.

I'm used to write the structure members as type::member, which resembles
the C++ syntax. There are already a few recently added examples in the
code documentation, eg. the device mutexes in volume.c. I'd like to
maintain some consistency so that it's clear which syntax we use for
btrfs documentataion. The .member also looks acceptable to me, though
I'd prefer the :: way.
