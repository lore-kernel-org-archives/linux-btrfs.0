Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ee0-f51.google.com ([74.125.83.51]:65118 "EHLO
	mail-ee0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751063AbaAGKHy (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 7 Jan 2014 05:07:54 -0500
Date: Tue, 7 Jan 2014 11:07:50 +0100
From: Andrea Mazzoleni <amadvance@gmail.com>
To: NeilBrown <neilb@suse.de>
Cc: Andrea Mazzoleni <amadvance@gmail.com>, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-btrfs@vger.kernel.org, clm@fb.com,
        jbacik@fb.com
Subject: Re: [RFC] lib: raid: New RAID library supporting up to six parities
Message-ID: <20140107100750.GA16044@gmail.com>
References: <1388742436-3754-1-git-send-email-amadvance@gmail.com>
 <20140106111529.7bcff024@notabene.brown>
 <20140106094523.GA4602@gmail.com>
 <20140107113357.3bd67ad0@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140107113357.3bd67ad0@notabene.brown>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Neil,

On 01/07, NeilBrown wrote:
> > To do the same with up to six failures, it's now required some kind of sort
> > function.
> 
> So I would probably just make sure we always process the block is the "right"
> order.  Then sorting would be irrelevant.
> But as I say, I haven't fiddled with the code, so maybe that would end up
> being more complex.

If the the async_tx and btrfs layers can always provide indexes in order,
for sure this sort function can be removed. I agree with you that it would be
a better design.

In fact, the raid library never uses it directly. It's just provided to help the
callers that for whatever reason cannot provide such indexes in order.
And seeing these swap operations between faila/failb in both btrfs and async_tx,
made me to assume that the order is not always correct.

> I don't see the above as "sorting" faila and failb, but rather determining
> which one is first.  Once you know which one is first, the remainder follow
> in order.

The new raid library, like the existing raid6, requires to have the indexes of
the failed blocks in order. With only two indexes faila/failb this means
faila < failb and sorting is equivalent to find the first one.

But with up to six failures, is like to have six fail variables:
faila/failb/failc/faild/faile/failf and the raid library requires them
to be in order as: faila < failb < failc < faild < faile < failf.
In this general case a sort function is the only one that gives the guarantee
to fulfill this requirement whatever is the original order.

Ciao,
Andrea

