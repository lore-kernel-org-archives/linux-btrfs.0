Return-Path: <SRS0=BAu1=RF=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F845C43381
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 03:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E667C20823
	for <linux-btrfs@archiver.kernel.org>; Sat,  2 Mar 2019 03:23:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=colorremedies-com.20150623.gappssmtp.com header.i=@colorremedies-com.20150623.gappssmtp.com header.b="qQjkpq/A"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfCBDXL (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 1 Mar 2019 22:23:11 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:42546 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726412AbfCBDXL (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Fri, 1 Mar 2019 22:23:11 -0500
Received: by mail-lj1-f194.google.com with SMTP id d14so22147394ljl.9
        for <linux-btrfs@vger.kernel.org>; Fri, 01 Mar 2019 19:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=B0YqeGpqYLRKu4VMKHs3p0hhMwWII1XxtLkE/DH7wgY=;
        b=qQjkpq/A8O4lMMDFdG1M8QGkWGtdnu8jXCmiiDBVeXYPnrG234S2G8f7B3HrmCziWk
         XHLdpz+rgNyBJpuyNR+kdZN+tmB7iGec2AZTajJHK+A+Elbb1GtNCdVr/Pw7/HCuC2LJ
         m7I9/HrEdEBJrZj3dioSgN1BItlALi4EA0lCvW/BPHTjS8zVm2jd1/jKDn1RH7YyYOOF
         yXueK+iBCeSqJ4WC5nYlPGYikjv14G8Re7yjlVYRVYZfOR5WBGBjrxjEC4Do2tTJJNXp
         pZes7XcNYhW4Bj6P9/WpHswR+pynGvWAPA7IUG/QEukmaDZI83jrzJcNwaW3usMG4Lod
         DTMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=B0YqeGpqYLRKu4VMKHs3p0hhMwWII1XxtLkE/DH7wgY=;
        b=J1JQQBAGbl8f639N0tF5Zspeb8333u4wynHxSlioMBa4pvfBb8dI75mmaxq75AbVHA
         y9A6MBR2UZYI8XvDlnce6jq4M7JNFym7Y805Wr5xSDXGSVkLZKxdd7499igFUfr2+dNB
         efhpGiO7nzR7jwgtWzKlNljJUbk6LgxyIKW04KXQg+JNZATURRAisOYQrmQuxET4FtV8
         KW0/ewR9yLw0S57G4N/xEp16uCwrzWZ5pEjexandlRAwyYAsZ7b7rus3c+QFWTzldqbB
         WipDtKCog6PIyHWkbKI4AJjuLQ5hSRNl4Y/gPXKllKAWBpWj6rsE9slGYPInUInagi5V
         qrlA==
X-Gm-Message-State: APjAAAUhnNT1yhz11SkzrzlRUP+7apCEm4mZRInhMD60NUwUA/4DfOwF
        zSCvORrhYTL/enVeRDsuOR5OdKM3ibTOTdU91CwC4FbqCUEecA==
X-Google-Smtp-Source: APXvYqwYUCB4auQ5d0aQt1ZeytIG8q7mnT84+uZ9FOrbOixgZZkBC7KMj0np44yezzoLpFGykTnhG8XAQj5rhxKhCso=
X-Received: by 2002:a2e:2419:: with SMTP id k25mr4452015ljk.38.1551496989438;
 Fri, 01 Mar 2019 19:23:09 -0800 (PST)
MIME-Version: 1.0
References: <CAJCQCtQrLLpX8uZwp2BYfgaF1QPfuf1_XRjVxG24cbDHfEo2uA@mail.gmail.com>
 <4dfdc5a4-a6d7-e96b-afa1-a9c71b123a96@gmx.com> <CAJCQCtT+VnSp_8i-QWT6iwCv9yaqQv2XfsVtsdvQmoG70aQZ7w@mail.gmail.com>
 <CAJCQCtQvi77SZbL4_fK1B5jNRpYhWOHBQOKvZ2Pdr8AoJDBXBg@mail.gmail.com> <CAJCQCtQaQ0XFUGFdWfgwmTSPTUShrZgXmsh55c-reS9iS+WpFg@mail.gmail.com>
In-Reply-To: <CAJCQCtQaQ0XFUGFdWfgwmTSPTUShrZgXmsh55c-reS9iS+WpFg@mail.gmail.com>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Fri, 1 Mar 2019 20:22:58 -0700
Message-ID: <CAJCQCtRyU0rohrfy0VL1Xtxc=pH18y146b6uNz7SD6aFwayGRQ@mail.gmail.com>
Subject: Re: [bug] btrfs check clear-space-cache v1 corrupted file system
To:     Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Qu Wenruo <quwenruo.btrfs@gmx.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Two more strange things:

# btrfs check -r 930086912 /dev/mapper/sdd
Opening filesystem to check...
parent transid verify failed on 930086912 wanted 4514 found 4076
parent transid verify failed on 930086912 wanted 4514 found 4076
parent transid verify failed on 930086912 wanted 4514 found 4076
parent transid verify failed on 930086912 wanted 4514 found 4076
Ignoring transid failure
Checking filesystem on /dev/mapper/sdd
UUID: f5adc913-bbea-4340-8b5f-3411e2cda642
[1/7] checking root items
parent transid verify failed on 713084665856 wanted 3425 found 4333
parent transid verify failed on 713084665856 wanted 3425 found 4333
parent transid verify failed on 713084665856 wanted 3425 found 4333
parent transid verify failed on 713084665856 wanted 3425 found 4333
Ignoring transid failure
parent transid verify failed on 713050619904 wanted 3461 found 4404
parent transid verify failed on 713050619904 wanted 3461 found 4404
parent transid verify failed on 713050619904 wanted 3461 found 4404
parent transid verify failed on 713050619904 wanted 3461 found 4404
Ignoring transid failure
ERROR: child eb corrupted: parent bytenr=672006144 item=178 parent
level=1 child level=1
ERROR: failed to repair root items: Input/output error
#

dmesg most recent messages are four hours ago, nothing at the time of
this input/output error.
Mar 01 16:19:24 fnuc.local kernel: BTRFS info (device dm-2): disk
space caching is enabled
Mar 01 16:19:24 fnuc.local kernel: BTRFS info (device dm-2): has skinny extents



And next, why are backup 1 and backup 3 the same except for the gen
for tree, extent, and csum roots? The addresses are all the same. How
is that COW?

backup 1:
        backup_tree_root:    930086912    gen: 4076    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1

    backup 3:
        backup_tree_root:    930086912    gen: 4074    level: 1
        backup_chunk_root:    822549151744    gen: 3823    level: 1

When I go inspect that address, it's of course generation 4076. So
this backup 3 slot is actually invalid, it's already been overwritten.

Anyway, if you need more than just the extent tree, I need a hint on
how to sanitize file names. I tried looking through the archives, I
thought you posted a sed trick to do that with debug-tree but I can't
find it. And I know you don't like btrfs-image -s or -ss.


---
Chris Murphy
