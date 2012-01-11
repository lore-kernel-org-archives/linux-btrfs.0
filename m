From: David Sterba <dave@jikos.cz>
Subject: Re: [RFC PATCH v2 1/3] Btrfs: add the Probabilistic Skiplist
Date: Wed, 11 Jan 2012 15:41:51 +0100
Message-ID: <20120111144151.GW7322@twin.jikos.cz>
References: <1326180696-3614-1-git-send-email-liubo2009@cn.fujitsu.com> <1326180696-3614-2-git-send-email-liubo2009@cn.fujitsu.com> <20120111003700.GT7322@twin.jikos.cz> <4F0CEEB7.2080809@cn.fujitsu.com>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org, chris.mason@oracle.com,
	josef@redhat.com
To: Liu Bo <liubo2009@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4F0CEEB7.2080809@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jan 11, 2012 at 10:06:47AM +0800, Liu Bo wrote:
> > or you can set the maxlevel during skiplist creation, or predefine a
> > "small" skiplist with compile-time-set level to whatever < 16.
> >
> > this can be tuned later of course.
> > 
> 
> Yes, I do set the maxlevel to 16 at the creation of a skiplist.
> 
> Here 4^(16 - 1) is 2^30, I don't think this is enough for some severe workloads which build large
> amount of fragments.

2^30 is ~one bilion, still a lot :) but I understand your concerns.

> Maybe we should make the maxlevel self-update.

yeah, but this is IMO not necessary for the first version.

> > I suggest to pick the full prefix "skiplist_" instead of just "sl_",
> > it'll be IMHO more readable and googlable. (Out of curiosity I grepped
> > for the sl_ prefix and it's used by drivers/net/slip/slip.c).
> 
> I did hesitate for a while between "skiplist_" and "sl_"...
> and I just wanna make it be similar to "rb_".
>
> Anyway, I'm ok with "skiplist_".

thanks.


david
