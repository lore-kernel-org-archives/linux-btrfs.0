Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37818 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751440AbcAEMic (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Jan 2016 07:38:32 -0500
Received: by mail-ig0-f180.google.com with SMTP id to18so11189807igc.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Jan 2016 04:38:32 -0800 (PST)
Subject: Re: Replace a corrupted block using a known-good file from another
 filesystem ?
To: Sylvain Joyeux <sylvain.joyeux@m4x.org>, linux-btrfs@vger.kernel.org
References: <CAFENT7KXjVBa0n16=FuWhK6xvgFZ7N5GdH_dVufaZbsx9wmeNA@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <568BB911.4010803@gmail.com>
Date: Tue, 5 Jan 2016 07:37:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAFENT7KXjVBa0n16=FuWhK6xvgFZ7N5GdH_dVufaZbsx9wmeNA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-01-05 07:25, Sylvain Joyeux wrote:
> In the course of the few btrfs crashes I had on my USB backup drive
> (NOT the drive from my other bug report, which is an internal SATA
> drive) - in the last 6 months or so - I ended up having a 4 to 5 bad
> checksums reported by scrub.
>
> This drive is used to synchronize snapshots from my main machine, and
> the corrupted files are system files that are still present on the
> main machine.
>
> I could obviously reset the filesystem on the USB drive, but since the
> goal is to keep a backup history (which the main machine does not
> keep), I would rather avoid that.
>
> Would there be a way to replace the bad blocks using the good file on
> the main filesystem ? Replacing it in each snapshot separately does
> not look very appealing as the file is present on most of them.
Short of manually modifying the underlying block device directly, there 
really isn't much you can do.  However, if the file is in the same place 
in every snapshot, it should be really easy to script from the command 
line with a simple for loop.  Assuming that the file is /bin/bash, the 
following should work if run from the directory containing the snapshots 
(assuming of course that the snapshots are read-only, if not you can 
just remove both of the btrfs property set lines):

for snapshot in * ; do
     btrfs property set ${snapshot} ro false
     cp /bin/bash ${snapshot}/bin/bash
     btrfs property set ${snapshot} ro true
done

You can of course replace /bin/bash in that with any file.
