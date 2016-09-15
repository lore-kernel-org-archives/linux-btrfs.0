Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:32873 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755261AbcIOFiG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 15 Sep 2016 01:38:06 -0400
Received: by mail-oi0-f68.google.com with SMTP id w11so3255210oia.0
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Sep 2016 22:38:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
References: <1473773990-3071-1-git-send-email-anand.jain@oracle.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Wed, 14 Sep 2016 23:38:05 -0600
Message-ID: <CAJCQCtT_MDDmy4OGT7SY=TfOhvgSVT1TMVmCKwL8dHcasLnDHw@mail.gmail.com>
Subject: Re: [RFC] Preliminary BTRFS Encryption
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 13, 2016 at 7:39 AM, Anand Jain <anand.jain@oracle.com> wrote:
>
> This patchset adds btrfs encryption support.
>
> The main objective of this series is to have bugs fixed and stability.
> I have verified with fstests to confirm that there is no regression.
>
> A design write-up is coming next, however here below is the quick example
> on the cli usage. Please try out, let me know if I have missed something.

What's the behavior with nested subvolumes having different keys?

subvolume A (encrypted with key A)
    |
    - subvolume B (encrypted with key B)

Without encryption I can discover either A or B whether top-level, A,
or B are mounted.

With encryption, must A be opened [1] for B to be discovered? Must A
be opened before B can be opened? Or is the subvolume metadata always
non-encrypted, and it's just file extents that are encrypted? Are
filenames in those subvolumes discoverable (e.g. btrfs-debug-tree,
btrfs-image) if the subvolume is not opened? And reflink handling
between subvolumes behaves how?


[1] open in the cryptsetup open/luksOpen sense


-- 
Chris Murphy
