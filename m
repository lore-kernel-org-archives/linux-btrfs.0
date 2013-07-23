Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f173.google.com ([209.85.214.173]:60896 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933968Ab3GWXj5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 23 Jul 2013 19:39:57 -0400
Received: by mail-ob0-f173.google.com with SMTP id er7so2950296obc.4
        for <linux-btrfs@vger.kernel.org>; Tue, 23 Jul 2013 16:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <79612879-8561-4924-B996-570B8594237F@colorremedies.com>
References: <CA+V+5QrNAo_RVEiONHRqkN5O89jgtoFDecuWnu41_ovJmLVhuA@mail.gmail.com>
	<20130723150620.GG20517@carfax.org.uk>
	<51EEC1BD.9030001@gmail.com>
	<20130723193013.GI20517@carfax.org.uk>
	<CA+V+5QriWTMdyX+M=hi=e_nZkK2oLKhXus8kmjX_KpYPBTRVrw@mail.gmail.com>
	<79612879-8561-4924-B996-570B8594237F@colorremedies.com>
Date: Tue, 23 Jul 2013 18:39:57 -0500
Message-ID: <CA+V+5QoSFZOc_nekBUQQSQo+wn5mNaqJNDuq=kwU23a01Nn1Kw@mail.gmail.com>
Subject: Re: Q: Why subvolumes?
From: Jerome Haltom <wasabi@cogito.cx>
To: Chris Murphy <lists@colorremedies.com>, Hugo Mills <hugo@carfax.org.uk>,
        Gabriel de Perthuis <g2p.code@gmail.com>
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Yeah. I was merely curious about the architecture limits that drove
the design this way, to begin with. Mostly because it seems "odd". It
seems like the most obvious and most natural thing from the user's
perspective to do would just be able to reflink directories. Like
every decent source control system that exists, for instance. So, I
figured there must be some very good reason it wasn't done like that.

I'm still not completely sure what that very good reason is. Obviously
whatever structure that currently exists for subvolumes would need to
continue existing, to begin a unique inode scope. But, since
apparently the VFS can be instructed to plop a new dev_id anywhere in
the hierarchy, I I still don't see why explicit subvolumes are
required. Seems more natural to be able to put a quota on a directory.
To be able to set raid policy on a directory. Compression on a
directory. COW semantics on a directory. Etc.

Ahh well, some of you gave really nice detailed answers, and I
appreciate that. Thanks.

On Tue, Jul 23, 2013 at 4:52 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> On Jul 23, 2013, at 1:43 PM, Jerome Haltom <wasabi@cogito.cx> wrote:
>
>> Why not just create the new dev_id on the destination snapshot of any
>> directory?
>
> Right now, snapshots of subvolumes do not contain the contents of contained subvolumes. Hmmm, that sounds horrid.
>
> Subvolume A
>         File 1
>         File 2
>         Subvolume B
>                 File 3
>                 File 4
>
> If I snapshot subvolume A, the resulting snapshot does not contain File 3 and File 4. Subvolume B is a regular folder in the snapshot of Subvolume A.
>
> So if every directory were a subvolume by default, this limitation would need to be resolved or snapshotting would become useless. I'm sure there's a more coherent explanation why this isn't desired.
>
>> That way the snapshot can share inodes with is source.
>
>
> Snapshots already share inode numbers.
>
>
> Chris Murphy--
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
