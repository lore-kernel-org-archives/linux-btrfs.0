Return-Path: <SRS0=yXFy=OU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18855C07E85
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 11:52:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BA39220811
	for <linux-btrfs@archiver.kernel.org>; Tue, 11 Dec 2018 11:52:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BA39220811
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=cuci.nl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbeLKLw2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 11 Dec 2018 06:52:28 -0500
Received: from aristoteles.cuci.nl ([212.125.128.18]:36620 "EHLO
        aristoteles.cuci.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbeLKLw1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 11 Dec 2018 06:52:27 -0500
Received: by aristoteles.cuci.nl (Postfix, from userid 500)
        id 316DD5463; Tue, 11 Dec 2018 12:52:26 +0100 (CET)
Date:   Tue, 11 Dec 2018 12:52:26 +0100
From:   "Stephen R. van den Berg" <srb@cuci.nl>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: Kernel traces
Message-ID: <20181211115226.GA20157@cuci.nl>
References: <20181210120514.GA14828@cuci.nl>
 <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtQxaAKMP9qSF1UnOG7cy8ya=4MckGt9kL0O8oGxD4fitg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Chris Murphy wrote:
>I suggest reproducing the problem and issuing sysrq+w and then post
>the entire resulting output for a developer to evaluate. I find it's

I'll give that a try.

>I see this is btrfs-receive workload, so I wouldn't guess it's
>suvolume lock contention unless the contention is happening with a
>single shared parent subvolume into which all the receive subvolumes
>are going (e.g. subvol id 5). I'm not sure how to alleviate it.

Well, machine A has 32GB RAM and is running
multiple simultaneous btrfs-receive instances, but the machine rarely locks up
unless I increase the total reception rate beyond 5MB/s.

Machine B has 8GB RAM and is running at most a single btrfs-receive instance,
but it is much more susceptible to hangups.  The maximum reception rate
here is 3MB/s.

In both cases all received subvolumes are created inside the same master
parent (subvol id 5).  The only difference is that machine A receives multiple
subvolumes simultaneously, and machine B serialises reception (it basically
receives subvolumes from a single source (machine A)), but the subvolumes here
*are* created back to back (so maybe the previous btrfs-receive is still
late flushing buffers to disk when the new btrfs-receive already starts).
-- 
Stephen.
