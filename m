Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f172.google.com ([209.85.223.172]:33017 "EHLO
        mail-io0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751675AbdBINNM (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 9 Feb 2017 08:13:12 -0500
Received: by mail-io0-f172.google.com with SMTP id v96so16297463ioi.0
        for <linux-btrfs@vger.kernel.org>; Thu, 09 Feb 2017 05:13:12 -0800 (PST)
Subject: Re: csum failed, checksum error, questions
To: Ian Kelling <ian@iankelling.org>, linux-btrfs@vger.kernel.org
References: <1486604538.3944846.875079560.7B23E81D@webmail.messagingengine.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <b64f68b2-76c6-cbc5-36f2-7c3d6d044eef@gmail.com>
Date: Thu, 9 Feb 2017 08:13:06 -0500
MIME-Version: 1.0
In-Reply-To: <1486604538.3944846.875079560.7B23E81D@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2017-02-08 20:42, Ian Kelling wrote:
> I had a file read fail repeatably, in syslog, lines like this
>
> kernel: BTRFS warning (device dm-5): csum failed ino 2241616 off
> 51580928 csum 4redacted expected csum 2redacted
>
> I rmed the file.
>
> Another error more recently, 5 instances which look like this:
> kernel: BTRFS warning (device dm-5): checksum error at logical
> 16147043602432 on dev /dev/mapper/dev-name-redacted, sector 1177577896,
> root 4679, inode 2241616, offset 51597312, length 4096, links 1 (path:
> file/path/redacted)
> kernel: BTRFS error (device dm-5): bdev /dev/mapper/dev-name-redacted
> errs: wr 0, rd 0, flush 0, corrupt 5, gen 0
> kernel: BTRFS error (device dm-5): unable to fixup (regular) error at
> logical 16147043602432 on dev /dev/mapper/dev-name-redacted
>
> In this case, I think the file got rmed as well.
>
> I'm assuming this is a problem with the drive, not btrfs. Any opinions
> on how likely catastrophic failure of the drive is?
Just a few checksum errors is insufficient information to even give a 
reasonable guess.  If you can post the output of 'smartctl -x', I can 
show you what to look for there to see if the drive is likely to fail, 
but even that isn't 100% reliable.
>
> Is rming the problematic file sufficient? How about if the subvolume
> containing this bad file was previously snapshotted?
If the file hasn't changed since the snapshot, then the extent with the 
error in it is still in the snapshot.
>
> Is there anything else besides "kernel: BTRFS (error|warning)" that I
> should grep for my syslog to watch for filesystem/drive problems?
> For example, is there anything in addition to error/warning like
> "fatal" or "critical"?
There isn't anything you should be grepping for, you should be using the 
tools to check for errors.  Minimum standard monitoring that I would 
recommend is:
1. Checking SMART status for the drives on a regular basis (smartctl -H 
is usually sufficient, though you may want to monitor the in-firmware 
error logs as well, check man smartctl for more info than you'll 
probably ever need about all this).  This isn't BTRFS specific, and it's 
rather sad how few distros have this reasonably reliable and rather 
trivial to implement hardware monitoring set up by default.
2. Running scrub on the filesystem regularly.  This will validate 
checksums on all files in the FS, so you'll know much sooner if a file 
you only access infrequently.  Scrub will also automatically repair 
corrupted blocks if at all possible.
3. Monitoring the output of 'btrfs dev stats' for the filesystem.  This 
will show you the values (per-device) of the various running error 
counts BTRFS stores in the filesystem's metadata.  At least some of 
these will be non-zero on your filesystem right now, but you can reset 
them with the -z option.  If you see these start to go up consistently, 
it usually means you have some bad sectors on the disk.  If you see them 
suddenly jump to a much higher value, it's also generally a bad sign.

In addition to those, there are a few other things you can check:
1. Watch the filesystem mount options and make sure they don't change 
unexpectedly.  If the mount options change without user intervention, 
something is wrong.  The only realistic case this can happen is the 
filesystem switching from writable to read-only, but it's not outside 
the realm of possibility that a bug elsewhere could cause a different 
change.
2. Watch the kernel logs for link and storage controller errors.  While 
BTRFS has better options for monitoring it's own errors, there really is 
no better option for hardware errors involving these components.
