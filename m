Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC57AC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:04:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A053C21547
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 16:04:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A053C21547
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=net-space.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728304AbeI0WXy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 18:23:54 -0400
Received: from dibed.net-space.pl ([84.10.22.86]:56569 "EHLO
        dibed.net-space.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727437AbeI0WXy (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:23:54 -0400
Received: (from localhost user: 'dkiper' uid#4000 fake: STDIN
        (dkiper@dibed.net-space.pl)) by router-fw-old.i.net-space.pl
        id S1871587AbeI0QD0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 18:03:26 +0200
Date:   Thu, 27 Sep 2018 18:03:26 +0200
From:   Daniel Kiper <dkiper@net-space.pl>
To:     kreijack@inwind.it
Cc:     Daniel Kiper <dkiper@net-space.pl>, grub-devel@gnu.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 4/9] btrfs: Avoid a rescan for a device which was already not found.
Message-ID: <20180927160326.GB22053@router-fw-old.i.net-space.pl>
References: <20180919184040.22540-1-kreijack@libero.it> <20180919184040.22540-5-kreijack@libero.it> <20180925172931.GC30715@router-fw-old.i.net-space.pl> <1a37b16b-0693-05fd-3a67-6b0242608a26@libero.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1a37b16b-0693-05fd-3a67-6b0242608a26@libero.it>
User-Agent: Mutt/1.3.28i
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Sep 26, 2018 at 09:55:54PM +0200, Goffredo Baroncelli wrote:
> On 25/09/2018 19.29, Daniel Kiper wrote:
> > On Wed, Sep 19, 2018 at 08:40:35PM +0200, Goffredo Baroncelli wrote:
> >> From: Goffredo Baroncelli <kreijack@inwind.it>
> >>
> >> If a device is not found, do not return immediately but
> >> record this failure by storing NULL in data->devices_attached[].
> >
> > Still the same question: Where the store happens in the code?
> > I cannot find it in the patch below. This have to be clarified.
> >
> > Daniel
>
>
> What about the following commit description
> ---------------------------------------------
> Change the behavior of find_device(): before the patch, a read of a
> missed device might trigger a rescan. However, it is never recorded

s/might/may/

> that a device is missed, so each single read of a missed device might
> triggers a rescan.  It is the caller who decides if a rescan is
> performed in case of a missed device. And it does quite often, without
> considering if in the past a devices was already found as "missed"
> This behavior causes a lot of unneeded rescan, causing a huge slowdown
> in case of a missed device.
>
> After the patch, the "missed device" information is stored in the
> cache (as a NULL value). A rescan is triggered only if no information

What do you mean by "cache"? ctx.dev_found? If yes please use latter
instead of former. Or both together if it makes sense.

> at all is found in the cache. This means that only the first time a
> read of a missed device triggers a rescan.
>
> The change in the code is done removing "return NULL" when the disk is
> not found. So it is always executed the code which stores in the cache

cache?

> the value returned by grub_device_iterate(): NULL if the device is
> missed, or a valid data otherwise.
> ---------------------------------------------

Otherwise it is much better than earlier one.

Daniel
