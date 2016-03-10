Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:33859 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752630AbcCJTfc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 10 Mar 2016 14:35:32 -0500
Received: by mail-ig0-f170.google.com with SMTP id av4so1097001igc.1
        for <linux-btrfs@vger.kernel.org>; Thu, 10 Mar 2016 11:35:32 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <56E1A901.6050207@gmail.com>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
	<20160308195857.GB26981@localhost.localdomain>
	<CAJCQCtSp5B=nnpCs3zaCsMK+8qLNLzYQAqka5P1X+a+R4RzGOQ@mail.gmail.com>
	<56E013E8.9080401@gmail.com>
	<pan$389e0$596a4ce9$6594c4ff$3be23a55@cox.net>
	<56E1A901.6050207@gmail.com>
Date: Thu, 10 Mar 2016 12:35:31 -0700
Message-ID: <CAJCQCtQVUiVhjop5oE9G_XzReXw=GFtQDgHtjn2=X_qwwsPt8A@mail.gmail.com>
Subject: Re: btrfs and containers
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 10, 2016 at 10:04 AM, Austin S. Hemmelgarn
<ahferroin7@gmail.com> wrote:

>
> The part that makes this tricky is that the list ioctl can be considered a
> potential information leak (as evidenced by the issue that started this
> thread), so IMHO what really needs to happen is for the mount option to be
> 'user_subvolume_ops', and control all three operations (or better yet, do
> something with ACL's in the btrfs xattr namespace to control it on a
> per-subvolume basis).

This may also interact with the selinux + Btrfs + Docker issue. The
problem is the desire to use -o context to mount a subvolume with a
specific context for use with a specific container. But right now the
kernel won't allow different contexts for a given fs superblock. The
work around until recently is disabling Docker selinux support. The
recent work around in Docker 1.10 is it snapshots the docker image, an
uses chcon -R to to relabel it. It's actually pretty fast, but still
suboptimal. Being able to bind mount a subvolume with -o context is
faster than relabeling, with many containers it's a lot of relabeling
without it.

It's a tricky problem. If you're the owner of a filesystem tree, but
something definitely not owned at all by you is buried in that tree
somewhere, to do a subvolume delete don't you have to now traverse the
entire thing to find out? Or does the owning user have sufficient
implied permission by owning the subvolume, that no matter what's in
it, is simply gone unless it's another subvolume?




-- 
Chris Murphy
