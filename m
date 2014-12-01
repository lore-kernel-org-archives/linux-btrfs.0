Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f45.google.com ([209.85.213.45]:58730 "EHLO
	mail-yh0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751505AbaLAAyo (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Nov 2014 19:54:44 -0500
Received: by mail-yh0-f45.google.com with SMTP id f10so4390939yha.32
        for <linux-btrfs@vger.kernel.org>; Sun, 30 Nov 2014 16:54:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
Date: Sun, 30 Nov 2014 17:54:44 -0700
Message-ID: <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
Subject: Re: Moving an entire subvol?
From: Chris Murphy <lists@colorremedies.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Nov 29, 2014 at 8:31 PM, Shriramana Sharma <samjnaa@gmail.com> wrote:
> So the Ubuntu Wiki BtrFS entry advises against using subvol
> set-default because it boots its kernel using root=subvol=@ and home
> as subvol=@home, and these two subvols are only present under the
> subvol with ID 5.

The advice may have had to do with GRUB behavior prior to 2.02.
Previously GRUB attempted to honor the btrfs default subvolume, and
therefore treated any path in grub.cfg relative to the default
subvolume. Now, GRUB behaves the same as the subvol= mount option, it
is always treated as an absolute path from subvol id 5, hence the
default subvolume is ignored.

Since the default subvolume is set by a user space program I think
it's a domain violation for anything to subvert this; it really should
remain a shortcut for the user's benefit only, so they can use mount
without -o subvol=. Everything else should explicitly pass subvol=



> But isn't it just possible to move i.e. reparent a
> subvol so I can move these two under another subvol and have that as
> default?

You can move subvolumes. My suggestion is subvolumes containing
binaries shouldn't be located within another subvolume that ends up
being mounted, that way old binaries with possible vulnerabilities
aren't exposed in the normal search path.

>
> Possibly this is a hypothetical question as I'm not sure whether it
> would be actually practically required but looking at the specific
> Ubuntu advice on this I thought I should ask.
>
> I'm also not sure what openSUSE (or other distros) do about this... Do
> they mount root using subvolid, or subvol name or such?

openSUSE uses subvol id 5 for installing the OS to, and some
directories are made subvolumes such as home var and maybe usr.
Therefore when subvolid 5 is snapshot, those are exempt, and have to
be individually snapshot. The snapshots are found in the same root
directory everything else is, in a . directory (I think .snapshots ?)

Fedora uses subvolumes root and home by default, and fstab uses
subvol=root and subvol=home to mount them at / and /home respectively.

I don't know any distro using subvolid right now but that might be
prudent as it's far less user domain than subvolume names.


-- 
Chris Murphy
