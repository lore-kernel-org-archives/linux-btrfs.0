Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:64227 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949Ab3K1KkM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 28 Nov 2013 05:40:12 -0500
Received: by mail-qe0-f48.google.com with SMTP id gc15so8793530qeb.7
        for <linux-btrfs@vger.kernel.org>; Thu, 28 Nov 2013 02:40:09 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAC6NtXzhkfpKf+n1kaCj+xRaPnVr-rvz5Sahi1qUXxUbJV9VVQ@mail.gmail.com>
References: <CAC6NtXzhkfpKf+n1kaCj+xRaPnVr-rvz5Sahi1qUXxUbJV9VVQ@mail.gmail.com>
Date: Thu, 28 Nov 2013 18:40:09 +0800
Message-ID: <CAC6NtXw15KM_hx9tazA=NMA6ikN4fCb028=03uWREjCFKj+iUw@mail.gmail.com>
Subject: Fwd: Linux 3.8.0-33-generic - btrfs: open_ctree failed causes mount failure
From: Juan Poh <juanpoh@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi

I have a btrfs corruption on a external hard disk which cause mount to fail:
[179649.291047] btrfs: bdev /dev/loop0 errs: wr 2, rd 0, flush 0,
corrupt 0, gen 0
[179649.291473] parent transid verify failed on 59394068480 wanted
84587 found 84589
[179649.291763] parent transid verify failed on 59394068480 wanted
84587 found 84589
[179649.291776] Failed to read block groups: -5
[179649.312476] btrfs: open_ctree failed

On Ubuntu 13.04, btrfsck would assert with the following error:
btrfsck: disk-io.c:441: find_and_setup_root: Assertion `!(ret)' failed.

I have backup the disk partition using ddrescue. Using Ubuntu 13.10,
btrfsck on the disk image would display:
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
Ignoring transid failure
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
Ignoring transid failure
Couldn't setup extent tree
Checking filesystem on sdc2.img
UUID: cb1f0291-623e-40c3-826b-c4e2e0fc000a
Critical roots corrupted, unable to fsck the FS

btrfs-image would failed too with similar message except the last few lines:
Couldn't setup extent tree
extent buffer leak: start 59394023424 len 4096
Open ctree failed
create failed (Success)

I have tried btrfs-find-root which generate a long list of the "Well
block xxx" message and eventually stop:
Well block 204095827968 seems great, but generation doesn't match,
have=72672, want=84589 level 0
Super think's the tree root is at 59394023424, chunk root 20971520
No more metdata to scan, exiting


# btrfs restore -t 59394023424 sdc2.img ./home
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
parent transid verify failed on 59394023424 wanted 84589 found 84587
Ignoring transid failure
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
parent transid verify failed on 59394068480 wanted 84587 found 84589
Ignoring transid failure
Couldn't setup extent tree
parent transid verify failed on 59394068480 wanted 84587 found 84589
Ignoring transid failure
Couldn't read fs root: -2
extent buffer leak: start 59394023424 len 4096

I am very keen to try patching the disk structure, for instance swap
84589 and 84587 at 59394023424 and 59394068480. Any guru can provide
any guidance or better idea on how to fix this?

Thanks and regards,
Juan Poh
