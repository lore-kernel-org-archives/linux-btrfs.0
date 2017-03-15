Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56513 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751689AbdCOOik (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 15 Mar 2017 10:38:40 -0400
Date: Wed, 15 Mar 2017 15:38:01 +0100
From: David Sterba <dsterba@suse.cz>
To: ednadolski@gmail.com
Cc: linux-btrfs@vger.kernel.org, Edmund Nadolski <enadolski@suse.com>
Subject: Re: [PATCH 2/2] btrfs: replace hardcoded value with SEQ_NONE macro
Message-ID: <20170315143801.GH14605@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170313203204.11857-1-enadolski@suse.com>
 <20170313203204.11857-3-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170313203204.11857-3-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 13, 2017 at 02:32:04PM -0600, ednadolski@gmail.com wrote:
> From: Edmund Nadolski <enadolski@suse.com>
> 
> Define the SEQ_NONE macro to replace (u64)-1 in places where said
> value triggers a special-case ref search behavior.

> index 9c41fba..20915a6 100644
> --- a/fs/btrfs/backref.h
> +++ b/fs/btrfs/backref.h
> @@ -23,6 +23,8 @@
>  #include "ulist.h"
>  #include "extent_io.h"
>  
> +#define SEQ_NONE	((u64)-1)

Can you please move the definition to ctree.h, near line 660, where
seq_list and SEQ_LIST_INIT are defined, so thay're all grouped together?
