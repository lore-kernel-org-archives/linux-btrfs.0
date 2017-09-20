Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:53931 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751465AbdITUbr (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 20 Sep 2017 16:31:47 -0400
Received: by mail-io0-f179.google.com with SMTP id q11so6333896ioe.10
        for <linux-btrfs@vger.kernel.org>; Wed, 20 Sep 2017 13:31:47 -0700 (PDT)
MIME-Version: 1.0
From: Timofey Titovets <nefelim4ag@gmail.com>
Date: Wed, 20 Sep 2017 23:31:05 +0300
Message-ID: <CAGqmi76MPGYFiksk5Jt05wjhQoQXpQuu1CiJFhxQw8QEB0gPpw@mail.gmail.com>
Subject: RFC: Btrfs does not store checksum type? Only size? O_o
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

I was reading the kernel code and docs and didn't find anything about
some info like "cheksum type" as btrfs have for compression code.
(I only found some silent "hack" in btrfs-progs, that print "checksum
type", but get "checksum size")

If i understood all correctly btrfs only store checksum size, i.e. 4
for current CRC32C.

May be that can be useful to rewrite some part of code and reuse
checksum size, as checksum type.

For backward compatibility current CRC32C size can be used for identify CRC32C.
As that will not add any new checksum, that allow make that with zero "blood".
And later if we add new checksum type, that possible to add compat
flag for that.

What you think?

Thanks.
-- 
Have a nice day,
Timofey.
