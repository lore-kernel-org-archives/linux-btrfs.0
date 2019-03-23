Return-Path: <SRS0=xp1I=R2=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C8AC43381
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 08:30:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D7352218D4
	for <linux-btrfs@archiver.kernel.org>; Sat, 23 Mar 2019 08:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726026AbfCWIaG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 23 Mar 2019 04:30:06 -0400
Received: from mail-ot1-f48.google.com ([209.85.210.48]:40146 "EHLO
        mail-ot1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbfCWIaG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 23 Mar 2019 04:30:06 -0400
Received: by mail-ot1-f48.google.com with SMTP id x8so3972716otg.7
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Mar 2019 01:30:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=Ebx9YWh4xM8drslWVVZCHW946uqJH7cGCK3+HsW+10I=;
        b=D57WjI+tNZcXsleu7JfE27DwTIXIvYkRqocHEQrOE7Y2nRYnyA52nqXjig8dSjoq85
         NLlCbbuc6BCPjAREs/lFxgcbtuw973l9ygHo9lNLwPSqJIRtm6CC9mf+8aX1ugNNzx5e
         camplbZadJSlSSYL7nJSMZlImd4orIhVbS1DSG3tmcc16Kr+0oFfTudhKdExB8Yc9NMs
         jwsTR4jqPiU/5DegwPfIGhX81zw9f8xPexze8pAT0jZJAEC3lByABofole6+BkEeGBoa
         /TLdKo6hUKfh/y/hhwnnTnIL4mQBGA1keb4lzaLHFrjiyCdBsucN7uIDC9GSICfWD65q
         d31g==
X-Gm-Message-State: APjAAAUKpLLz7/qFa7LVN5PhZLAt5kvtB0x/NXFTwdSwgyz45bTy546U
        8E07Q/MzpXYAEB4F+rE8FN3Eve/ycQn11ZQ8ys0qPl0p
X-Google-Smtp-Source: APXvYqwc99Rao71zHVAk2TQfKsdftSwr5w0RPHs1wVoidcG1+4IIRZOwUZWSsFVqLoXi6kyQEiN31FWvXsl25ZK9Cjg=
X-Received: by 2002:a05:6830:15ce:: with SMTP id j14mr10523370otr.82.1553329804497;
 Sat, 23 Mar 2019 01:30:04 -0700 (PDT)
MIME-Version: 1.0
References: <trinity-49be13bc-b1ea-4ab2-81a5-6d32096c62fb-1553194614498@3c-app-webde-bap65>
 <trinity-774c74cd-2c34-408a-9705-459a561514f2-1553210614842@3c-app-webde-bs36>
 <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
In-Reply-To: <c59ce3ee-b0cd-f195-9dfa-11abd362d057@gmx.com>
From:   Thorsten Hirsch <t.hirsch@web.de>
Date:   Sat, 23 Mar 2019 09:29:53 +0100
Message-ID: <CAH+WbHwemzG5V2R81ZSHQXV7NF5pvpQ4X4pUEoZ-dtyD1_bp3w@mail.gmail.com>
Subject: Re: Fw: kernel oops when mounting btrfs
To:     linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Hi Qu,

thank you, but unfortunately that didn't work out so well. The tree
dump was no problem [1], but clearing the space cache resulted in a
core dump. Now btrfs check --readonly reports some errors. I attached
the output of these commands.

Thorsten

[1] https://gist.github.com/thorstenhirsch/65d4308ce54729c902cb09c0d4ad2baf

# btrfs check --clear-space-cache v1 /dev/nvme0n1p3
Opening filesystem to check...
Checking filesystem on /dev/nvme0n1p3
UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
Failed to find [544448348160, 168, 16384]
btrfs unable to find ref byte nr 544448364544 parent 0 root 2  owner 0 offset 0
transaction.c:195: btrfs_commit_transaction: BUG_ON `ret` triggered, value -5
btrfs(+0x3be68)[0x556936269e68]
btrfs(btrfs_commit_transaction+0x12a)[0x55693626a2ec]
btrfs(btrfs_clear_free_space_cache+0x32a)[0x55693625fecf]
btrfs(+0x4be5b)[0x556936279e5b]
btrfs(cmd_check+0x5c2)[0x556936284d86]
btrfs(main+0x1f6)[0x556936241ef6]
/lib/x86_64-linux-gnu/libc.so.6(__libc_start_main+0xeb)[0x7fb9a7911b6b]
btrfs(_start+0x2a)[0x556936241f3a]
Aborted (core dumped)


# btrfs check --readonly /dev/nvme0n1p3
Opening filesystem to check...
parent transid verify failed on 419860414464 wanted 30188 found 30105
parent transid verify failed on 419860414464 wanted 30188 found 30105
Ignoring transid failure
Checking filesystem on /dev/nvme0n1p3
UUID: 4284a794-ad75-450d-b023-ebc5e75f31f5
[1/7] checking root items
[2/7] checking extents
ref mismatch on [544448348160 16384] extent item 1, found 0
backref 544448348160 root 2 not referenced back 0x563ce432f010
incorrect global backref count on 544448348160 found 1 wanted 0
backpointer mismatch on [544448348160 16384]
owner ref check failed [544448348160 16384]
ref mismatch on [544448364544 16384] extent item 0, found 1
tree backref 544448364544 parent 2 root 2 not found in extent tree
backpointer mismatch on [544448364544 16384]
ERROR: errors found in extent allocation tree or chunk allocation
[3/7] checking free space cache
cache and super generation don't match, space cache will be invalidated
[4/7] checking fs roots
[5/7] checking only csums items (without verifying data)
[6/7] checking root refs
[7/7] checking quota groups skipped (not enabled on this FS)
ERROR: transid errors in file system
found 275464060928 bytes used, error(s) found
total csum bytes: 266882612
total tree bytes: 1513570304
total fs tree bytes: 1135788032
total extent tree bytes: 73220096
btree space waste bytes: 236694654
file data blocks allocated: 1962517999616
 referenced 221128466432
