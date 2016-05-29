Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:36735 "EHLO
	mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbcE2VEH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 29 May 2016 17:04:07 -0400
Received: by mail-oi0-f46.google.com with SMTP id j1so244978360oih.3
        for <linux-btrfs@vger.kernel.org>; Sun, 29 May 2016 14:04:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
References: <1464551298-11291-1-git-send-email-anand.jain@oracle.com>
Date: Sun, 29 May 2016 15:04:00 -0600
Message-ID: <CAJCQCtS3hG8nQ39bAnKpSz-9kBhiPY6wFM2t3g5Ek-RNnx1DFA@mail.gmail.com>
Subject: Re: [regression] make sure seed is writeable sprout after device add
From: Chris Murphy <lists@colorremedies.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, May 29, 2016 at 1:48 PM, Anand Jain <anand.jain@oracle.com> wrote:
> Originally a seed FS becomes a writeable sprout FS after a
> device is added to it, however as at 4.6 I don't see this
> behavior anymore.

I think the old behavior where it's possible to use -o remount,rw is
actually confusing.

Strictly speaking what is mounted is the seed volume with that
particular volume UUID. Doing a remount to effectively cause a behind
the scene umount then a mount of a different volume and volume UUID is
not obvious. What if there's more than one sprout? It seems really
ambiguous what the user wants with an -o remount so I'm wondering if
this operation should fail instead?

>From mount man page:

       remount
              Attempt to remount an already-mounted filesystem.  This
is commonly used to change the mount flags for a filesystem,
especially to make a readonly filesystem writable.  It does not change
device or mount point.

Two problems: 1. the seed and sprout are two filesystems, and one of
them is not already mounted. So remount should not mean switch from a
mounted filesystem to an unmounted one. 2. The former remount behavior
did change device, from that of the seed to that of the sprout.

So both of those seem to depart from the remount definition rather
significantly.


-- 
Chris Murphy
