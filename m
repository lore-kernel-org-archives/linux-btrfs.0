Return-Path: <SRS0=E4Z9=YI=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1F71C10F14
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 18:33:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 74DE720854
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Oct 2019 18:33:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kvFCmznX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729346AbfJOSdZ (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Oct 2019 14:33:25 -0400
Received: from mail-ed1-f46.google.com ([209.85.208.46]:37703 "EHLO
        mail-ed1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727200AbfJOSdZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Oct 2019 14:33:25 -0400
Received: by mail-ed1-f46.google.com with SMTP id r4so18981229edy.4
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Oct 2019 11:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=sBiaXyxKlS5qXgzHazyCUolIGjCTSvTxtcFusRMBP8Q=;
        b=kvFCmznX8JWodVbd8V7NmEfq3cpjy49wKklLsaxUnv8pC085W1Bxt75TI4e8UaN8k1
         BzrSnv6/WiDpScNcqIT2p05gv7bp6VoBEHtuzAWmhBgQHevpnODVLGj3zQzv6CekxD9A
         l86fbjioWRwZ0JfakwsVrtPWWtGN90TmSoyjmfCjadf9hQAfoBq1MjBcaJYWwieedeVV
         gsvcrznLdQJdkTO8RgpKrTqt508QqJ0CjII7SetfqW0CWtXzY3efccuNz50f3vuvI1Yd
         M7XOmKcNPSGPzoEFQxfHdmAJePmZFJiyOhqKo76oof57wySMM2FukGVe2TnGtb5PbG2k
         0t9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=sBiaXyxKlS5qXgzHazyCUolIGjCTSvTxtcFusRMBP8Q=;
        b=C5pzMYTw+7EpZsLo12Og5xDFxhPJjhZ7XOduTbtOr5+UANPn2gojN5Em1ZNqvokMUS
         kNv1j73reC5aGQeCy8iRjiuwhClrNmhVm8gmXK/gT+ztx2iroRhCxONG5myfwjxxEAb4
         fPCA+gTBstRVuv5AyDtMuaG+D7qIfRpdmPAGUTdNcHf9cRojjjvz/RO/NuQj/yS4j7hK
         bXrCJC1eRUnHlSADOspxdv8hCLDR4KUjx42fyVrnznuGyijsvCEmFAY3wJQU9c7+JKst
         LfjdZQI/klkrE9sqR6xIK3M6ca0o8ePcT1U/pB6gmmumuxMGjlr2jg7g2SwR83A5XKHf
         bB4Q==
X-Gm-Message-State: APjAAAWY77bmRk4j9ozCtrLHVZFexILvT0aW+xHBuAk/xGsFUHhIbHSP
        ThcPh+GT7H6P700RKgr3S7cncvoaK5jqqj3kG6TdrHrb
X-Google-Smtp-Source: APXvYqweKJroGeobvp1GxfK2JG9wRZsysoMEOlB030u6560kUsMi8IpdgM1Dp2PHlEe1Arxt4gH69T+cawN7X5Tj5q0=
X-Received: by 2002:a17:906:7d10:: with SMTP id u16mr36471682ejo.329.1571164401976;
 Tue, 15 Oct 2019 11:33:21 -0700 (PDT)
MIME-Version: 1.0
From:   Meng Xu <mengxu.gatech@gmail.com>
Date:   Tue, 15 Oct 2019 14:33:11 -0400
Message-ID: <CAAwBoOJDjei5Hnem155N_cJwiEkVwJYvgN-tQrwWbZQGhFU=cA@mail.gmail.com>
Subject: potential data race on `delayed_rsv->full`
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Btrfs maintainers,

I am reporting a potential data race around the `delayed_rsv->full` field.

[thread 1] mount a btrfs image, a kernel thread of uuid_rescan will be created

btrfs_uuid_rescan_kthread
  btrfs_end_transaction
    __btrfs_end_transaction
      btrfs_trans_release_metadata
        btrfs_block_rsv_release
          __btrfs_block_rsv_release
            --> [READ] else if (block_rsv != global_rsv && !delayed_rsv->full)
                                                            ^^^^^^^^^^^^^^^^^


[thread 2] do a mkdir syscall on the mounted image

__do_sys_mkdir
  do_mkdirat
    vfs_mkdir
      btrfs_mkdir
        btrfs_new_inode
          btrfs_insert_empty_items
            btrfs_cow_block
              __btrfs_cow_block
                alloc_tree_block_no_bg_flush
                  btrfs_alloc_tree_block
                    btrfs_add_delayed_tree_ref
                      btrfs_update_delayed_refs_rsv
                        --> [WRITE] delayed_rsv->full = 0;
                                    ^^^^^^^^^^^^^^^^^^^^^


I could confirm that this is a data race by manually adding and adjusting
delays before the read and write statements although I am not very sure
about the implication of such a data race (e.g., crashing btrfs or causing
violations of assumptions). I would appreciate if you could help check on
this potential bug and advise whether this is a harmful data race or it
is intended.

Best Regards,
Meng
