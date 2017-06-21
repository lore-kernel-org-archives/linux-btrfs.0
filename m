Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:33031 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752454AbdFUDzO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 20 Jun 2017 23:55:14 -0400
Received: by mail-wr0-f179.google.com with SMTP id r103so116635604wrb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 20 Jun 2017 20:55:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAAsnU-9FqoT=gFFsJ7paCRgkXXfJJts9K+E-5_cca33yOUJc+w@mail.gmail.com>
References: <CAAsnU-9FqoT=gFFsJ7paCRgkXXfJJts9K+E-5_cca33yOUJc+w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 20 Jun 2017 21:55:12 -0600
Message-ID: <CAJCQCtRi=+OwMy4K2MyWf7v_wL5Sti8iNYLhKhLPNyJB80C_ug@mail.gmail.com>
Subject: Re: Please help. Repair probably bitflip damage and suspected bug
To: Jesse <btrfs_mail_list@mymail.isbest.biz>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
[Sun Jun 18 04:02:43 2017] BTRFS critical (device sdb2): corrupt node,
bad key order: block=5123372711936, root=1, slot=82


>From the archives, most likely it's bad RAM. I see this system also
uses XFS v4 file system, if it were made as XFS v5 using metadata
csums you'd probably eventually run into a similar problem that would
be caught by metadata checksum errors. It'll fail faster with Btrfs
because it's checksumming everything.


Chris Murphy
