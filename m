Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f49.google.com ([209.85.215.49]:49981 "EHLO
	mail-la0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbaJOXFN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Oct 2014 19:05:13 -0400
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <CANg_oxx6u3Bk5XHeTYxUHa3t9gnE4J_TWnPyzFCa0aaONxR-6g@mail.gmail.com>
References: <1413398246-17324-1-git-send-email-fdmanana@suse.com>
	<1413407515.18175.0@mail.thefacebook.com>
	<CANg_oxx6u3Bk5XHeTYxUHa3t9gnE4J_TWnPyzFCa0aaONxR-6g@mail.gmail.com>
Date: Thu, 16 Oct 2014 00:05:11 +0100
Message-ID: <CAL3q7H6bm96eNWtvWdBuc4QnS+6BdkHXZrbEmfm6n5Po1KH3fw@mail.gmail.com>
Subject: Re: [PATCH] Revert "Btrfs: race free update of commit root for ro snapshots"
From: Filipe David Manana <fdmanana@gmail.com>
To: john terragon <jterragon@gmail.com>
Cc: Chris Mason <clm@fb.com>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        stable@vger.kernel.org, Filipe Manana <fdmanana@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 15, 2014 at 11:42 PM, john terragon <jterragon@gmail.com> wrote:
> Hi.
>
> I applied the patch to 3.17.1 but although I haven't seen any
> corrupted ro snapshot yet it's still impossible to do btrfs send. As
> soon as I start btrfs send I still get
>
> ERROR: send ioctl failed with -12: Cannot allocate memory
>
> even if I redirect btrfs send's output to a file (instead of involving
> btrfs receive)
>
> Maybe this time it's actually a btrfs-progs bug?

Not enough information to tell.

Is it a brand new fs? If not, is it a snapshot created after applying
the patch or before? Does a btrfsck reports any issues with the fs?
Is it an incremental (using -p <parent_snapshot>) or a full send? Do
you see any warning (traces, errors) in syslog (dmesg)?

Either an issue in send or, if it's an fs created/used with unpatched
3.17.0/1, it can be a side effect of the corruption.

thanks

>
> Thanks
> John



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
