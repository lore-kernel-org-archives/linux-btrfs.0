Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr1-f66.google.com ([209.85.221.66]:37752 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbeIFL5l (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 6 Sep 2018 07:57:41 -0400
Received: by mail-wr1-f66.google.com with SMTP id u12-v6so10162904wrr.4
        for <linux-btrfs@vger.kernel.org>; Thu, 06 Sep 2018 00:23:37 -0700 (PDT)
MIME-Version: 1.0
From: Nathan Dehnel <ncdehnel@gmail.com>
Date: Thu, 6 Sep 2018 02:23:25 -0500
Message-ID: <CAEEhgEtgahZjLd-Uy-sFSc+36pNNUOa82sadJgBcbWKvPYsLiA@mail.gmail.com>
Subject: Transactional btrfs
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

https://lwn.net/Articles/287289/

In 2008, HP released the source code for a filesystem called advfs so
that its features could be incorporated into linux filesystems. Advfs
had a feature where a group of file writes were an atomic transaction.

https://www.usenix.org/system/files/conference/fast15/fast15-paper-verma.pdf

These guys used advfs to add a "syncv" system call that makes writes
across multiple files atomic.

https://lwn.net/Articles/715918/

A patch was later submitted based on the previous paper in some way.

So I guess my question is, does btrfs support atomic writes across
multiple files? Or is anyone interested in such a feature?
