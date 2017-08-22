Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:35811 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751289AbdHVSP6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 22 Aug 2017 14:15:58 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 70F1FAD6F
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Aug 2017 18:15:56 +0000 (UTC)
Date: Tue, 22 Aug 2017 20:14:32 +0200
From: David Sterba <dsterba@suse.cz>
To: jeffm@suse.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5 v2] btrfs-progs: convert fixes + reiserfs support
Message-ID: <20170822181432.GC2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170727154723.2208-1-jeffm@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170727154723.2208-1-jeffm@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 27, 2017 at 11:47:18AM -0400, jeffm@suse.com wrote:
> From: Jeff Mahoney <jeffm@suse.com>
> 
> Changes since v1:
> - reiserfs conversion:
>   - use bool instead of int
>   - catch 'impossible' condition of multiple discontiguous tails
>   - properly handle hole followed by tail
>   - add testing for combinations of real blocks, tails, and holes
>   - print error indicating filename (and key) that caused a failure
>   - constify buffer arg to btrfs_insert_inline_extent
>   - add tails=on to reiserfs mount options
>   - fixed absence of libreiserfscore to be non-fatal unless specificially
>     enabled
> 
> - btrfs-progs: convert: use search_cache_extent in migrate_one_reserved_range
>   - In testing, we would not be able to roll back to part of the 0-1MB range
>     not being migrated.
> 
> - btrfs-progs: tests: fix typo in convert-tests/008-readonly-image
>   - The test used ext2_save instead of ext2_saved as the filename

Oh crap, I noticed v2 after I had finished merging v1. The changes have
been now transferred, so the version in devel is v2 + my fixups. The 2
new patches ("use search_cache_extent in migrate_one_reserved_range" and
"tests: fix typo in convert-tests/008-readonly-image") have been also
added.
