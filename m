Return-Path: <SRS0=0wlt=2B=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4445C43603
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 13:49:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8569E20836
	for <linux-btrfs@archiver.kernel.org>; Wed, 11 Dec 2019 13:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729278AbfLKNta (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 11 Dec 2019 08:49:30 -0500
Received: from mx2.suse.de ([195.135.220.15]:55324 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727554AbfLKNta (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 11 Dec 2019 08:49:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 68B0AADAA;
        Wed, 11 Dec 2019 13:49:28 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 52657DA883; Wed, 11 Dec 2019 14:49:29 +0100 (CET)
Date:   Wed, 11 Dec 2019 14:49:29 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: linux-next: Tree for Dec 6 (objtool, lots in btrfs)
Message-ID: <20191211134929.GL3929@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>
References: <20191206135406.563336e7@canb.auug.org.au>
 <cd4091e4-1c04-a880-f239-00bc053f46a2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd4091e4-1c04-a880-f239-00bc053f46a2@infradead.org>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 06, 2019 at 08:17:30AM -0800, Randy Dunlap wrote:
> On 12/5/19 6:54 PM, Stephen Rothwell wrote:
> > Hi all,
> > 
> > Please do not add any material for v5.6 to your linux-next included
> > trees until after v5.5-rc1 has been released.
> > 
> > Changes since 20191204:
> > 
> 
> on x86_64:
> 
> fs/btrfs/ctree.o: warning: objtool: btrfs_search_slot()+0x2d4: unreachable instruction

Can somebody enlighten me what is one supposed to do to address the
warnings? Function names reported in the list contain our ASSERT macro
that conditionally calls BUG() that I believe is what could cause the
unreachable instructions but I don't see how.

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/fs/btrfs/ctree.h#n3113

__cold
static inline void assfail(const char *expr, const char *file, int line)
{
	if (IS_ENABLED(CONFIG_BTRFS_ASSERT)) {
		pr_err("assertion failed: %s, in %s:%d\n", expr, file, line);
		BUG();
	}
}

#define ASSERT(expr)	\
	(likely(expr) ? (void)0 : assfail(#expr, __FILE__, __LINE__))
