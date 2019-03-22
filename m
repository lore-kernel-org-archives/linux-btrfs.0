Return-Path: <SRS0=iEal=RZ=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A37BC43381
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:24:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7885218D3
	for <linux-btrfs@archiver.kernel.org>; Fri, 22 Mar 2019 14:24:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728140AbfCVOY3 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 22 Mar 2019 10:24:29 -0400
Received: from mx2.suse.de ([195.135.220.15]:45282 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727874AbfCVOY2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 22 Mar 2019 10:24:28 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 20E37AD52;
        Fri, 22 Mar 2019 14:24:27 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 9258DDA897; Fri, 22 Mar 2019 15:25:40 +0100 (CET)
Date:   Fri, 22 Mar 2019 15:25:40 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: work around false-positive
 -Wsometimes-uninitialized warning
Message-ID: <20190322142540.GC28481@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        Arnd Bergmann <arnd@arndb.de>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>, David Sterba <dsterba@suse.com>,
        clang-built-linux@googlegroups.com,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Lu Fengqi <lufq.fnst@cn.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190322140753.286171-1-arnd@arndb.de>
 <57833895-fce3-75bc-a28e-6bdc6d14ea8c@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <57833895-fce3-75bc-a28e-6bdc6d14ea8c@suse.com>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Mar 22, 2019 at 04:11:52PM +0200, Nikolay Borisov wrote:
> 
> 
> On 22.03.19 г. 16:07 ч., Arnd Bergmann wrote:
> > clang fails to see that the last 'else if() in btrfs_uuid_tree_add()
> > is always true, so 'eb' is always initialized correctly:
> > 
> > fs/btrfs/uuid-tree.c:129:13: error: variable 'eb' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
> >         } else if (ret < 0) {
> >                    ^~~~~~~
> > fs/btrfs/uuid-tree.c:139:22: note: uninitialized use occurs here
> >         write_extent_buffer(eb, &subid_le, offset, sizeof(subid_le));
> >                             ^~
> > fs/btrfs/uuid-tree.c:129:9: note: remove the 'if' if its condition is always true
> >         } else if (ret < 0) {
> >                ^~~~~~~~~~~~~
> > fs/btrfs/uuid-tree.c:90:26: note: initialize the variable 'eb' to silence this warning
> >         struct extent_buffer *eb;
> >                                 ^
> >                                  = NULL
> > 
> > Change it into a plain 'else' to shut up that warning.
> > 
> > Link: https://bugs.llvm.org/show_bug.cgi?id=41197
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Such a patch has already been merged to misc-next:
> 
> f22898caa6a5 ("btrfs: Turn an 'else if' into an 'else' in
> btrfs_uuid_tree_add")

I haven't updated for-next for a few days so the patch was not so
visible outside, will push an update today.
