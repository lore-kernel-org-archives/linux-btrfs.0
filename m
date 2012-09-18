Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:58726 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754481Ab2IRTY0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Sep 2012 15:24:26 -0400
Received: by obbuo13 with SMTP id uo13so266638obb.19
        for <linux-btrfs@vger.kernel.org>; Tue, 18 Sep 2012 12:24:25 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120802114631.GM17430@twin.jikos.cz>
References: <501A04CE.9090408@cn.fujitsu.com>
	<20120802114631.GM17430@twin.jikos.cz>
Date: Tue, 18 Sep 2012 14:24:25 -0500
Message-ID: <CAKcLGm9j57gdp7zx5RQjMGzE4U_1wJugUuZ+-GEoqsXxmm1wuQ@mail.gmail.com>
Subject: Re: [PATCH V3 2/2] Btrfs: fix the snapshot that should not exist
From: Mitch Harder <mitch.harder@sabayonlinux.org>
To: dave@jikos.cz, Miao Xie <miaox@cn.fujitsu.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Josef Bacik <jbacik@fusionio.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Seto Hidetoshi <seto.hidetoshi@jp.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Aug 2, 2012 at 6:46 AM, David Sterba <dave@jikos.cz> wrote:
...
>
> Fsck spits lots of errors:
>
> ref mismatch on [1133031424 4096] extent item 1, found 0
> Backref 1133031424 root 5 not referenced back 0x7d1f40
> Incorrect global backref count on 1133031424 found 1 wanted 0
> backpointer mismatch on [1133031424 4096]
> owner ref check failed [1133031424 4096]
>
> ref mismatch on [11213131776 16384] extent item 1, found 0
> Incorrect local backref count on 11213131776 root 5 owner 34509 offset 0 found 0 wanted 1 back 0x1424d8e0
> backpointer mismatch on [11213131776 16384]
> owner ref check failed [11213131776 16384]
>
> fs tree 260 refs 6 not found
>         unresolved ref root 263 dir 256 index 4 namelen 14 name snap2748615355 error 600
>         unresolved ref root 267 dir 256 index 4 namelen 14 name snap2748615355 error 600
>         unresolved ref root 269 dir 256 index 4 namelen 14 name snap2748615355 error 600
>         unresolved ref root 273 dir 256 index 4 namelen 14 name snap2748615355 error 600
>         unresolved ref root 274 dir 256 index 4 namelen 14 name snap2748615355 error 600
>         unresolved ref root 276 dir 256 index 4 namelen 14 name snap2748615355 error 600
>
>
> I've asked Josef to pull those patches out of btrfs-next, feel free to send me any testing
> version if you can't reproduce it on your side.
>

I've run into similar errors after an unclean shutdown on a partition
where I make use of several subvolumes.

Some of the data in the subvolume is inaccessible, although the
original root volume seems OK.

So far, the partition is resisting my efforts to fix the errors.

This unclean shutdown occurred while using a 3.5.3 kernel merged with
the for-linus branch, so it did not contain any of Miao Xie's recent
patches to address this issue.

I've made an image of the corrupted volume if anybody has something
they'd like me to test.  But I'm primarily reporting this to let you
know I'm seeing errors similar to the one's thrown off by your test
case.

I'm going to look into merging the patches from Josef's btrfs-next to
see if the problem recurs.
