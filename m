Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50178 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388196AbeGXMai (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 24 Jul 2018 08:30:38 -0400
Date: Tue, 24 Jul 2018 13:24:27 +0200
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Josef Bacik <josef@toxicpanda.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 07/22] btrfs: don't leak ret from do_chunk_alloc
Message-ID: <20180724112427.GV26141@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180719145006.17532-1-josef@toxicpanda.com>
 <20180719145006.17532-7-josef@toxicpanda.com>
 <298c8490-7868-9e28-76aa-260fdc8c1d22@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <298c8490-7868-9e28-76aa-260fdc8c1d22@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 19, 2018 at 06:43:39PM +0300, Nikolay Borisov wrote:
> 
> 
> On 19.07.2018 17:49, Josef Bacik wrote:
> > If we're trying to make a data reservation and we have to allocate a
> > data chunk we could leak ret == 1, as do_chunk_alloc() will return 1 if
> > it allocated a chunk.  Since the end of the function is the success path
> > just return 0.
> > 
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> 
> Reviewed-by: Nikolay Borisov <nborisov@suse.com>
> 
> The logic flow in this function is a steaming pile of turd and is in
> dire need of refactoring...

Agreed, fixing the default return code seems like the right fix now,
compared to untangling the gotos. Patch added to misc-next.
