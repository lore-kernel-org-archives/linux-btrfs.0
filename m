Return-Path: <SRS0=58CB=R4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24CF3C43381
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:12:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F167220854
	for <linux-btrfs@archiver.kernel.org>; Mon, 25 Mar 2019 13:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730957AbfCYNLy (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 25 Mar 2019 09:11:54 -0400
Received: from mx2.suse.de ([195.135.220.15]:33590 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726166AbfCYNLy (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 25 Mar 2019 09:11:54 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 0AB0BAE80;
        Mon, 25 Mar 2019 13:11:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 3BDC3DA86C; Mon, 25 Mar 2019 14:13:05 +0100 (CET)
Date:   Mon, 25 Mar 2019 14:13:05 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Anand Jain <Anand.Jain@oracle.com>,
        Filipe Manana <FdManana@suse.com>, WenRuo Qu <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: use BUG() instead of BUG_ON(1)
Message-ID: <20190325131305.GD10640@suse.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        Liu Bo <bo.liu@linux.alibaba.com>,
        Anand Jain <Anand.Jain@oracle.com>,
        Filipe Manana <FdManana@suse.com>, WenRuo Qu <wqu@suse.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20190325130256.1437810-1-arnd@arndb.de>
 <78cd318c-2094-87ca-4843-46af5e3d11ef@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <78cd318c-2094-87ca-4843-46af5e3d11ef@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 25, 2019 at 03:06:12PM +0200, Nikolay Borisov wrote:
> 
> 
> On 25.03.19 г. 15:02 ч., Arnd Bergmann wrote:
> > BUG_ON(1) leads to bogus warnings from clang when
> > CONFIG_PROFILE_ANNOTATED_BRANCHES is set:
> > 
> > fs/btrfs/volumes.c:5041:3: error: variable 'max_chunk_size' is used uninitialized whenever 'if' condition is false
> >       [-Werror,-Wsometimes-uninitialized]
> >                 BUG_ON(1);
> >                 ^~~~~~~~~
> > include/asm-generic/bug.h:61:36: note: expanded from macro 'BUG_ON'
> >  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> >                                    ^~~~~~~~~~~~~~~~~~~
> > include/linux/compiler.h:48:23: note: expanded from macro 'unlikely'
> >  #  define unlikely(x)   (__branch_check__(x, 0, __builtin_constant_p(x)))
> >                         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > fs/btrfs/volumes.c:5046:9: note: uninitialized use occurs here
> >                              max_chunk_size);
> >                              ^~~~~~~~~~~~~~
> > include/linux/kernel.h:860:36: note: expanded from macro 'min'
> >  #define min(x, y)       __careful_cmp(x, y, <)
> >                                          ^
> > include/linux/kernel.h:853:17: note: expanded from macro '__careful_cmp'
> >                 __cmp_once(x, y, __UNIQUE_ID(__x), __UNIQUE_ID(__y), op))
> >                               ^
> > include/linux/kernel.h:847:25: note: expanded from macro '__cmp_once'
> >                 typeof(y) unique_y = (y);               \
> >                                       ^
> > fs/btrfs/volumes.c:5041:3: note: remove the 'if' if its condition is always true
> >                 BUG_ON(1);
> >                 ^
> > include/asm-generic/bug.h:61:32: note: expanded from macro 'BUG_ON'
> >  #define BUG_ON(condition) do { if (unlikely(condition)) BUG(); } while (0)
> >                                ^
> > fs/btrfs/volumes.c:4993:20: note: initialize the variable 'max_chunk_size' to silence this warning
> >         u64 max_chunk_size;
> >                           ^
> >                            = 0
> > 
> > Change it to BUG() so clang can see that this code path can never
> > continue.
> 
> Long-term we have to eliminate to bug_on's but until then:

I think in those places it's "this must never happen", so it's not the
the typical example of BUG_ON misuse we want to eliminate. Fixing the
compiler waring is ok though.
