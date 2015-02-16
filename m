Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f46.google.com ([209.85.213.46]:65054 "EHLO
	mail-yh0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754603AbbBPB7j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 15 Feb 2015 20:59:39 -0500
Received: by mail-yh0-f46.google.com with SMTP id z6so12813283yhz.5
        for <linux-btrfs@vger.kernel.org>; Sun, 15 Feb 2015 17:59:38 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAEr6y+XdwTMvg67CJmu8LgUgxCayoHLrBYm9En0vfB=BMqL_vg@mail.gmail.com>
References: <CAEr6y+XdwTMvg67CJmu8LgUgxCayoHLrBYm9En0vfB=BMqL_vg@mail.gmail.com>
Date: Sun, 15 Feb 2015 18:59:38 -0700
Message-ID: <CAJCQCtQgrzM_FT62+=NsprL1cTq1yYQMy4us4z73WGtOd82bsg@mail.gmail.com>
Subject: Re: init-scum-tree Assertion `ret` failed
From: Chris Murphy <lists@colorremedies.com>
To: Tim DeNike <tim@denike.us>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Feb 15, 2015 at 5:06 PM, Tim DeNike <tim@denike.us> wrote:
> Long story short.. Ive been having problems with random files getting
> uncorrectable CRC errors on a 23TB filesystem.. RAID6 on an LSI card.

This is LSI hardware RAID6? Or Btrfs raid6 with an LSI HBA? If you can
still mount -o ro, what do you get for btrfs fi df <mp>

The former setup won't have copies for everything, only for inline
data if metadata profile is dup. So there's not much point to
init-csum-tree, there is corruption somewhere and reiniting the csum
tree just masks that problem (probably temporarily).

I just took a new btrfs volume created with
kernel-3.10.0-123.el7.x86_64 and btrfs-progs v3.12 from CentOS 7.
Nuked the csum tree with --repair --init-csum-tree, which actually
somehow incidentally caused damage to the extent tree. The csum tree
is empty and anything not stored inline (metadata) has csum
errors.Then I upgraded to kernel-3.19.0-1.el7.elrepo.x86_64 and
btrfs-progs-3.18.2, and did another --repair --init-csum-tree, and now
everything is fixed. No errors and no crash.



-- 
Chris Murphy
