Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40350 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751967AbeCPUD6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 16 Mar 2018 16:03:58 -0400
Date: Fri, 16 Mar 2018 20:41:47 +0100
From: David Sterba <dsterba@suse.cz>
To: Nikolay Borisov <nborisov@suse.com>
Cc: Liu Bo <obuil.liubo@gmail.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH] btrfs: Document parameters of btrfs_reserve_extent
Message-ID: <20180316194147.GF16736@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1520936552-11586-1-git-send-email-nborisov@suse.com>
 <CANQeFDDtByiOwt-=ffNHB1iyUBzcvQoNLT2LM6ETLWstOzNiZg@mail.gmail.com>
 <34f4d6f0-4f04-7d3a-4e46-c341f401be65@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <34f4d6f0-4f04-7d3a-4e46-c341f401be65@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Mar 16, 2018 at 08:44:56PM +0200, Nikolay Borisov wrote:
> >> + * @min_alloc_size -   Indicates the minimum amount of memory that the
> > 
> > Could you please pick another word instead of "memory", like hole or
> > extent or space?
> 
> Good point, i guess it's a brain fair. I'd rather use "space". I see
> David has already merged it. David do you mind fixing it in-place?

Yes, no problem.
