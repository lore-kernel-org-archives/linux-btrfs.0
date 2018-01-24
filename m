Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ot0-f178.google.com ([74.125.82.178]:38373 "EHLO
        mail-ot0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932170AbeAXAoZ (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 23 Jan 2018 19:44:25 -0500
Received: by mail-ot0-f178.google.com with SMTP id v5so2161417oth.5
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jan 2018 16:44:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com>
References: <CAEY8F1qw-6Xa+ESJH0X3zhJcQ1UaoJO4wkPjdDt63JEYHBuAoQ@mail.gmail.com>
 <CAJCQCtQAn0LTs0S9=NX5YZ1ORQwqrVxMH6HEpbQ=euC3EYhh8Q@mail.gmail.com> <8f74430a-0f72-cd26-ee50-f9b4239b5558@gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Tue, 23 Jan 2018 17:44:24 -0700
Message-ID: <CAJCQCtSTeNmL=uk_j6Wt1CXC9HOdRDCKGiO+U-9ovt0CHNijFg@mail.gmail.com>
Subject: Re: bad key ordering - repairable?
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>,
        Claes Fransson <claes.v.fransson@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jan 23, 2018 at 5:51 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

> This is extremely important to understand.  BTRFS and ZFS are essentially
> the only filesystems available on Linux that actually validate things enough
> to notice this reliably (ReFS on Windows probably does, and I think whatever
> Apple is calling their new FS does too).

ReFS always checksums metadata, optionally can checksum data.

APFS is really vague on this front, it may be checksumming metadata,
it's not checksumming data and with no option to. Apple proposes their
branded storage devices do not return bogus data. OK so then why
checksum the metadata?

>Even if ext4 did notice it, it
> would just mark the filesystem for a check and then keep going without doing
> anything else about it (seriously, the default behavior for internal errors
> on ext4 is to just continue like nothing happened and mark the FS for fsck).

I haven't used ext4 with metadata checksumming enabled, and have no
idea how it behaves when it starts encountering checksum errors during
normal use. For sure XFS will complain a lot and will go read only
when it gets confused. I'd expect any file system going to the trouble
of checksumming would have to have some means of bailing out, rather
than just continuing on.

Btrfs (and maybe ZFS) COW everything except supers. So ostensibly a
future feature might let them continue on with a kind of
integrated/single volume variation on seed/sprout device. I'd like to
see something like this just for undoable and testable offline
repairs, rather than offline repair only being predicated on
overwritting metadata.

-- 
Chris Murphy
