Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58275 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S944058AbdEZQNm (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 26 May 2017 12:13:42 -0400
Date: Fri, 26 May 2017 18:12:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Omar Sandoval <osandov@osandov.com>
Cc: Vinnie Magro <vmagro@fb.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] btrfs: Use kvzalloc instead of kzalloc/vmalloc in
 alloc_bitmap
Message-ID: <20170526161241.GC30842@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <e507b0e6417e11e7a0df0002c95209d8-1f3c8f0@d8a20777635a6c1f43e7500017a6a474ea839660ad72b5b09d455997e9681205>
 <20170525212721.GA12994@vader>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170525212721.GA12994@vader>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 25, 2017 at 02:27:21PM -0700, Omar Sandoval wrote:
> On Thu, May 25, 2017 at 12:18:02PM -0700, Vinnie Magro wrote:
> > Replace alloc_bitmap with call to kvzalloc. kvzalloc preserves the
> > same fallback heuristic.
> 
> Looks good, thanks.
> 
> Reviewed-by: Omar Sandoval <osandov@fb.com>

Added to queue, thanks.
