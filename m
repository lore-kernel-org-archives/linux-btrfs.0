Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f176.google.com ([209.85.217.176]:36416 "EHLO
        mail-ua0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751039AbdEJULF (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 10 May 2017 16:11:05 -0400
Received: by mail-ua0-f176.google.com with SMTP id j17so7936332uag.3
        for <linux-btrfs@vger.kernel.org>; Wed, 10 May 2017 13:11:04 -0700 (PDT)
MIME-Version: 1.0
From: Xiaochu Liu <xiaochu@chromium.org>
Date: Wed, 10 May 2017 13:11:03 -0700
Message-ID: <CAGN98i72XfTo5Pjodn0MF20S_yCqXh026Ai_BP+n_X_G4yF2nw@mail.gmail.com>
Subject: Question on compression unit
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi there,

I'm trying to tune compression options for btrfs. Specifically, I want
to know the performance impact on the system under different
compression unit (block) sizes.

I'm aware of '--nodesize' parameter which sets the block size of
metadata tree. Does that also set the block size in an extent? (from
my understanding, file data are mostly stored in extent unless small
enough to be inline-d in metadata leaf node?)

Also from btrfs's wikipedia page:

In compressed extents, individual blocks are not compressed
separately; rather, the compression stream spans the entire extent.

Is that still true?

Thanks,
Xiaochu
