Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:39929 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753732AbdL2Dft (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 28 Dec 2017 22:35:49 -0500
Received: by mail-io0-f172.google.com with SMTP id g70so27522489ioj.6
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Dec 2017 19:35:49 -0800 (PST)
MIME-Version: 1.0
Reply-To: swestrup@gmail.com
In-Reply-To: <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
References: <CAJt7KB-ORv77HBRzZrDymu-17BhmEjF9GQjC=bAQ2065fCpqog@mail.gmail.com>
 <c10a5117-7ffc-cda1-d396-0f2624288551@gmx.com> <439f024c-0061-9625-26f2-69002a6ea797@gmail.com>
 <178207b8-cf76-c112-0cce-fc326975f459@gmx.com> <CAJt7KB9sLArgDapkoypY-DnqFepX4R38E4RFOPUE6Adw9bdWkQ@mail.gmail.com>
 <dcdb28de-de4a-402f-f38a-790f509be95b@gmx.com> <CAJt7KB80n0qRViS7p8nRRNYNC1ivMtPJu-ec35vrVNfZ+AWvSA@mail.gmail.com>
 <ba3f9db1-fbc4-cd87-7d3e-b7f1fe73296c@gmx.com>
From: Stirling Westrup <swestrup@gmail.com>
Date: Thu, 28 Dec 2017 22:35:47 -0500
Message-ID: <CAJt7KB_QMivwW8APX0Bxw4m+K4BRhZ0Qh1zxOxEkcpO5hF48EQ@mail.gmail.com>
Subject: Re: Hand Patching a BTRFS Superblock?
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc: Nikolay Borisov <n.borisov.lkml@gmail.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 28, 2017 at 9:08 PM, Qu Wenruo <quwenruo.btrfs@gmx.com> wrote:
>
>

>
> I strongly recommend to do a binary search for magic number "5f42 4852
> 6653 5f4d" to locate the real offset (if it's offset, not a toasted image)
>
I don't understand, how would I do a binary search for that signature?
