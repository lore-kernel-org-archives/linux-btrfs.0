Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:35751 "EHLO
	mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041AbcCVUmJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 22 Mar 2016 16:42:09 -0400
Received: by mail-lf0-f45.google.com with SMTP id d192so5307892lfg.2
        for <linux-btrfs@vger.kernel.org>; Tue, 22 Mar 2016 13:42:08 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
References: <CAJCQCtRbOa14an+UooFJYBK5JNQppYfXKHqpOfKVXHBYPAQ_Kg@mail.gmail.com>
Date: Tue, 22 Mar 2016 21:42:07 +0100
Message-ID: <CAPmG0jY16du77GzzMScdMMB6dNQeMvOOqBqsYQLMn0CsE5HgmQ@mail.gmail.com>
Subject: Re: overlay file to test btrfs repairs
From: Henk Slager <eye1tm@gmail.com>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 21, 2016 at 4:43 AM, Chris Murphy <lists@colorremedies.com> wrote:
> Hi folks,
>
> So I just ran into this:
> https://raid.wiki.kernel.org/index.php/Recovering_a_failed_software_RAID#Making_the_harddisks_read-only_using_an_overlay_file
>
> This is a device mapper overlay file - not overlayfs.
>
> For the repairs that are sometimes uncertain what's next, maybe this
> is a viable option to avoid changing the file system? I'm thinking
> chunk-recover might take up too much space, I'm not sure how that one
> works, if chunks are just being read or if they have to be rewritten
> or if it's just the chunk tree? But for 'btrfs check' and 'btrfs
> rescue super-recover/zero-log' there should be very little being
> written so the overlay idea might be a good step?

I used the info via this message:
http://permalink.gmane.org/gmane.comp.file-systems.btrfs/54178

to try to fix a 4x4TB disks RAID10 (some bad metadata, some nbytes 400 errors).
I used AoE (instead of NBD) to avoid that btrfs+kernel might get
confused by double UUID's.

I created 4x 10G sparse files for each bcached HDD. After the --repair
action had ended (apparently successful), du reported only 50M size on
disk for each of the sparse files. The fix operation lasted about 1.5
hours. After a mount and umount again of the 'just repaired fs', a
subsequent btrfs check still reported the same errors, although
reported in another sequence.
So the nbytes 400 errors actually did not get fixed ( while there were
also other errors; This in accordance to what Qu once noted, but at
that time older tools/kernel).
