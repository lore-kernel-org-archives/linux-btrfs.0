Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS,USER_AGENT_MUTT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C612C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:07:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 622DC2087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 14:07:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726305AbfC0OHw (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 10:07:52 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:47440 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726147AbfC0OHv (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 10:07:51 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.92)
        (envelope-from <kilobyte@angband.pl>)
        id 1h99DY-0008Em-Eo; Wed, 27 Mar 2019 15:07:48 +0100
Date:   Wed, 27 Mar 2019 15:07:48 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Qu Wenruo <wqu@suse.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: [PATCH URGENT v1.1 0/2] btrfs-progs: Fix the nobarrier behavior
 of write
Message-ID: <20190327140748.GA30466@angband.pl>
References: <20190327094652.16078-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190327094652.16078-1-wqu@suse.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 05:46:50PM +0800, Qu Wenruo wrote:
> This urgent patchset can be fetched from github:
> https://github.com/adam900710/btrfs-progs/tree/flush_super
> Which is based on v4.20.2.
> 
> Before this patch, btrfs-progs writes to the fs has no barrier at all.
> All metadata and superblock are just buffered write, no barrier between
> super blocks and metadata writes at all.
> 
> No wonder why even clear space cache can cause serious transid
> corruption to the originally good fs.
> 
> Please merge this fix as soon as possible as I really don't want to see
> btrfs-progs corrupting any fs any more.

How often does this happen in practice?  I'm slightly incredulous about
btrfs-progs crashing often.   Especially that pwrite() is buffered on the
kernel side, so we'd need a _kernel_ crash (usually a power loss) to break
consistency.  Obviously, a potential data loss bug is always something that
needs fixing, I'm just wondering about severity.

Or do I understand this wrong?

Asking because Dimitri John Ledkov stepped down as Debian's maintainer of
this package, and I'm taking up the mantle (with Nicholas D Steeves being
around) -- modulo any updates other than important bug fixes being on hold
because of Debian's freeze.  Thus, I wonder if this is important enough to
ask for a freeze exception.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀
⣾⠁⢠⠒⠀⣿⡁ Did ya know that typing "test -j8" instead of "ctest -j8"
⢿⡄⠘⠷⠚⠋⠀ will make your testsuite pass much faster, and fix bugs?
⠈⠳⣄⠀⠀⠀⠀
