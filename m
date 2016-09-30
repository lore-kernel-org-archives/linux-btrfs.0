Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qt0-f178.google.com ([209.85.216.178]:36837 "EHLO
        mail-qt0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751130AbcI3VHx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Sep 2016 17:07:53 -0400
Received: by mail-qt0-f178.google.com with SMTP id m5so1593799qtb.3
        for <linux-btrfs@vger.kernel.org>; Fri, 30 Sep 2016 14:07:53 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
References: <CAGfcS_m0KvAjmWpnGC7agLYBKROqjPoSCVrziaEJXzW1Dyw5iQ@mail.gmail.com>
 <94e50637-9f66-19c7-35e4-e6b2c8bf919c@suse.com> <CAGfcS_mLABcdd_3n=0cV8nx1DXoLBDFC6SbmMou_ZXWjw0BqRA@mail.gmail.com>
 <a8dac132-78b3-4276-2ed3-d30a74b0d31b@suse.com>
From: Rich Freeman <r-btrfs@gw.thefreemanclan.net>
Date: Fri, 30 Sep 2016 17:07:51 -0400
Message-ID: <CAGfcS_=2x-CqGwXXeWejiUoDTgy9HxAtPdy2Nur2CAMYT3d26A@mail.gmail.com>
Subject: Re: unable to handle kernel paging request - btrfs
To: Jeff Mahoney <jeffm@suse.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 30, 2016 at 4:55 PM, Jeff Mahoney <jeffm@suse.com> wrote:
> This looks like a use-after-free on one of the pages used for
> compression.  Can you post the output of objdump -Dr
> /lib/modules/$(uname -r)/kernel/fs/btrfs/btrfs.ko somewhere?
>

Sure:
https://drive.google.com/open?id=0BwUDImviY_gcR3JfT0Z1cUlRVEk

I was impressed by just how large it was.

I take it you're going to try to use the offsets in the oops to figure
out where it went wrong?  I really need to get kernel core dumping
working on this box...

--
Rich
