Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f44.google.com ([209.85.215.44]:36368 "EHLO
        mail-lf0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932870AbcIFPW1 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 6 Sep 2016 11:22:27 -0400
Received: by mail-lf0-f44.google.com with SMTP id g62so148856699lfe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 06 Sep 2016 08:22:27 -0700 (PDT)
MIME-Version: 1.0
From: Tomasz Kusmierz <tom.kusmierz@gmail.com>
Date: Tue, 6 Sep 2016 16:22:25 +0100
Message-ID: <CAKinxcXinpdj5ZNrXSBegLn+2LnbYtwChX=3wBP_UELSPa+yig@mail.gmail.com>
Subject: Some help with the code.
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

This is predominantly for maintainers:

I've noticed that there is a lot of code for btrfs ... and after few
glimpses I've noticed that there are occurrences which beg for some
refactoring to make it less of a pain to maintain.

I'm speaking of occurrences where:
- within a function there are multiple checks for null pointer and
then whenever there is anything hanging on the end of that pointer to
finally call the function, pass the pointer to it and watch it perform
same checks to finally deallocate stuff on the end of a pointer.
- single line functions ... called only in two places

and so on.

I know that you guys are busy, but maintaining code that is only
growing must be a pain.
