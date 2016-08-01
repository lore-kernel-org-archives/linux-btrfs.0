Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:35309 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753867AbcHAPxI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Aug 2016 11:53:08 -0400
Received: by mail-oi0-f54.google.com with SMTP id l72so198315118oig.2
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Aug 2016 08:52:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
References: <CAJCQCtQ4CXjBzR6eo0zibDCb9_p0jAiS2q_fCRUkUNVWiM9i6g@mail.gmail.com>
 <CAJCQCtQ8yPQf8O2LA92-Gd95GGXQiDp-ZomKZgP4bNv-MmKHYw@mail.gmail.com>
 <ac28e105-f228-de18-08c2-e504e304052d@gmail.com> <CAJCQCtQahbHJhcyKrdRGLNuzbd7MUL11nGBpiQ2U40nAn1ve2w@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 1 Aug 2016 09:52:57 -0600
Message-ID: <CAJCQCtRM14Bik=KcemzhdBFAFGniO28L9_3uPyaa5QO70BZOgg@mail.gmail.com>
Subject: Re: systemd KillUserProcesses=yes and btrfs scrub
To: Chris Murphy <lists@colorremedies.com>
Cc: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 1, 2016 at 9:46 AM, Chris Murphy <lists@colorremedies.com> wrote:

> - The kernel workers are killed off within ~5 seconds of an
> uninterrupted scrub.

i.e. the kernel workers are doing the same work. They aren't being
killed sooner as a result of logging out from the DE. The only
apparent change from logging out from the DE from which the scrub was
issued, is the btrfs process becomes status Z. It is in fact not being
killed, which itself is kinda interesting/unexpected.


-- 
Chris Murphy
