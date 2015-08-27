Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:35594 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbbH0EBe (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 00:01:34 -0400
Received: by lbcbn3 with SMTP id bn3so3810528lbc.2
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 21:01:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5FuCiK-2CE9=OOHkDiFKXUrCOdg7OCf_Qdh6m_j9vehQ@mail.gmail.com>
References: <CA+X5Wn5FuCiK-2CE9=OOHkDiFKXUrCOdg7OCf_Qdh6m_j9vehQ@mail.gmail.com>
Date: Thu, 27 Aug 2015 04:01:32 +0000
Message-ID: <CA+X5Wn6vvU9JrHspqD8SmW4+W7h0Se4dU2MgC2w8Xrug+LMO0g@mail.gmail.com>
Subject: Re: Modifying a file in many snapshots
From: james harvey <jamespharvey20@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

If this isn't possible, is there a way to check a given path/filename
on a btrfs filesystem, to show all the other reflinked path/filenames
to the same file?

On Thu, Aug 27, 2015 at 3:31 AM, james harvey <jamespharvey20@gmail.com> wrote:
> I'm using btrfs and snapper.  So, I have many periodic btrfs
> snapshots, which are marked read-only (can of course be changed by
> btrfs to r/w and changed back.)
>
> Let's say during my initial install I set a vimrc.  And, let's say now
> I want to change the vimrc, so that if I go back to any of the
> snapshots my vimrc is the new one.  Yeah, this totally re-writes
> history, and goes against the idea of having historical backups.  But
> let's say that I change active snapshots often for testing and don't
> want to keep having to re-change certain configuration files like
> this.  And I'm OK with blowing away my backups of the file.
>
> Right now, there should be only one copy of the vimrc file contents
> that are being used/pointed to, since it's never been modified since
> the very first snapshot.
>
> Is there a way I can modify the vimrc file, so that "all of them" are updated?
>
> Can I bypass copy on write during the edit, doing so just for the one
> file, so any system files in he background still use COW?  I see I
> can't use chattr's NOCOW because the file isn't new or empty.  Is
> there another way?
>
> Or, do I have to edit the live file, turn all the snapshots to r/w,
> perform a cp -ax --reflink=always to all the snapshot files, and turn
> all the snapshots to r/o?  There's a lot of snapshots to do this to.
> (Granted a script would make this less painful.)
