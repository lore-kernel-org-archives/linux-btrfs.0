Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f173.google.com ([209.85.216.173]:33550 "EHLO
        mail-qt0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdIEMtx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 08:49:53 -0400
Received: by mail-qt0-f173.google.com with SMTP id i50so11499147qtf.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 05:49:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <533ebd2e-8b95-d875-4cbc-48821b150eac@gmail.com>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru> <20170904105444.GA23980@carfax.org.uk>
 <533ebd2e-8b95-d875-4cbc-48821b150eac@gmail.com>
From: Henk Slager <eye1tm@gmail.com>
Date: Tue, 5 Sep 2017 14:49:51 +0200
Message-ID: <CAPmG0jZApuPggvJ98Ko9Yps+N3ixNjAEzTgfDNWoqa2a_Tdd2w@mail.gmail.com>
Subject: Re: Is autodefrag recommended?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 5, 2017 at 1:45 PM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>>   - You end up duplicating more data than is strictly necessary. This
>>     is, IIRC, something like 128 KiB for a write.
>
> FWIW< I'm pretty sure you can mitigate this first issue by running a regular
> defrag on a semi-regular basis (monthly is what I would probably suggest).

No, both autodefrag and regular defrag duplicate data, so if you keep
snapshots around for weeks or months, it can eat up a significant
amount of space.
