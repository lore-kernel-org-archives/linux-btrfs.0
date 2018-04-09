Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47874 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751652AbeDIODw (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 9 Apr 2018 10:03:52 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 7945EAE15
        for <linux-btrfs@vger.kernel.org>; Mon,  9 Apr 2018 14:03:51 +0000 (UTC)
Date: Mon, 9 Apr 2018 16:01:22 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] btrfs-progs: Remove btrfs-debug-tree command
Message-ID: <20180409140121.GO8557@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1522136746-13365-1-git-send-email-nborisov@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522136746-13365-1-git-send-email-nborisov@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 27, 2018 at 10:45:43AM +0300, Nikolay Borisov wrote:
> There is already a replacement in the face of btrfs inspect-internal
> dump-tree. And this command is just a simple wrapper around it. Just
> remove it and adjust the show-blocks script to call the main btrfs
> binary to achieve the same effect.
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
> 
> V2 (analogical changes to other patches so changelog is present only in the 
> first patch): 
>  * Remove tool reference from .gitignore and Documentation/Makefile.in
>  * Document that the standalone tools are removed in the STANDALONE section in 
>  the documentation.

1-4 applied, thanks. I've added the exact versions when the tools were
deprecated as it's not the same one, references to the issue and removed
some Makefile leftovers.
