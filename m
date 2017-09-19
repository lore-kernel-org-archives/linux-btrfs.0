Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f170.google.com ([209.85.223.170]:57102 "EHLO
        mail-io0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751377AbdISPga (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Sep 2017 11:36:30 -0400
Received: by mail-io0-f170.google.com with SMTP id m103so949557iod.13
        for <linux-btrfs@vger.kernel.org>; Tue, 19 Sep 2017 08:36:29 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Tue, 19 Sep 2017 18:35:48 +0300
Message-ID: <CAGqmi74kxPpkuYCBwfdyzxUKAHE6TP9x1FGDz0FURud21u=nOA@mail.gmail.com>
Subject: Does btrfs use crc32 for error correction?
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Stupid question:
Does btrfs use crc32 for error correction?
If no, why?

(AFAIK if using CRC that possible to fix 1 bit flip)

P.S. I try check that (i create image, create text file, flip bit, try
read and btrfs show IO-error)

Thanks!
-- 
Have a nice day,
Timofey.
