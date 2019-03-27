Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68762C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 22:50:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D6020651
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 22:50:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbfC0Wt4 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 18:49:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:36878 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727723AbfC0Wt4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 18:49:56 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 81AB7ACCD;
        Wed, 27 Mar 2019 22:49:53 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 82603DA8D8; Wed, 27 Mar 2019 23:51:03 +0100 (CET)
Date:   Wed, 27 Mar 2019 23:51:03 +0100
From:   David Sterba <dsterba@suse.cz>
To:     Matthew Wilcox <willy@infradead.org>
Cc:     syzbot <syzbot+1145ec2e23165570c3ac@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, clm@fb.com, dan.carpenter@oracle.com,
        dave@stgolabs.net, dhowells@redhat.com, dsterba@suse.com,
        dvyukov@google.com, ebiederm@xmission.com, jbacik@fb.com,
        ktkhai@virtuozzo.com, ktsanaktsidis@zendesk.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, manfred@colorfullife.com, mhocko@suse.com,
        nborisov@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au, shakeelb@google.com,
        syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com
Subject: Re: general protection fault in put_pid
Message-ID: <20190327225102.GB29086@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Matthew Wilcox <willy@infradead.org>,
        syzbot <syzbot+1145ec2e23165570c3ac@syzkaller.appspotmail.com>,
        akpm@linux-foundation.org, clm@fb.com, dan.carpenter@oracle.com,
        dave@stgolabs.net, dhowells@redhat.com, dsterba@suse.com,
        dvyukov@google.com, ebiederm@xmission.com, jbacik@fb.com,
        ktkhai@virtuozzo.com, ktsanaktsidis@zendesk.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, manfred@colorfullife.com, mhocko@suse.com,
        nborisov@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au, shakeelb@google.com,
        syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com
References: <00000000000051ee78057cc4d98f@google.com>
 <000000000000c58fcf058519059e@google.com>
 <20190327202712.GT10344@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190327202712.GT10344@bombadil.infradead.org>
User-Agent: Mutt/1.5.23.1 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 01:27:12PM -0700, Matthew Wilcox wrote:
> On Wed, Mar 27, 2019 at 01:10:01PM -0700, syzbot wrote:
> > syzbot has bisected this bug to:
> > 
> > commit b9b8a41adeff5666b402996020b698504c927353
> > Author: Dan Carpenter <dan.carpenter@oracle.com>
> > Date:   Mon Aug 20 08:25:33 2018 +0000
> > 
> >     btrfs: use after free in btrfs_quota_enable
> 
> Not plausible.  Try again.

Agreed, grep for 'btrfs' in the console log does not show anything, ie.
no messages, slab caches nor functions on the stack.
