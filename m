Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wj0-f193.google.com ([209.85.210.193]:36487 "EHLO
        mail-wj0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750712AbcLLS2v (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 12 Dec 2016 13:28:51 -0500
Received: by mail-wj0-f193.google.com with SMTP id j10so13005933wjb.3
        for <linux-btrfs@vger.kernel.org>; Mon, 12 Dec 2016 10:28:50 -0800 (PST)
Date: Mon, 12 Dec 2016 19:28:46 +0100
From: Seraphime Kirkovski <kirkseraph@gmail.com>
To: David Sterba <dsterba@suse.cz>
Cc: linux-btrfs@vger.kernel.org, jbacik@fb.com, clm@fb.com
Subject: Re: [PATCH] Btrfs: Coding style fixes
Message-ID: <20161212182846.sb5cshixre4qe3o4@roojbos.sk>
References: <20161212141005.24071-1-kirkseraph@gmail.com>
 <20161212161156.GU12522@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20161212161156.GU12522@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 12, 2016 at 05:11:56PM +0100, David Sterba wrote:
> This type of change is more like a cleanup and you can find more
> instances where the type is applied to just one of the operands, while
> min_t/max_t would be better. Feel free to send a separate patch for
> that.

Thanks for the feedback. I will try to do the sweep in the following 
days.

I'm sorry, but I didn't quite understand. Should I resend the min/min_t 
change of this patch in a separate patch ?
