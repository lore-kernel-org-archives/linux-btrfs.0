Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from datenkhaos.de ([81.89.99.198]:46330 "EHLO mail.datenkhaos.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752643Ab3I0PQs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Sep 2013 11:16:48 -0400
Date: Fri, 27 Sep 2013 17:07:37 +0200
From: Johannes Hirte <johannes.hirte@datenkhaos.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>
Subject: Re: balance induced csum errors, systemd-journal
Message-ID: <20130927170737.5786c948@datenkhaos.de>
In-Reply-To: <795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
References: <4CA64610-C709-4805-A9DC-AA8EB0720BBF@colorremedies.com>
	<1810D553-8DB4-4FAA-A305-CF3BE9A85B6F@colorremedies.com>
	<F715552F-A1A0-49BE-B714-C5DF6B7D8AB6@colorremedies.com>
	<795CFB34-4216-4ACA-A56D-5F673B2FD45E@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 24 Sep 2013 22:34:20 -0600
Chris Murphy <lists@colorremedies.com> wrote:

> OK so I think I'm narrowing this down to just the systemd journal,
> and it's not checksums that are corrupted, it's the journal itself.

I doubt it's systemd-dependent, cause I've seen similar behaviour on a
Gentoo system without systemd. Before balance the filesystem was ok,
after I get

root 257 inode 2875 errors 1800
root 257 inode 2881 errors 1800
root 257 inode 2969 errors 1800
root 257 inode 3063 errors 1800
root 257 inode 3120 errors 1800
root 257 inode 12407 errors 1800
root 257 inode 19496 errors 1800
root 257 inode 19500 errors 1800
root 257 inode 19564 errors 1800
root 257 inode 19643 errors 1800
root 257 inode 19693 errors 1800
root 257 inode 19949 errors 1800
root 257 inode 20178 errors 1800
root 257 inode 20320 errors 1800
root 257 inode 20406 errors 1800
root 257 inode 20512 errors 1800
root 257 inode 20586 errors 1800
root 257 inode 20654 errors 1800
root 257 inode 20727 errors 1800
root 257 inode 20728 errors 1800
root 257 inode 20821 errors 1800
root 257 inode 20843 errors 1800
root 257 inode 21062 errors 1800
root 257 inode 21078 errors 1800
root 257 inode 21222 errors 1800
root 257 inode 21356 errors 1800
root 257 inode 21437 errors 1800
root 257 inode 55082 errors 1800
root 257 inode 65343 errors 1800
root 257 inode 72413 errors 1800

on a fsck and scrub tells me that there are unfixable csum errors.
Kernel is 3.12.0-rc2-00083-g4b97280.

I've observed this two times, and every time only the first
subvolume (root 257) was affected.

regards,
  Johannes
