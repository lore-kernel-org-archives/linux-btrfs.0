Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50670 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752286AbdGDP0x (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 4 Jul 2017 11:26:53 -0400
Date: Tue, 4 Jul 2017 17:25:41 +0200
From: David Sterba <dsterba@suse.cz>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [RFC PATCH v4 2/2] Btrfs: add heuristic method for make decision
 compress or not compress
Message-ID: <20170704152541.GD2866@suse.cz>
Reply-To: dsterba@suse.cz
References: <20170701165602.31189-1-nefelim4ag@gmail.com>
 <20170701165602.31189-3-nefelim4ag@gmail.com>
 <20170703173040.GB2866@twin.jikos.cz>
 <CAGqmi74FqgHzshWZti06NBp2xYjjE0reao4AqCM6vMfz4Q-qEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGqmi74FqgHzshWZti06NBp2xYjjE0reao4AqCM6vMfz4Q-qEg@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 04, 2017 at 02:11:10PM +0300, Timofey Titovets wrote:
> >> @@ -0,0 +1,336 @@
> >> +enum compression_advice btrfs_compress_heuristic(struct inode *inode,
> >
> > This returns enum but the caller treats it as a bool, this should be
> > synced up.
> >
> 
> I think for now, enum and values can be just dropped,
> because it's only a proof of concept that in future, heuristic
> can return more complex answer and then some of that values
> can be used as acceptable for zlib and unnacceptable for lzo & etc.
> Also that can be easy added again later.

Right.

> > As mentioned in the previous mail, we'll add the skeleton code only for
> > now, which means this loop, that simply calls find_get_page, kunmap and
> > put_page.
> >
> 
> So, i will send a separate patch for skeleton code.
> And if i understood all correctly, later, we'll add complex code one by one.

Yes.

> >> +
> >> +enum compression_advice {
> >> +     COMPRESS_NONE,
> >> +     COMPRESS_COST_UNKNOWN,
> >> +     COMPRESS_COST_EASY,
> >> +     COMPRESS_COST_MEDIUM,
> >> +     COMPRESS_COST_HARD
> >
> > I don't find the naming good, as the cost is not easy or hard, but
> > rather low/medium/high. Or you can rename the whole prefix if you find a
> > better naming scheme.
> 
> (Explain above)
> So just drop that for now.

Ok.
