Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:33182 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753889AbaLBDWC (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 22:22:02 -0500
Received: by mail-qg0-f50.google.com with SMTP id i50so8524661qgf.23
        for <linux-btrfs@vger.kernel.org>; Mon, 01 Dec 2014 19:22:01 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
References: <CAH-HCWVcu9FW0c3zwEg_KR_yaPGRQ58yHbXsUx1JCKRu4s7NXQ@mail.gmail.com>
 <CAJCQCtT3EeGUOpZ9q78BcWv_Cc_5UGY=uPVJX+bqex9Zo_bWYg@mail.gmail.com>
From: Shriramana Sharma <samjnaa@gmail.com>
Date: Tue, 2 Dec 2014 08:51:40 +0530
Message-ID: <CAH-HCWUSX+N2Byo4vpCxac89TSX2YGoP39VgFsq6952k9V9cmQ@mail.gmail.com>
Subject: Re: Moving an entire subvol?
To: Chris Murphy <lists@colorremedies.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Dec 1, 2014 at 6:24 AM, Chris Murphy <lists@colorremedies.com> wrote:
>> But isn't it just possible to move i.e. reparent a
>> subvol so I can move these two under another subvol and have that as
>> default?
>
> You can move subvolumes.

OK so I just found out that just mv test1/foo test2/ where test1,
test2 and foo are all subvolumes is sufficient to reparent foo to
test2, if what btr sub list shows as "top level" is indeed the parent
subvolume.

Is that correct: what btr sub list shows as "top level" is indeed the
parent subvolume?

> My suggestion is subvolumes containing
> binaries shouldn't be located within another subvolume that ends up
> being mounted, that way old binaries with possible vulnerabilities
> aren't exposed in the normal search path.

I'm not sure what you mean. Are you saying that for example /usr/bin should be:

1) a separate subvolume than / or /usr,
2) not a child subvolume of / or /usr?

> openSUSE uses subvol id 5 for installing the OS to, and some
> directories are made subvolumes such as home var and maybe usr.
> Therefore when subvolid 5 is snapshot, those are exempt, and have to
> be individually snapshot.

Yes I also noticed that openSUSE creates such separate subvols, but is
there any particular benefit to making it so?

> Fedora uses subvolumes root and home by default, and fstab uses
> subvol=root and subvol=home to mount them at / and /home respectively.

This seems similar to Ubuntu's @ and @home setup.

Is there any advantage to either? That is, one model installs root to
the topmost subvol and makes usr, home etc nested subvols, whereas
another makes root a nested subvol under the topmost just like usr
home etc, and then mounts it to /...

In general it seems people (or at least distros) prefer avoiding
nesting subvolumes. Is there any particular reason for this? Esp in
regard to /usr etc it would seem that if they are nested within the
subvol for /, then just mounting that subvol would automatically mount
all nested subvolumes, right? So the extra effort needed to mount the
nested subvols would not be necessary, no?

Shriramana.
