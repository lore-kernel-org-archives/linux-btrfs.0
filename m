Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ua0-f181.google.com ([209.85.217.181]:36183 "EHLO
        mail-ua0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751982AbdGYMzi (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 25 Jul 2017 08:55:38 -0400
Received: by mail-ua0-f181.google.com with SMTP id k43so65439997uaf.3
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Jul 2017 05:55:38 -0700 (PDT)
MIME-Version: 1.0
From: =?UTF-8?Q?H=C3=A9rikz_Nawarro?= <herikz.nawarro@gmail.com>
Date: Tue, 25 Jul 2017 09:55:37 -0300
Message-ID: <CAD6NJSxuix4N=kPbQ_=QRnKP4Ny6kLyVyEA4p=PvBfgtbwrUHw@mail.gmail.com>
Subject: btrfs raid assurance
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello everyone,

I'm migrating to btrfs and i would like to know, in a btrfs filesystem
with 4 disks (multiple sizes) with -d raid0 & -m raid1, how many
drives can i lost without losing the entire array?

Cheers.
