Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:55037 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934017Ab3GWTnO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 15:43:14 -0400
Received: by mail-pd0-f182.google.com with SMTP id r10so8510551pdi.41
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 12:43:13 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130723193013.GI20517@carfax.org.uk>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
	<20130723150620.GG20517@carfax.org.uk>
	<51EEC1BD.9030001@gmail.com>
	<20130723193013.GI20517@carfax.org.uk>
Date: Tue, 23 Jul 2013 14:43:13 -0500
Message-ID: <CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
Subject: Re: Q: Why subvolumes?
From: Jerome Haltom <wasabi@cogito.cx>
To: Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Jerome Haltom <wasabi@cogito.cx>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Why not just create the new dev_id on the destination snapshot of any
directory? That way the snapshot can share inodes with is source.

On Tue, Jul 23, 2013 at 2:30 PM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Jul 23, 2013 at 07:47:41PM +0200, Gabriel de Perthuis wrote:
>> >    Now... since the snapshot's FS tree is a direct duplicate of the
>> > original FS tree (actually, it's the same tree, but they look like
>> > different things to the outside world), they share everything --
>> > including things like inode numbers. This is OK within a subvolume,
>> > because we have the semantics that subvolumes have their own distinct
>> > inode-number spaces. If we could snapshot arbitrary subsections of the
>> > FS, we'd end up having to fix up inode numbers to ensure that they
>> > were unique -- which can't really be an atomic operation (unless you
>> > want to have the FS locked while the kernel updates the inodes of the
>> > billion files you just snapshotted).
>>
>> I don't think so; I just checked some snapshots and the inos are the same.
>> Btrfs just changes the dev_id of subvolumes (somehow the vfs allows this).
>
>    That's what I said. Our current implementation allows different
> subvolumes to have the same inode numbers, which is what makes it
> work. If you threw out the concept of subvolumes, or allowed snapshots
> within subvolumes, then you'd be duplicating inodes within a
> subvolume, which is one reason it doesn't work.
>
>    Hugo.
>
> --
> === Hugo Mills: hugo@... carfax.org.uk | darksatanic.net | lug.org.uk ===
>   PGP key: 65E74AC0 from wwwkeys.eu.pgp.net or http://www.carfax.org.uk
>          --- Unix: For controlling fungal diseases in crops. ---
