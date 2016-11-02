Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34772 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754653AbcKBKzx (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 2 Nov 2016 06:55:53 -0400
Date: Wed, 2 Nov 2016 11:55:50 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v3 1/4] btrfs-progs: utils: Introduce function to escape
 characters
Message-ID: <20161102105550.GB12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161101080147.13163-1-quwenruo@cn.fujitsu.com>
 <20161101080147.13163-2-quwenruo@cn.fujitsu.com>
 <20161101100851.GV12522@suse.cz>
 <1382110a-9c56-e9e2-be33-77dbfffce4b6@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382110a-9c56-e9e2-be33-77dbfffce4b6@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 02, 2016 at 09:19:10AM +0800, Qu Wenruo wrote:
> 
> 
> At 11/01/2016 06:08 PM, David Sterba wrote:
> > On Tue, Nov 01, 2016 at 04:01:43PM +0800, Qu Wenruo wrote:
> >> Introduce new function, escape_string_inplace(), to escape specified
> >> characters in place.
> >
> > Sorry, the pointer to seq_path was misleading. The actual escape
> > function is mangle_path and it copies one string to another. As we just
> > print the path, we can simply switch and call putchar.
> >
> 
> Putchar() method is indeed much easier to implement.
> 
> But it makes us hard to do further formatting, like aligning the path to 
> given width. (At least we are still using 32 chars alignment for path)
> 
> So I still prefer the current full function string escaping and still 
> use %-32s for formatting.
> 
> 
> And the idea of implementing escape_string_inplace() as a pure string 
> manipulation function can make it more agile for later use.
> For example, we can reuse it for print-tree.

Reusing is fine, but I really don't like that the function modifies the
argument. What if the function is called twice on the same string? Also,
in the print-tree, this would mean the extent buffer would be modified,
potentially overwriting other items.
