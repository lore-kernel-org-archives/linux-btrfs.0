Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:35305 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933618Ab3GWTlv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 15:41:51 -0400
Received: by mail-wg0-f44.google.com with SMTP id l18so2560956wgh.23
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 12:41:50 -0700 (PDT)
Message-ID: <51EEDC7B.7040101@gmail.com>
Date: Tue, 23 Jul 2013 21:41:47 +0200
From: Gabriel de Perthuis <g2p.code@gmail.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Jerome Haltom <wasabi@cogito.cx>
Subject: Re: Q: Why subvolumes?
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com> <20130723150620.GG20517@carfax.org.uk> <51EEC1BD.9030001@gmail.com> <20130723193013.GI20517@carfax.org.uk>
In-Reply-To: <20130723193013.GI20517@carfax.org.uk>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le mar. 23 juil. 2013 21:30:13 CEST, Hugo Mills a écrit :
> On Tue, Jul 23, 2013 at 07:47:41PM +0200, Gabriel de Perthuis wrote:
>>>    Now... since the snapshot's FS tree is a direct duplicate of the
>>> original FS tree (actually, it's the same tree, but they look like
>>> different things to the outside world), they share everything --
>>> including things like inode numbers. This is OK within a subvolume,
>>> because we have the semantics that subvolumes have their own distinct
>>> inode-number spaces. If we could snapshot arbitrary subsections of the
>>> FS, we'd end up having to fix up inode numbers to ensure that they
>>> were unique -- which can't really be an atomic operation (unless you
>>> want to have the FS locked while the kernel updates the inodes of the
>>> billion files you just snapshotted).
>>
>> I don't think so; I just checked some snapshots and the inos are the same.
>> Btrfs just changes the dev_id of subvolumes (somehow the vfs allows this).
>
>    That's what I said. Our current implementation allows different
> subvolumes to have the same inode numbers, which is what makes it
> work. If you threw out the concept of subvolumes, or allowed snapshots
> within subvolumes, then you'd be duplicating inodes within a
> subvolume, which is one reason it doesn't work.

Sorry for misreading you.
Directory snapshots can work by giving a new device number to the snapshot.
There is no need to update inode numbers in that case.
