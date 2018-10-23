Return-Path: <SRS0=XNjG=ND=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62E50C67863
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 11:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2904D2075D
	for <linux-btrfs@archiver.kernel.org>; Tue, 23 Oct 2018 11:19:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2904D2075D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728180AbeJWTmV (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 23 Oct 2018 15:42:21 -0400
Received: from mx2.suse.de ([195.135.220.15]:52192 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727568AbeJWTmV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Oct 2018 15:42:21 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id CE303AF43;
        Tue, 23 Oct 2018 11:19:18 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 75EBEDA6FB; Tue, 23 Oct 2018 13:19:10 +0200 (CEST)
Date:   Tue, 23 Oct 2018 13:19:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Liu Bo <obuil.liubo@gmail.com>
Cc:     Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] Btrfs updates for 4.20, part 1
Message-ID: <20181023111910.GO16290@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Liu Bo <obuil.liubo@gmail.com>,
        Chris Mason <clm@fb.com>, torvalds@linux-foundation.org,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <cover.1540227161.git.dsterba@suse.com>
 <CANQeFDB6Qy_=E1GD6i6f3VaU0CiKQBr7td1=8gbvZYZ3ui88Yg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANQeFDB6Qy_=E1GD6i6f3VaU0CiKQBr7td1=8gbvZYZ3ui88Yg@mail.gmail.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 22, 2018 at 05:23:36PM -0700, Liu Bo wrote:
> > Performance improvements:
> >
> > * blocking mode of path is gone, means that only the spinning mode is used;
> 
> I'd like to do a few corrections here, the transition from the
> spinning mode to blocking mode is removed, we still need blocking mode
> of path for sleeping context.

Ok, thanks. So for the purpose of merge changelog, the updated text:

* transition between blocking and spinning modes of path is gone, which
  originally resulted to more unnecessary wakeups and updates to the
  path locks, the effects are measurable and improve latency and
  scalability
