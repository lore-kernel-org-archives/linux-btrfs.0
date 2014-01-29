Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f180.google.com ([209.85.223.180]:45934 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751149AbaA2PNo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 29 Jan 2014 10:13:44 -0500
Received: by mail-ie0-f180.google.com with SMTP id at1so2157359iec.39
        for <linux-btrfs@vger.kernel.org>; Wed, 29 Jan 2014 07:13:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52E91535.8090306@statystyka.net>
References: <52E91535.8090306@statystyka.net>
Date: Wed, 29 Jan 2014 09:13:44 -0600
Message-ID: <CAE5mzvhEMKBkJCzeB-NAAgdGjzidh9adkxF-ytW5K_vNZcxJOA@mail.gmail.com>
Subject: Re: BTRFS corrupted by combination of mistreatment of hiberantion and
 accidental power loss.
From: cwillu <cwillu@cwillu.com>
To: Adam Ryczkowski <adam.ryczkowski@statystyka.net>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

You'd have been better off to just throw away the hiberated image:
mounting the filesystem would look like any other recovery from a
crash, and would have replayed the log and committed a new
transaction, in addition to whatever other disk writes happened due to
boot logs and so forth.

In this case, I suspect you'd have been perfectly fine.

When resuming the hibernated image at that point however, the kernel
will have its own ideas about the state on disk (i.e., whatever state
it had in memory), partially undoing a subset of the changes from the
previous boot and generally making a mess of things.

That said, have you tried mounting with -o recovery yet?  I wouldn't
be surprised if btrfs-restore was also able to retrieve most of
everything.  Either way, I'd be suspicious of the filesystem, and
would look to restore from backup to a fresh fs.



On Wed, Jan 29, 2014 at 8:50 AM, Adam Ryczkowski
<adam.ryczkowski@statystyka.net> wrote:
> I have two independent Linux installations my notebook, both sharing the
> same btrfs partition as root file system, but installed on different
> subvolumes.
>
> I hibernated one Linux (Mint 15 64 bit). Hibernation data is stored on the
> swap file, which is used exclusively by this system.
>
> Then 2 events happened.
>
> 1) I accidentally ran the other system, which wasn't hibernated - Ubuntu
> 12.10. Realizing the problem, I waited until the system booted up, and then
> shutdowned it.
>
> Then I opened the hibernated Mint 15. Restoration went successful, and I
> never thought I am in trouble.
>
> 2) Immediately after that, by coincidence, the battery fell down, brutally
> powering down the computer.
>
> After that, I am unable to repair/mount the root btrfs partition, however I
> try (I built the current btrfs-tools from git). Dmesg displays only one
> error entry: btrfs: open_ctree failed.
>
> I know, that if one those two events happened separately, there would be no
> problem. The problem arose only when those two events happened
> simultaneously.
>
> So I guess I am experiencing one of the corner cases.
>
> What are my prospects to restoring my data? I have several subvolumes on the
> hard drive, some of them were not touched by the accident at all.
>
> Adam Ryczkowski
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
