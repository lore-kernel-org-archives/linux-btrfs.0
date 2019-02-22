Return-Path: <SRS0=GKQD=Q5=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 154B4C43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:24:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E2A71206B6
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Feb 2019 17:24:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726403AbfBVRYG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Feb 2019 12:24:06 -0500
Received: from mx2.suse.de ([195.135.220.15]:51574 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726214AbfBVRYG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Feb 2019 12:24:06 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 680E2AD4D;
        Fri, 22 Feb 2019 17:24:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 74E84DAA56; Fri, 22 Feb 2019 18:25:26 +0100 (CET)
Date:   Fri, 22 Feb 2019 18:25:25 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Filipe Manana <fdmanana@kernel.org>
Cc:     Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 3/4] Btrfs: check if destination root is read-only for
 deduplication
Message-ID: <20190222172524.GJ9874@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Filipe Manana <fdmanana@kernel.org>,
        Zygo Blaxell <ce3g8jdj@umail.furryterror.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
References: <20181212180559.15249-1-fdmanana@kernel.org>
 <20181212180559.15249-4-fdmanana@kernel.org>
 <20181213160740.GE23615@twin.jikos.cz>
 <CAL3q7H7T4Nercz9ZYtq_2yjpiPVjUX8+1xuvxnqnaDsip0bmYw@mail.gmail.com>
 <20190220164140.GF9995@hungrycats.org>
 <CAL3q7H455MCpj_-5U=zUzD3Of7aLtG6R_tHdGhZ4Kj-393sWAg@mail.gmail.com>
 <20190220171708.GG9995@hungrycats.org>
 <CAL3q7H7iqSEEyFaEtpRZw3cp613y+4k2Q8b4W7mweR3tZA05bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL3q7H7iqSEEyFaEtpRZw3cp613y+4k2Q8b4W7mweR3tZA05bQ@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Feb 22, 2019 at 11:13:48AM +0000, Filipe Manana wrote:
> So not doing nothing for now, that is, not applying this patch to
> disable dedupe on RO roots and wait for a better solution (best case,
> for 5.2 merge window), is reasonable
> and not something I'm against.
> David, would you consider at least excluding it from 5.1 to allow for
> a different solution to pop up for another merge window?

Ok, I'll remove it from the 5.1 queue for now. Thanks for the detailed
analysis. This fix favors send (for the correctness reasons), but the
deduplication usecase is also important. I hope we'll be able to come up
with a solution that does not hurt usability too much (or affects send
and dedupe equally with a sane fallback behaviour). The exclusion of
send and other operation (snapshot) already exists so the suggested
-EBUSY approach.
