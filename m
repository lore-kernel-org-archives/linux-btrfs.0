Return-Path: <SRS0=arzm=R6=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=FROM_LOCAL_HEX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84337C43381
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:10:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA512087C
	for <linux-btrfs@archiver.kernel.org>; Wed, 27 Mar 2019 20:10:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727632AbfC0UKD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 27 Mar 2019 16:10:03 -0400
Received: from mail-it1-f199.google.com ([209.85.166.199]:40815 "EHLO
        mail-it1-f199.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726980AbfC0UKC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 27 Mar 2019 16:10:02 -0400
Received: by mail-it1-f199.google.com with SMTP id j8so1091266ita.5
        for <linux-btrfs@vger.kernel.org>; Wed, 27 Mar 2019 13:10:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=M9LZ+bMimI4PbDOfuBNIBaRlNMQDprLBDf38mjJfhKc=;
        b=TQ4EmdJkIpwQFaKiL2lfDJyn6qOKLhv1MDnmh3578zxF5LZhSSjrjWPN/tilLq+OnH
         g5oauy0oFOfGzVIea9jpaYymiADOaeraerqXQYq7NTOEMDffWRqYdv0pXGPRoGPFT7tc
         YQcaqJ0GKGmeVREs3To5Vq9zZr6nbwB80hO94tDM8ljCEZer3XeOT0+6P0Gd4hAgPLyh
         e9vupwa3AEMW21feUEJOgAV/D+upkNdI3JwZq4JYqzkUVk7xUrX1ng6Mzzi5DwxqSESw
         EnCDa0Z0p8cwGd+Cic1XvzYTYcTa4HldMQ2yq0eZ+7lFBeOyphASAHAMT5LW+ccjRgke
         nolA==
X-Gm-Message-State: APjAAAUDKiUYqIAYX2fyB2zqQMmg/p6LRbfYoWVMFwb+/6ZihK1jABQL
        Le4lkZz8/eCKWLtY0S4yoN/pgfg6mmjlquHUbbIT89KXM0Xs
X-Google-Smtp-Source: APXvYqyDAf4ploxQXeYfC+CFYQgbOcopu+jJ1sXdRok24pSP1DcDyVjvzKS+bGYT+67jK4ftl65L/WTLJk3QASrrZ0jfVnqyzKD5
MIME-Version: 1.0
X-Received: by 2002:a24:2704:: with SMTP id g4mr1307352ita.36.1553717401059;
 Wed, 27 Mar 2019 13:10:01 -0700 (PDT)
Date:   Wed, 27 Mar 2019 13:10:01 -0700
In-Reply-To: <00000000000051ee78057cc4d98f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000c58fcf058519059e@google.com>
Subject: Re: general protection fault in put_pid
From:   syzbot <syzbot+1145ec2e23165570c3ac@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, clm@fb.com, dan.carpenter@oracle.com,
        dave@stgolabs.net, dhowells@redhat.com, dsterba@suse.com,
        dvyukov@google.com, ebiederm@xmission.com, jbacik@fb.com,
        ktkhai@virtuozzo.com, ktsanaktsidis@zendesk.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, manfred@colorfullife.com, mhocko@suse.com,
        nborisov@suse.com, penguin-kernel@I-love.SAKURA.ne.jp,
        penguin-kernel@i-love.sakura.ne.jp, rppt@linux.vnet.ibm.com,
        sfr@canb.auug.org.au, shakeelb@google.com,
        syzkaller-bugs@googlegroups.com, vdavydov.dev@gmail.com,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"; format=flowed; delsp=yes
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

syzbot has bisected this bug to:

commit b9b8a41adeff5666b402996020b698504c927353
Author: Dan Carpenter <dan.carpenter@oracle.com>
Date:   Mon Aug 20 08:25:33 2018 +0000

     btrfs: use after free in btrfs_quota_enable

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=14155a1f200000
start commit:   f5d58277 Merge branch 'for-linus' of git://git.kernel.org/..
git tree:       upstream
final crash:    https://syzkaller.appspot.com/x/report.txt?x=16155a1f200000
console output: https://syzkaller.appspot.com/x/log.txt?x=12155a1f200000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c8970c89a0efbb23
dashboard link: https://syzkaller.appspot.com/bug?extid=1145ec2e23165570c3ac
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=16803afb400000

Reported-by: syzbot+1145ec2e23165570c3ac@syzkaller.appspotmail.com
Fixes: b9b8a41adeff ("btrfs: use after free in btrfs_quota_enable")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
