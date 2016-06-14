Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36169 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856AbcFNJmT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Jun 2016 05:42:19 -0400
Received: by mail-wm0-f48.google.com with SMTP id n184so113146644wmn.1
        for <linux-btrfs@vger.kernel.org>; Tue, 14 Jun 2016 02:42:18 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC-H7HkWiTD5HYXoTuqW4rEhYSXr9xnp1xk6aZ51F_yhQ--CYw@mail.gmail.com>
References: <CAC-H7HkWiTD5HYXoTuqW4rEhYSXr9xnp1xk6aZ51F_yhQ--CYw@mail.gmail.com>
From: Benedikt Morbach <benedikt.morbach@googlemail.com>
Date: Tue, 14 Jun 2016 11:41:58 +0200
Message-ID: <CAC-H7H=Wc4-=FMiiQYOyRtn332WRpYd3JhKeObsUNxcKqYP9oQ@mail.gmail.com>
Subject: Re: [BUG] receive not seeing file that exists
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Cc: Josef Bacik <jbacik@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi all,

On Thu, Jun 2, 2016 at 9:26 AM, Benedikt Morbach
<benedikt.morbach@googlemail.com> wrote:
> I've encountered a bug in btrfs-receive. When receiving a certain
> incremental send, it will error with:
>
>     ERROR: cannot open
> backup/detritus/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal:
> No such file or directory
>
> even though that path exists and the parent subvolume is identical on
> both ends (I checked manually).
>
> I've noticed this happen before on the same directory (and google
> confirms it has also happened to others) and /var/log/journal/ and its
> children are the only directories with 'chattr +C' on this system, so
> it might be related to that?
>
> This was reported on IRC a week or so ago and Josef requested a tree
> --inode of the file/the dirs leading to it and the incremental send,
> so here you go:
>
>
> send side:
>     /mnt
>         [    256]  btrfs_pool_ssd
>
>     /mnt/btrfs_pool_ssd
>         [    256]  backup
>
>     /mnt/btrfs_pool_ssd/backup
>         [    256]  root
>
>     /mnt/btrfs_pool_ssd/backup/root
>         [    256]  root.20160524T1800
>         [    256]  root.20160524T1900
>
>     /mnt/btrfs_pool_ssd/backup/root/root.20160524T1800
>         [    268]  var
>
>     /mnt/btrfs_pool_ssd/backup/root/root.20160524T1800/var
>         [   9035]  log
>
>     /mnt/btrfs_pool_ssd/backup/root/root.20160524T1800/var/log
>         [35122105]  journal
>
>     /mnt/btrfs_pool_ssd/backup/root/root.20160524T1800/var/log/journal
>         [35122136]  9cbb44cf160f4c1089f77e32ed376a0b
>
>     /mnt/btrfs_pool_ssd/backup/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b
>         [53198460]  user-1000.journal
>
>
> receive side:
>     /backup
>         [    256]  detritus
>
>     /backup/detritus
>         [    256]  root
>
>     /backup/detritus/root
>         [    256]  root.20160524T1800
>
>     /backup/detritus/root/root.20160524T1800
>         [    267]  var
>
>     /backup/detritus/root/root.20160524T1800/var
>         [    856]  log
>
>     /backup/detritus/root/root.20160524T1800/var/log
>         [ 316157]  journal
>
>     /backup/detritus/root/root.20160524T1800/var/log/journal
>         [ 316158]  9cbb44cf160f4c1089f77e32ed376a0b
>
>     /backup/detritus/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b
>         [ 738979]  user-1000.journal
>
> both trimmed down to only the relevant path.
>
> I don't know how the ML handles attachments, so incremental send
> stream (with --no-data) is here:
> http://dev.exherbo.org/~moben/send-receive_incremental.stream
>
> Let me know if you need anything else or if I misunderstood the tree
> thing. (I _think_ I can also provide the with-data send, but I'd like
> to take a look at that first ;) )


I just re-tested this with kernel 4.6.2 and progs 4.6 and the error is the same.

I also ran a scrub on both the send and receive fs and both came out
with 0 errors.

Another thing I noticed: the +C attr doesn't seem to be preserved by
send/receive:

    send # lsattr
/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal
    ----------------C--
/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal

    receive # lsattr
/backup/detritus/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal
    -------------------
/backup/detritus/root/root.20160524T1800/var/log/journal/9cbb44cf160f4c1089f77e32ed376a0b/user-1000.journal

Might be related, given that /var/log/journal (and its children) are
the only dirs/files with +C on this system afaik.

Cheers
Benedikt
