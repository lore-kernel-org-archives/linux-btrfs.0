Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vk0-f52.google.com ([209.85.213.52]:35991 "EHLO
	mail-vk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783AbbH0EcU (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 27 Aug 2015 00:32:20 -0400
Received: by vkif69 with SMTP id f69so3693496vki.3
        for <linux-btrfs@vger.kernel.org>; Wed, 26 Aug 2015 21:32:19 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CA+X5Wn5FuCiK-2CE9=OOHkDiFKXUrCOdg7OCf_Qdh6m_j9vehQ@mail.gmail.com>
References: <CA+X5Wn5FuCiK-2CE9=OOHkDiFKXUrCOdg7OCf_Qdh6m_j9vehQ@mail.gmail.com>
Date: Wed, 26 Aug 2015 22:32:19 -0600
Message-ID: <CAJCQCtTTXzv85kWnMCgy4BzFr5q8kysQWsnntu-d5mBKWSUmtw@mail.gmail.com>
Subject: Re: Modifying a file in many snapshots
From: Chris Murphy <lists@colorremedies.com>
To: james harvey <jamespharvey20@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Aug 26, 2015 at 9:31 PM, james harvey <jamespharvey20@gmail.com> wrote:
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

a. Find the shared extents with btrfs-debug-tree or filefrag and
modify the bytes outside the filesystem (unmounted). Of course the
csum will be wrong so you'll need to use btrfs check --init-csum-tree
on the entire filesystem.

b. Next time use a symlink to a location that's always mounted where
the real file is kept; so the snapshots have the symlink not the real
file.


-- 
Chris Murphy
