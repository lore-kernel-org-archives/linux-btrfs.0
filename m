Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f53.google.com ([209.85.213.53]:33351 "EHLO
	mail-yh0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbbCTAQQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Mar 2015 20:16:16 -0400
Received: by yhpt93 with SMTP id t93so32857076yhp.0
        for <linux-btrfs@vger.kernel.org>; Thu, 19 Mar 2015 17:16:15 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <550B5C63.6010401@comcast.net>
References: <550B5C63.6010401@comcast.net>
Date: Thu, 19 Mar 2015 18:16:15 -0600
Message-ID: <CAJCQCtRj6MWc=YzvEepjiZTQYrN7CKbO0EivotZNjS218Gz56Q@mail.gmail.com>
Subject: Re: nube trying to backup my systems
From: Chris Murphy <lists@colorremedies.com>
To: don fisher <hdf3@comcast.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 19, 2015 at 5:31 PM, don fisher <hdf3@comcast.net> wrote:

> I was happy until I tried to perform an ls on /usr11/tmp and found that it
> contained the root file system, all the /usr11 files present. My plan had
> been to rsync these two systems, from / to /usr11. If I umount /usr1/tmp
> subvolume and ls on /usr1/tmp, I obtain the expected results. Why when I
> mount the subvolume do I see all of the root files? I have attached my fstab
> for reference. I hope this is an easy one.

I'm fairly certain that subvol mount option doesn't accept UUID, it
only accepts a path. This is consistent with the man 8 mount page
description for Btrfs subvol anyway. If you want to use subvolume ID,
use subvolid=

# btrfs sub list /
ID 257 gen 1703 top level 5 path root
ID 258 gen 1662 top level 5 path home
ID 259 gen 1681 top level 5 path boot
ID 262 gen 1629 top level 257 path var/lib/machines

To mount machines, either
subvol=root/var/lib/machines
OR
subvolid=262

Why root/var/lib/machines? Because var/lib/machines is created inside
subvol 257, a.k.a. root, therefore the path relative to the top level
5 subvolume is root/var/lib/machines. It might be easier to figure
this out for a while to use -a switch.

# btrfs sub list -a /mnt/btraid0/
ID 257 gen 1705 top level 5 path <FS_TREE>/root
ID 258 gen 1662 top level 5 path <FS_TREE>/home
ID 259 gen 1681 top level 5 path <FS_TREE>/boot
ID 262 gen 1705 top level 257 path root/var/lib/machines



-- 
Chris Murphy
