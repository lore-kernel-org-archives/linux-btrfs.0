Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f42.google.com ([209.85.215.42]:51789 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293AbaJOXtI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:49:08 -0400
Received: by mail-la0-f42.google.com with SMTP id gf13so2190986lab.1
        for <linux-btrfs@vger.kernel.org>; Wed, 15 Oct 2014 16:49:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAL3q7H6bm96eNWtvWdBuc4QnS+6BdkHXZrbEmfm6n5Po1KH3fw@mail.gmail.com>
References: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
	<1413407515.18175.0@mail.thefacebook.com>
	<CANg_oxx6u3Bk5XHeTYxUHa3t9gnE4J_TWnPyzFCa0aaONxR-6g@mail.gmail.com>
	<CAL3q7H6bm96eNWtvWdBuc4QnS+6BdkHXZrbEmfm6n5Po1KH3fw@mail.gmail.com>
Date: Thu, 16 Oct 2014 01:49:06 +0200
Message-ID: <CANg_oxxEUMh_V1DnpzSHCsZm_7O0OgBd2kA1ry9RTJMLLGkgXw@mail.gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: race free update of commit root for ro snapshots"
From: john terragon <jterragon@gmail.com>
To: Filipe Manana <fdmanana@gmail.com>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

-It's not a brand new fs. It has been created four or five days ago
with btrfs-progs 3.16.2 (in fact it was created because of the dead
unremovable ro snapshots in the previous fs)

-the snapshot in question has been created after applying the patch
(and it has not become corrupted so far)

-not an incremental send

-no warnings in dmesg

-btrfs check segfaults (as it did before the patch)

-there are in fact dead unremovable ro snapshots in the filesystem (it
has been used before the patch). But the filesystem seems functional
as long as the dead ro snapshots aren't touched. If one of them is
accessed with ls -l  I get the usual "parent transid verify failed on
X wanted Y found Z". But as I said no warnings of that kind (or any
kind) appear in dmesg when I do the send on the freshly created ro
snapshot.

thanks
john


On Thu, Oct 16, 2014 at 1:05 AM, Filipe David Manana <fdmanana@gmail.com> wrote:
> On Wed, Oct 15, 2014 at 11:42 PM, john terragon <jterragon@gmail.com> wrote:
>> Hi.
>>
>> I applied the patch to 3.17.1 but although I haven't seen any
>> corrupted ro snapshot yet it's still impossible to do btrfs send. As
>> soon as I start btrfs send I still get
>>
>> ERROR: send ioctl failed with -12: Cannot allocate memory
>>
>> even if I redirect btrfs send's output to a file (instead of involving
>> btrfs receive)
>>
>> Maybe this time it's actually a btrfs-progs bug?
>
> Not enough information to tell.
>
> Is it a brand new fs? If not, is it a snapshot created after applying
> the patch or before? Does a btrfsck reports any issues with the fs?
> Is it an incremental (using -p <parent_snapshot>) or a full send? Do
> you see any warning (traces, errors) in syslog (dmesg)?
>
> Either an issue in send or, if it's an fs created/used with unpatched
> 3.17.0/1, it can be a side effect of the corruption.
>
> thanks
>
>>
>> Thanks
>> John
>
>
>
> --
> Filipe David Manana,
>
> "Reasonable men adapt themselves to the world.
>  Unreasonable men adapt the world to themselves.
>  That's why all progress depends on unreasonable men."
