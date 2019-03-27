Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AC7AC43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:27:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A3AA20700
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:27:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ZqY9P5Fm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbfC0U1x (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:27:53 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:49542 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725841AbfC0U1w (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:27:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=90GUhgxAUgMQ4hrgT2Dhn2xc52MqyoCxjdH1nrO5eeA=; b=ZqY9P5Fm5UcLyF3hCh9EE4QHV
        ngdGeotfI8cMt3n/M4+mCTPbB0ywkGXExP326Ap0V4poQH1Owb+uhkg3pemx2sxPFvNNGKAiaSVTp
        Qc73irjwqG12pJqYpQ1eoYpdreJermGCY9xfdriwO1kWPzaurLEND2uUzSiMygYZ/wrJQRYct6JCz
        UEbUv56taQUOIEYOyndt8U2ASFKyn2fxtE7fLwzPOfqxAiCQdiox5eo1DeYbOVOTRKH0OorOibzMU
        IUXNpd1gAIU59jf4YdCBMTkSLDeQSIFVRqRBIHfepPc7281qvKCNRVNoHyw2XBpBP75QTwpGGRPcZ
        h/Qiq7eWA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1h9F8i-00035n-Ps; Wed, 27 Mar 2019 20:27:12 +0000
Date:   Wed, 27 Mar 2019 13:27:12 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     syzbot <syzbot+1145ec2e23165570c3ac@syzkaller.appspotmail.com>
Cc:     akpm@linux-foundation.org, clm@fb.com, dan.carpenter@oracle.com,
        dave@stgolabs.net, dhowells@redhat.com, dsterba@suse.com,
        dvyukov@google.com, ebiederm@xmission.com, jbacik@fb.com,
        ktkhai@virtuozzo.com, ktsanaktsidis@zendesk.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, manfred@colorfullife.com, mhocko@suse.com,
        nborisov@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        rppt@linux.vnet.ibm.com, sfr@canb.auug.org.au, shakeelb@google.com,
        syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com
Subject: Re: general protection fault in put_pid
Message-ID: <20190327202712.GT10344@bombadil.infradead.org>
References: <00000000000051ee78057cc4d98f@google.com>
 <000000000000c58fcf058519059e@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000000000000c58fcf058519059e@google.com>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Mar 27, 2019 at 01:10:01PM -0700, syzbot wrote:
> syzbot has bisected this bug to:
> 
> commit b9b8a41adeff5666b402996020b698504c927353
> Author: Dan Carpenter <dan.carpenter@oracle.com>
> Date:   Mon Aug 20 08:25:33 2018 +0000
> 
>     btrfs: use after free in btrfs_quota_enable

Not plausible.  Try again.
