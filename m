Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8AB7FA3740
	for <linux-btrfs@archiver.kernel.org>; Mon, 31 Oct 2022 11:51:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiJaLv2 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 31 Oct 2022 07:51:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiJaLvZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 31 Oct 2022 07:51:25 -0400
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF18EE18
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Oct 2022 04:51:24 -0700 (PDT)
Received: by mail-io1-f71.google.com with SMTP id bf14-20020a056602368e00b006ce86e80414so1625273iob.7
        for <linux-btrfs@vger.kernel.org>; Mon, 31 Oct 2022 04:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=haYtoHZzLu1c3fU5UhA6SNsl7G50nkj72w4dRbQTGJY=;
        b=GxOMexQ5mFtOa8SH7wieSjIENYBljjyPsTqBrd6LHmqgT+/wC7V7O0FIUmPClAnuDG
         moF5D9IXSabB5VkF/GIBMYOOjq+Mr/pWxbOd7DwXd6iwYM7elBLHIV8fRfTurdhN+Ya6
         qpDGd1vRJPkcWfdEN1NVe2+xdX7cCVMoci0B99atATGOPAa2DrTGGlK8k7wwi6UOUnZ0
         YhkG3Irz705kJcwYnVj5SZJmGnBBxkqXa8ew1bc9iNATbewW0TDqGI86/Bhm6ffd979s
         OjGHLbtbulTF9K47Td952z8I8/A42tbMC4t226Uy5kzITTJNrD9xJCSR6/wjkBQJRvqK
         e+kw==
X-Gm-Message-State: ACrzQf0DSSLzNl27hP18XOgJsVNYfQ5cb5i8hXcrm3KdUdveGM/hx1+n
        /I1CFAn2s+Ph3nBHjyJh5I8kiFJ02bPmgU+6vpIFy47oHvZ6
X-Google-Smtp-Source: AMsMyM6ex36MV4sCm64SwH7pDQSoXkZTsQsQ1ixuzILeIZAl4lj0NDEDqIUdlAAG/TDwVsD2JfpNn8LNJ6qJiJmywvHWPelKBE/p
MIME-Version: 1.0
X-Received: by 2002:a05:6638:388c:b0:370:cb35:edfd with SMTP id
 b12-20020a056638388c00b00370cb35edfdmr7330870jav.181.1667217082694; Mon, 31
 Oct 2022 04:51:22 -0700 (PDT)
Date:   Mon, 31 Oct 2022 04:51:22 -0700
In-Reply-To: <0000000000000d9d6f05ec498263@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000fa42c105ec5339ec@google.com>
Subject: Re: [syzbot] WARNING in btrfs_space_info_update_bytes_may_use
From:   syzbot <syzbot+8edfa01e46fd9fe3fbfb@syzkaller.appspotmail.com>
To:     akpm@linux-foundation.org, clm@fb.com, dsterba@suse.com,
        hch@lst.de, josef@toxicpanda.com, linmiaohe@huawei.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, torvalds@linux-foundation.org,
        willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

syzbot has bisected this issue to:

commit 0c7c575df56b957390206deb018c41acbb412159
Author: Matthew Wilcox (Oracle) <willy@infradead.org>
Date:   Wed Feb 24 20:01:52 2021 +0000

    mm/filemap: remove dynamically allocated array from filemap_read

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=119e21b6880000
start commit:   b229b6ca5abb Merge tag 'perf-tools-fixes-for-v6.1-2022-10-..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=139e21b6880000
console output: https://syzkaller.appspot.com/x/log.txt?x=159e21b6880000
kernel config:  https://syzkaller.appspot.com/x/.config?x=a66c6c673fb555e8
dashboard link: https://syzkaller.appspot.com/bug?extid=8edfa01e46fd9fe3fbfb
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17db9ab1880000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=124e21b6880000

Reported-by: syzbot+8edfa01e46fd9fe3fbfb@syzkaller.appspotmail.com
Fixes: 0c7c575df56b ("mm/filemap: remove dynamically allocated array from filemap_read")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
