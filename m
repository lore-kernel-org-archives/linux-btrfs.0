Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:54189 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932711AbcLMOht (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 13 Dec 2016 09:37:49 -0500
Date: Tue, 13 Dec 2016 15:37:42 +0100
From: David Sterba <dsterba@suse.cz>
To: Seraphime Kirkovski <kirkseraph@gmail.com>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH] Btrfs: Coding style fixes
Message-ID: <20161213143742.GC12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <20161212141005.24071-1-kirkseraph@gmail.com>
 <20161212161156.GU12522@twin.jikos.cz>
 <20161212182846.sb5cshixre4qe3o4@roojbos.sk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161212182846.sb5cshixre4qe3o4@roojbos.sk>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2016 at 07:28:46PM +0100, Seraphime Kirkovski wrote:
> On Mon, Dec 12, 2016 at 05:11:56PM +0100, David Sterba wrote:
> > This type of change is more like a cleanup and you can find more
> > instances where the type is applied to just one of the operands, while
> > min_t/max_t would be better. Feel free to send a separate patch for
> > that.
> 
> Thanks for the feedback. I will try to do the sweep in the following 
> days.
> 
> I'm sorry, but I didn't quite understand. Should I resend the min/min_t 
> change of this patch in a separate patch ?

Remove the hunk that changes min -> mit_t from this patch, send it in a
separate patch with more changes of that kind. Thanks.
