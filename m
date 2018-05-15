Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36960 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752078AbeEOAPT (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 20:15:19 -0400
Received: by mail-oi0-f67.google.com with SMTP id w123-v6so12374954oia.4
        for <linux-btrfs@vger.kernel.org>; Mon, 14 May 2018 17:15:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <f6da1d59-c68a-9adb-464f-629b94067538@gmx.com>
References: <20180514070210.27047-1-wqu@suse.com> <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu> <CA+X5Wn6HNAz2xXSU3Rj9BqnfFCLd2EqOnWGhmjC-a4qMHzO1bQ@mail.gmail.com>
 <f6da1d59-c68a-9adb-464f-629b94067538@gmx.com>
From: james harvey <jamespharvey20@gmail.com>
Date: Mon, 14 May 2018 20:15:18 -0400
Message-ID: <CA+X5Wn4Bd38ZtrG8eewpPcac=vG6neB8HFE6Z-WjoYVM0oC_1A@mail.gmail.com>
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW set
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Roman Mamedov <rm@romanrm.net>, Nikolay Borisov <nborisov@suse.com>,
        Qu Wenruo <wqu@suse.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Don't know if this will help.  I just learned about pstore, and see in
there a dmesg that's interesting.

The serial port kernel errors started this time with "BUG: unable to
handle kernel paging request".  The pstore dmesg has everything from
there until the end of the first trace.

But, the interesting part is the pstore dmesg has 310 "BTRFS:
decompress failed" messages the serial port (the versions I've shared)
version doesn't. (Sometimes the serial crashes have 1 of these btrfs
errors, but never repeated like this.)

These 310 btrfs errors are all uptime-stamped from 13110.016096 -
13110.253752, when the BUG is later at 13110.370494 (when the serial
errors start.)

With the kernel trying to decompress 310 times within 0.237656
seconds, maybe that's an indication with invalid data, it retries
forever in a bad way crashing the kernel, rather than failing?
