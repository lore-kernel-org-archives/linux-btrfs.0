Return-Path: <linux-btrfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32563CD37B0
	for <linux-btrfs@archiver.kernel.org>; Mon, 18 Sep 2023 08:40:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233682AbjIRIkS (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 18 Sep 2023 04:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35102 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240867AbjIRIjm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 18 Sep 2023 04:39:42 -0400
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B2A0CD
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2023 01:39:36 -0700 (PDT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-6bf0c48641cso6060504a34.3
        for <linux-btrfs@vger.kernel.org>; Mon, 18 Sep 2023 01:39:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695026375; x=1695631175;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=45KiI20BMzkbiSraX+XzVv0AVcWyW8x18IOZnldh45c=;
        b=R8lDFyCriCPWdJirKbHoJeRjIo2ZYyya02puqBIUgwgtAkZKaRnHFUGxowjPl2t8uE
         PJ9/qMMUDcxWeyIRkX1P3lDEbfwBvAL3vXi/COzxuuxyQeVy0dfkcufS98dSXm3nJNM8
         ZIwWmDgfxhFLGsFrQBPKlEJnw82bWuEsNFYHDrZ4THgTt4cMIg8X4Z1coNRDLIAlnkqh
         YbwCjvM73ej0BIML8JX8aK04Rh/+rbV493HnAlCx4bp9phOybU7C6gumWzdO9TGmNsuT
         jJnrGhG9jZrbWYWOX03QI5kfIb4T3vnL7ERXONd62r4RXWPfdhrgYIojNpzFAWRX3nzc
         L/4Q==
X-Gm-Message-State: AOJu0YwTyU34vUjdd2ESfVH+5NztWzs2xhG1cJX2u94plVDPeZUqqyqx
        z2IP6nl3P0o4wqMv6dhY0eMEhZ7iromETglzz4wrD4WrbI8d
X-Google-Smtp-Source: AGHT+IHaw4qvgyW8P05njsrzZAVkQ398quj849dW1jRa7JJ/jRsXyO7iZr2gFbrajDFa9tDv+JBzQkZ5g1fDTUwzzq5aAw65zZbp
MIME-Version: 1.0
X-Received: by 2002:a9d:77c9:0:b0:6b9:182b:cebc with SMTP id
 w9-20020a9d77c9000000b006b9182bcebcmr2559764otl.7.1695026375542; Mon, 18 Sep
 2023 01:39:35 -0700 (PDT)
Date:   Mon, 18 Sep 2023 01:39:35 -0700
In-Reply-To: <0000000000003a29fe05feb87e4e@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000ffccbc06059e1493@google.com>
Subject: Re: [syzbot] [btrfs?] WARNING in btrfs_run_delayed_refs (2)
From:   syzbot <syzbot+810ea5febd3b79bdd384@syzkaller.appspotmail.com>
To:     clm@fb.com, dsterba@suse.com, fdmanana@suse.com,
        josef@toxicpanda.com, linux-btrfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

syzbot has bisected this issue to:

commit f8f210dc84709804c9f952297f2bfafa6ea6b4bd
Author: Filipe Manana <fdmanana@suse.com>
Date:   Tue Mar 21 11:13:59 2023 +0000

    btrfs: calculate the right space for delayed refs when updating global reserve

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=12fb487fa80000
start commit:   dad9774deaf1 Merge tag 'timers-urgent-2023-06-21' of git:/..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=11fb487fa80000
console output: https://syzkaller.appspot.com/x/log.txt?x=16fb487fa80000
kernel config:  https://syzkaller.appspot.com/x/.config?x=e74b395fe4978721
dashboard link: https://syzkaller.appspot.com/bug?extid=810ea5febd3b79bdd384
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=13ceaa3f280000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1502f600a80000

Reported-by: syzbot+810ea5febd3b79bdd384@syzkaller.appspotmail.com
Fixes: f8f210dc8470 ("btrfs: calculate the right space for delayed refs when updating global reserve")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
