Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:33677 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753461AbcHXR46 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 24 Aug 2016 13:56:58 -0400
Received: by mail-oi0-f46.google.com with SMTP id c15so33410852oig.0
        for <linux-btrfs@vger.kernel.org>; Wed, 24 Aug 2016 10:56:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
References: <CAJCQCtT5YA9EMq1ZC-qeZcNLUeg1GocBm3nT2nZFEBigmV4BxQ@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 24 Aug 2016 11:30:53 -0600
Message-ID: <CAJCQCtQjX+0nAWRNPK2gYNoi8wvHxTMEzm6v84PZKXnTLxc50Q@mail.gmail.com>
Subject: Re: btrfs-progs 4.7, check reports many "incorrect local backref
 count" messages
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[chris@f24s ~]$ sudo btrfs dev stats /brick1
[/dev/mapper/brick1].write_io_errs   0
[/dev/mapper/brick1].read_io_errs    0
[/dev/mapper/brick1].flush_io_errs   0
[/dev/mapper/brick1].corruption_errs 0
[/dev/mapper/brick1].generation_errs 0

[chris@f24s ~]$ sudo btrfs scrub status /brick1
scrub status for 30f4724a-9a9f-4a5d-a37d-3e53876bf2e1
    scrub started at Wed Aug 24 10:07:10 2016 and finished after 01:22:15
    total bytes scrubbed: 394.91GiB with 0 errors

And metadata is DUP.
