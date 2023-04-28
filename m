Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4BE7C77B61
	for <linux-btrfs@archiver.kernel.org>; Fri, 28 Apr 2023 03:15:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344999AbjD1DPM (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Thu, 27 Apr 2023 23:15:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344986AbjD1DPJ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 27 Apr 2023 23:15:09 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED00E75;
        Thu, 27 Apr 2023 20:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1682651705;
        bh=aQE8eazy0RcIqT818s9oCMYv7+qMqDDlz9r6IgAFmKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=e2ybsKO+E+m6itkBHmI/dkUGZqEn9fKjOzrl7AHdwjHB6SvqkExdt66Jentr95E7O
         3GduXr2qD6yURkzE89G39LD02dFGsX2Bu73AZLynVFR7ndEjoSkYOr0/AFXqX/NNOv
         GIqGivpINfzR1/8uVm/6sY7aTbEnsXTO0Cf8ulGPstddfY/6IP4iNKpClFWgxtzVnU
         Zkugh4j+3QeydSvdXJ7wpoQm61SsHVTyYMNAr8k/l/b8esSM03zO4/WRWa8JSNkXPT
         EnP+Pj9zegDgr+mQekB+fZelcY2lvypjgYBuBbpcxbYeHfb5tMrq1NO+ZopmZpJJ08
         VhwyJdB87x6IA==
Received: from biznet-home.integral.gnuweeb.org (unknown [182.253.183.144])
        by gnuweeb.org (Postfix) with ESMTPSA id 18B2E245A10;
        Fri, 28 Apr 2023 10:15:01 +0700 (WIB)
Date:   Fri, 28 Apr 2023 10:14:58 +0700
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     David Sterba <dsterba@suse.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Sterba <dsterba@suse.com>, Qu Wenruo <wqu@suse.com>,
        Josef Bacik <josef@toxicpanda.com>, Memet <zxce3@gnuweeb.org>,
        Linux Btrfs Mailing List <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: Re: [GIT PULL] Btrfs updates for 6.3
Message-ID: <ZEs6Mnx0s/siIZwv@biznet-home.integral.gnuweeb.org>
References: <cover.1676908729.git.dsterba@suse.com>
 <CAHk-=wh6-qpZ=yzseD_CQn8Gc+nGDLrufFxSFvVO2qK6+8fGUw@mail.gmail.com>
 <4b35f3a4-9972-b7f0-287f-165a817c0f73@gnuweeb.org>
 <20230425145412.GC19619@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230425145412.GC19619@suse.cz>
X-Bpl:  hUx9VaHkTWcLO7S8CQCslj6OzqBx2hfLChRz45nPESx5VSB/xuJQVOKOB1zSXE3yc9ntP27bV1M1
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Tue, Apr 25, 2023 at 04:54:12PM +0200, David Sterba wrote:
> On Sun, Apr 23, 2023 at 09:27:30AM +0700, Ammar Faizi wrote:
> > On 2/21/23 4:02 AM, Linus Torvalds wrote:
> > > On Mon, Feb 20, 2023 at 11:26 AM David Sterba <dsterba@suse.com> wrote:
> > >> Other:
> > >>
> > >> - locally enable -Wmaybe-uninitialized after fixing all warnings
> > > 
> > > I've pulled this, but I strongly suspect this change will get reverted.
> > > 
> > > I bet neither you nor linux-next is testing even _remotely_ a big
> > > chunk of the different compiler versions that are out there, and the
> > > reason flags like '-Wmaybe-uninitialized' get undone is because some
> > > random compiler version on some random config and target archiecture
> > > gives completely nonsensical warnings for odd reasons.
> > > 
> > > But hey, maybe the btrfs code is special.
> > 
> > Maybe it's too late for 6.3. So please fix this in 6.4 and backport it to
> > 6.3 stable.
> 
> Fix for this warning is in 6.4 pull request, there's no CC:stable tag
> but we can ask to add it once the code lands in master.

It landed in master.

[ Adding stable team to the Cc list ]

Hi Greg and stable team, could you please backport:

  commit 8ba7d5f5ba931be68a94b8c91bcced1622934e7a upstream
  ("btrfs: fix uninitialized variable warnings")

to v6.3 to fix gcc (10, 9, 7) build error?

The fs/btrfs/volumes.c hunk won't apply cleanly, but it can auto-merge:

  $ git cherry-pick 8ba7d5f5ba931be68a94b8c91bcced1622934e7a
  Auto-merging fs/btrfs/volumes.c
  [detached HEAD 572410288a1070c1] btrfs: fix uninitialized variable warnings
   Author: Genjian Zhang <zhanggenjian@kylinos.cn>
   Date: Fri Mar 24 10:08:38 2023 +0800
   2 files changed, 2 insertions(+), 2 deletions(-)

Thanks,

-- 
Ammar Faizi

