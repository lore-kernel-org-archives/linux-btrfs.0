Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f181.google.com ([209.85.223.181]:35907 "EHLO
	mail-io0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcAWXnr (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 23 Jan 2016 18:43:47 -0500
Received: by mail-io0-f181.google.com with SMTP id g73so123758329ioe.3
        for <linux-btrfs@vger.kernel.org>; Sat, 23 Jan 2016 15:43:47 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <6319302C-E745-4274-86BA-10FE457A511C@asselman.com>
References: <6319302C-E745-4274-86BA-10FE457A511C@asselman.com>
Date: Sat, 23 Jan 2016 16:43:47 -0700
Message-ID: <CAJCQCtRCrjr4CXgREJrt=EaEm3hCi5324_NxebRUPMKOUHKUxQ@mail.gmail.com>
Subject: Re: Bad metadata / Incorrect global backref count
From: Chris Murphy <lists@colorremedies.com>
To: Jeroen Asselman <jeroen@asselman.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jan 22, 2016 at 3:50 AM, Jeroen Asselman <jeroen@asselman.com> wrote:

> Jan 20 22:00:14 streamlet kernel: WARNING: CPU: 1 PID: 4964 at /usr/src/linux-4.1.12-gentoo/fs/btrfs/extent-tree.c:6226
> Jan 20 22:00:14 streamlet kernel: BTRFS info (device bcache1): leaf 2857340420096 total ptrs 271 free space 7297

This is kernel 4.1.12, and Btrfs on bcache device?

My suggestion, short of other more knowledgeable suggestions, is to
make as few changes as possible. If you can mount it read-only OK,
take advantage of this by making a current backup, at least of the
most recent data you have on the volume.

That you have 16000+ snapshots is a challenge to preserve all of it.
The send -e flag should help with this, but in my tests today it seems
to be broken. https://bugzilla.kernel.org/show_bug.cgi?id=111221


-- 
Chris Murphy
