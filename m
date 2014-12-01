Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yk0-f174.google.com ([209.85.160.174]:57337 "EHLO
	mail-yk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126AbaLABAh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 20:00:37 -0500
Received: by mail-yk0-f174.google.com with SMTP id 10so4275212ykt.5
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 17:00:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au>
References: <20141130121147.45884217@atmarama>
	<E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au>
Date: Sun, 30 Nov 2014 18:00:37 -0700
Message-ID: <CAJCQCtTM8JpH_-E6dsbV53aCx7V9ptH94peST63KJ6AR=OCDqQ@mail.gmail.com>
Subject: Re: pro/cons of raid1 with mdadm/lvm2
From: Chris Murphy <lists@colorremedies.com>
To: Russell Coker <russell@coker.com.au>
Cc: Gour <gour@atmarama.net>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 30, 2014 at 3:06 PM, Russell Coker <russell@coker.com.au> wrote:
> When the 2 disks have different data mdadm has no way of knowing which one is correct and has a 50% chance of overwriting good data. But BTRFS does checksums on all reads and solves the problem of corrupt data - as long as you don't have 2 corrupt sectors in matching blocks.

Yeah. I'm not sure though if openSUSE 13.2 prevents users from
creating btrfs raid1 volumes entirely, or if it's just an install time
limitation.

I know that Fedora's installer won't allow the user to create Btrfs on
LVM, and it probably doesn't allow it on md raid either.

-- 
Chris Murphy
