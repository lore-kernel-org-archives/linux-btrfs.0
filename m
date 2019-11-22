Return-Path: <SRS0=P1qN=ZO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99FEDC432C0
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 17:15:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D6F420658
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Nov 2019 17:15:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726666AbfKVRPh (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Nov 2019 12:15:37 -0500
Received: from mx2.suse.de ([195.135.220.15]:39660 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726046AbfKVRPh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Nov 2019 12:15:37 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 058FDB3B3;
        Fri, 22 Nov 2019 17:15:35 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id ADAA3DA898; Fri, 22 Nov 2019 18:15:35 +0100 (CET)
Date:   Fri, 22 Nov 2019 18:15:35 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Chris Murphy <lists@colorremedies.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: is there a log tree replay kernel message?
Message-ID: <20191122171535.GC3001@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <CAJCQCtRw7fTBrC8ROu-e+bbE+rL3sz6Av9Q4obXfDFMijNWeow@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtRw7fTBrC8ROu-e+bbE+rL3sz6Av9Q4obXfDFMijNWeow@mail.gmail.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Nov 20, 2019 at 04:04:59PM -0700, Chris Murphy wrote:
> In fs/btrfs/tree-log.c I'm not seeing anything that would cause a
> message to appear in dmesg upon log tree replay at mount time. I see
> in fs/btrfs/super.c
> 
>  "disabling log replay at mount time"
>  "nologreplay must be used with ro mount option"
> 
> But in the case log replay is needed and is performed, causes any info
> message to appear in dmesg. At least ext4 and XFS do have such
> messages found in dmesg upon log replay. What am I missing?
> 
> Log replay suggests a crash, power failure or otherwise unclean
> shutdown, and I think it would be useful to have an indicator of such
> at the next boot rather than Btrfs just silently succeeding without
> giving any indication that there was previously an unclean unmount.

Makes sense to print the message, thanks for the suggestion.
