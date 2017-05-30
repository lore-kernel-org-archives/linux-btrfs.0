Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f50.google.com ([209.85.218.50]:35808 "EHLO
        mail-oi0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751081AbdE3QNV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 30 May 2017 12:13:21 -0400
Received: by mail-oi0-f50.google.com with SMTP id l18so117387343oig.2
        for <linux-btrfs@vger.kernel.org>; Tue, 30 May 2017 09:13:20 -0700 (PDT)
MIME-Version: 1.0
From: Sargun Dhillon <sargun@sargun.me>
Date: Tue, 30 May 2017 09:12:39 -0700
Message-ID: <CAMp4zn9Qqx_T03-Vn6zZxo3OkTRfWeHrgOkefmc4JdzzfswAyA@mail.gmail.com>
Subject: Debugging Deadlocks?
To: BTRFS ML <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

We've been running BtrFS for a couple months now in production on
several clusters. We're running on Canonical's 4.8 kernel, and
currently, in the process of moving to our own patchset atop vanilla
4.10+. I'm glad to say it's been a fairly good experience for us. Bar
some performance issues, it's been largely smooth sailing.

There has been one class of persistent issues that has been plaguing
our cluster is deadlocks. We've seen a fair number of issues where
there are some number of background threads and user threads are in
the process of performing operations where some are waiting to start a
transaction, and at least one background thread or user thread is in
the process of committing a transaction. Unfortunately, these
situations are ending in deadlocks, where no threads are making
progress.

We've talked about a couple ideas internally, like adding the ability
to timeout transactions, abort commits or start_transactions which are
taking too long, and adding more debugging to get insights into the
state of the filesystem. Unfortunately, since our usage and knowledge
of BtrFS is still somewhat nascent, we're unsure of what is the right
investment.

I'm curious, are other people seeing deadlocks crop up in production
often? How are you going about debugging them, and are there any good
pieces of advice on avoiding these for production workloads?
