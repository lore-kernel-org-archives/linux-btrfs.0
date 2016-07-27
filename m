Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34520 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758679AbcG0CKY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Jul 2016 22:10:24 -0400
Received: by mail-qk0-f182.google.com with SMTP id o67so22807706qke.1
        for <linux-btrfs@vger.kernel.org>; Tue, 26 Jul 2016 19:10:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAEg8mkzkstRBSxKWkwXc9_Fmi5AnbnNd1UrUmvrQLPZv4Mnecg@mail.gmail.com>
References: <CAEg8mkzkstRBSxKWkwXc9_Fmi5AnbnNd1UrUmvrQLPZv4Mnecg@mail.gmail.com>
From: john gong <johngong0791@gmail.com>
Date: Wed, 27 Jul 2016 10:10:23 +0800
Message-ID: <CAEg8mkyRfWqcyucBd2swKS4G+N4onHGJoz0ULafNuq6CTYk=bQ@mail.gmail.com>
Subject: Re: perhaps a error in setup_root_args func
To: Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Just skip up. I made a mistake.
Sorry for that.

On Wed, Jul 27, 2016 at 9:51 AM, john gong <johngong0791@gmail.com> wrote:
> hi All,
>
> In func setup_root_args in fs/btrfs/super.c:
>     while (1) {
>         sep = strchrnul(args, ',');
>         if (!strstarts(args, "subvol=") &&
>             !strstarts(args, "subvolid=")) {
>
> I think it should be:
>     while (1) {
>         sep = strchrnul(args, ',');
>         if (!strstarts(args, "subvol=") || <- CHANGE
>             !strstarts(args, "subvolid=")) {
>
> Am i right?
> I am on linus tree, have not check the btrfs tree cause the code is
> being download.
>
> B.R.
>
> JohnGong
