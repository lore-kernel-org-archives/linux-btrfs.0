Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f53.google.com ([74.125.82.53]:33987 "EHLO
	mail-wg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753147Ab3A1QLK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Jan 2013 11:11:10 -0500
Received: by mail-wg0-f53.google.com with SMTP id fn15so1784559wgb.8
        for <linux-btrfs@vger.kernel.org>; Mon, 28 Jan 2013 08:11:09 -0800 (PST)
MIME-Version: 1.0
Date: Mon, 28 Jan 2013 18:11:08 +0200
Message-ID: <CAOcd+r36TOugPs+5P3W6v6m5pzojGnqZ3YUNS-zzFK2pdm1A8A@mail.gmail.com>
Subject: backref for an extent not found in send_root (!backref_ctx->found_itself)
From: Alex Lyakas <alex.btrfs@zadarastorage.com>
To: Jan Schmidt <list.btrfs@jan-o-sch.net>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Cc: Arne Jansen <sensille@gmx.net>, Alexander Block <ablock84@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Jan,
I have a set of unit tests (part of the larger system) for the
send-receive functionality, with which I am able to hit this error:

Jan 28 18:01:00 687-dev kernel: [16968.451358] btrfs: ERROR did not
find backref in send_root. inode=259, offset=139264, disk_byte=4263936
found extent=4263936

As the code states, this could indicate a bug in backref walking. This
reproduces with "for-linus" branch.

Typically this happens when a snapshot is deleted, immediately a new
snap with the same name is created, and then "btrfs send" is issued
without parent (i.e., full-send) on this snap.

To debug this further, we can do one of two things:
# I can apply patches/debug prints & reproduce
# I can work to isolate the unit test into a bash script and send you
a script that reproduces

Please let me know.

Thanks,
Alex.
