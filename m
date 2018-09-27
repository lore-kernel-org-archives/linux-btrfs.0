Return-Path: <SRS0=Zypw=MJ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73A4BC43382
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 11:06:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A9B5215E4
	for <linux-btrfs@archiver.kernel.org>; Thu, 27 Sep 2018 11:06:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0A9B5215E4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727223AbeI0RYc (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Sep 2018 13:24:32 -0400
Received: from mx2.suse.de ([195.135.220.15]:59492 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726820AbeI0RYc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Sep 2018 13:24:32 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id D53CEABEF
        for <linux-btrfs@vger.kernel.org>; Thu, 27 Sep 2018 11:06:46 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 65B88DAE2F; Thu, 27 Sep 2018 13:06:46 +0200 (CEST)
Date:   Thu, 27 Sep 2018 13:06:46 +0200
From:   David Sterba <dsterba@suse.cz>
To:     David Sterba <dsterba@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 00/11] Cleanup dev-replace locking
Message-ID: <20180927110646.GP3255@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, David Sterba <dsterba@suse.com>,
        linux-btrfs@vger.kernel.org
References: <cover.1536331604.git.dsterba@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1536331604.git.dsterba@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Sep 07, 2018 at 04:54:59PM +0200, David Sterba wrote:
> The series peels off the custom locking that's used for dev-replace and
> uses read-write semaphore in the end.
> 
> I've mainly focused on correctness and haven't measured the performance
> effects. There should be none as the blocking and waiting was merely
> open coding what the rw semaphore does, but without the fairness. The
> overall number of locks taken is low, there's a lots of IO in between so
> even if new scheme is slower, I don't expect any dramatic change.

Mixed results. The btrfs/011 is a test that usually takes long time
(around 1000 sec on my test box) and I have a long list of run times to
compare. There this patchset does not show any problems. However on a VM
with 8 CPUs, this goes from similar times (1000 sec) to several hours,
without apparent reason. The is other low activity on the system, but so
this is with testing other patchsets and the times are not that bad.

So, I'm going to merge the first part of the patchset that does not
switch the locking primitives to the semaphores, more analysis needed.
