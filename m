Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:38772 "EHLO
	mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751154AbcGGO1N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Jul 2016 10:27:13 -0400
Received: by mail-it0-f48.google.com with SMTP id h190so21684116ith.1
        for <linux-btrfs@vger.kernel.org>; Thu, 07 Jul 2016 07:27:13 -0700 (PDT)
Subject: Re: Frequent btrfs corruption on a USB flash drive
To: Francesco Turco <fturco@fastmail.fm>, linux-btrfs@vger.kernel.org
References: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <87efcca5-6871-2dde-e2df-40602f1a24c2@gmail.com>
Date: Thu, 7 Jul 2016 10:27:05 -0400
MIME-Version: 1.0
In-Reply-To: <0120508a-b9e7-b9e7-4f27-79f982ee07fe@fastmail.fm>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-07-07 09:49, Francesco Turco wrote:
> I have a USB flash drive with an encrypted Btrfs filesystem where I
> store daily backups. My problem is that this btrfs filesystem gets
> corrupted very often, after a few days of usage. Usually I just reformat
> it and move along, but this time I'd like to understand the root cause
> of the problem and fix it.
>
> I can mount the partition without problems, but then when using commands
> such as rsync or even humble ls I get the following error message:
>
> $ rsync /home/fturco/Buffer/E-book/
> /run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Buffer/E-book/
> --recursive
> rsync:
> readlink_stat("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Riviste")
> failed: Stale file handle (116)
> rsync:
> readlink_stat("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Backup")
> failed: Stale file handle (116)
> rsync:
> readdir("/run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3/Calibre
> (TMSU)"): Input/output error (5)
This seems odd, are you trying to access anything over NFS or some other 
network filesystem protocol here?  If not, then I believe you've found a 
bug, because I'm pretty certain we shouldn't be returning -ESTALE for 
anything.
>
> The previous command gets stuck and I had to manually stop it.
>
> The following command doesn't return any output, but its exit code is 1
> (failure):
>
> $ btrfs filesystem show
> /run/media/fturco/5283147c-b7b4-448f-97b0-b235344a56a3
> $
Something is definitely wrong here.  Unless Parabola has seriously 
modified btrfs-progs, this should be spitting out info about the devices 
and filesystem usage.  This may be a result of the errors seen by check, 
but I doubt that
>
> Btrfs-check reports many errors. I attached the output to this e-mail
> message.
Looking at this, I see a couple of things I know it should fix correctly 
(the 'errors 2001' stuff is fixable, and I'm pretty certain that the 
'errors 200' thing is too, and I think it will fix the bytenr mismatch 
stuff mostly safely), but there's enough I'm not sure about that I can't 
in good conscience recommend that you run check with --repair, as it may 
make things worse.  Hopefully someone who actually understands what the 
other things actually mean can provide more help on that.
>
> Output from dmesg:
>
> $ dmesg | tail
> [18756.159963] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904
> [18756.160828] BTRFS error (device dm-4): bad tree block start
> 8533404122473270145 35323904
> [18756.161821] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904
> [18756.163047] BTRFS error (device dm-4): bad tree block start
> 8533404122473270145 35323904
> [18756.163921] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904
> [18756.164806] BTRFS error (device dm-4): bad tree block start
> 8533404122473270145 35323904
> [18756.165673] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904
> [18756.166548] BTRFS error (device dm-4): bad tree block start
> 8533404122473270145 35323904
> [18757.950603] BTRFS error (device dm-4): bad tree block start
> 6592115285688248773 35323904
> [18757.951492] BTRFS error (device dm-4): bad tree block start
> 8533404122473270145 35323904
>
> I checked this USB flash drive with badblocks in non-destructive
> read-write mode. No errors.
>
> If I format this partition as Ext4 instead of Btrfs I can use it without
> problems, but my goal is to use Btrfs on all devices.
The question here is: Do you get any data corruption when using ext4? 
Quite often when there's a hardware issue, you won't see _any_ 
indication of it other than corrupted files when using something like 
ext4 or XFS, but it will show up almost immediately with BTRFS because 
we validate checksums on almost everything.  There have been at least a 
couple of times I've found disk issues while converting from ext4 to 
BTRFS that I didn't know existed before, and then going back was able to 
reliable reproduce using other tools.

Also, FWIW, badblocks is not necessarily a reliable test method for 
flash drives, they often handle serialized reads like badblocks does 
very well even when failing.

Just to clarify, you're using BTRFS on top of disk encryption (LUKS? Or 
is it just raw encryption, or even something completely different?), on 
a USB flash drive (not a USB to SATA adapter with an SSD or HDD in it), 
correct?
>
> My GNU/Linux distribution is Parabola GNU/Linux-libre.
> Kernel version is: 4.6.3.
> Btrfs-progs version is: 4.6
>
> Please tell me if you need other details. Thanks.
>

