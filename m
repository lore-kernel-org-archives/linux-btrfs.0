Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:42792 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752147AbdC0NP6 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 27 Mar 2017 09:15:58 -0400
Subject: Re: backing up a file server with many subvolumes
To: jfhart085@gmail.com
References: <58D72EC4.9020101@gmail.com>
 <59dccd7e-6cb6-ea66-3150-0ce85472e73a@rqc.ru> <58D8FEEB.1080100@gmail.com>
Cc: linux-btrfs@vger.kernel.org
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <a68aba4d-c417-4f93-fc59-80bc731261c1@cobb.uk.net>
Date: Mon, 27 Mar 2017 14:05:26 +0100
MIME-Version: 1.0
In-Reply-To: <58D8FEEB.1080100@gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 27/03/17 13:00, J. Hart wrote:
> That is a very interesting idea.  I'll try some experiments with this.

You might want to look into two tools which I have found useful for
similar backups:

1) rsnapshot -- this uses rsync for backing up multiple systems and has
been stable for quite a long time. If the target disk is btrfs it is
fairly easy to configure so that it uses btrfs snapshots to create and
remove the snapshot directories, speeding up the process. This doesn't
really use any complex btrfs features and has been stable for me even on
my Debian stable (kernel 3.16.39) system.

2) btrbk -- this allows you to create and manage btrfs snapshots on the
source disk as well as backup snapshots on a separate btrfs disk. You
can separately control how many snapshots you keep online on both the
source and the backup disk. This is particularly useful for cases where
you want to take very frequent snapshots (say hourly) for which rsync
may be too slow (and rsync does not take a consistent snapshot, of course).

There are many other tools, of course (I also take daily backups with
dar to an ext4 system, without using any btrfs features at all, just in
case a new version of btrfs suddenly decided to correct all copies of
IHATEBTRFS on the disk to ILOVEBTRFS, for example :-) ).

Graham

Note to self: re-read this message periodically to check that feature
hasn't appeared yet.
