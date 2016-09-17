Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:48719 "EHLO twin.jikos.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752226AbcIQUfh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 17 Sep 2016 16:35:37 -0400
Date: Sat, 17 Sep 2016 22:35:19 +0200
From: David Sterba <dave@jikos.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, clm@fb.com, dsterba@suse.cz
Subject: Re: [RFC] Preliminary BTRFS Encryption
Message-ID: <20160917203519.GE933@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
 <20160916084958.GA933@twin.jikos.cz>
 <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <313b1db1-cf32-7103-e259-328517d1c81f@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 16, 2016 at 07:56:02PM +0800, Anand Jain wrote:
> 
> 
> >> however here below is the quick example
> >> on the cli usage. Please try out, let me know if I have missed something.
> >>
> >> Also would like to mention that a review from the security experts is due,
> >> which is important and I believe those review comments can be accommodated
> >> without major changes from here.
> >
> > I disagree. Others commented on the crypto stuff, I see enough points to
> > address that would lead to major changes.
> >
> >> Also yes, thanks for the emails, I hear, per file encryption and inline
> >> with vfs layer is also important, which is wip among other things in the
> >> list.
> >
> > Implementing the recent vfs encryption in btrfs is ok, it's just feature
> > parity using an existing API.
> 
> 
>   As mentioned 'inline with vfs layer' I mean to say to use
>   fs/crypto KPIs. Which I haven't seen what parts of the code
>   from ext4 was made as generic KPIs. If that's getting stuff
>   correct in the encryption related, I think it would here as well.

So you were not talking about the 'fs/crypto' that was merged in 4.6?

>   Internal to btrfs - I had challenges to get the extents encoding
>   done properly without bailout, and the test plan. Which I think
>   is addressed here in this code. as mentioned.

Sorry, I don't understand what you mean.

> > And a note from me with maintainer's hat on, there are enough pending
> > patches and patchsets that need review, and bugs to fix, I'm not going
> > to spend time on something that we don't need at the moment if there are
> > alternatives.
> 
>   Honestly I agree. I even suggested but I had no choice.
> 
> 
> PS:
>   Pls, feel free to flame on the (raid) patches if its not correct,
>   because its rather more productive than no reply.

If it's the hot-spare and auto-replace feature, I've expressed my stance
in http://marc.info/?l=linux-btrfs&m=146252575330106, there hasn't
been any change. IMO the hot-spare feature makes most sense with the
raid56, which is stuck where it is, so we need to get it working first.

Lack of reply usually means lack of time (which I would not spend on
flaming but evaluation and review).
