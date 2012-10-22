Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:56440 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab2JVL5N (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 22 Oct 2012 07:57:13 -0400
Received: by mail-pa0-f46.google.com with SMTP id hz1so1877514pad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Oct 2012 04:57:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <50853089.6010801@cn.fujitsu.com>
References: <50853089.6010801@cn.fujitsu.com>
Date: Mon, 22 Oct 2012 05:57:12 -0600
Message-ID: <CAE5mzvhaQLZEMgyAPGZ7pFbNR9c17ke1FGRXUfY86vD31_3viQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] Btrfs: do not delete a subvolume which is in a R/O subvolume
From: cwillu <cwillu@cwillu.com>
To: miaox@cn.fujitsu.com
Cc: Linux Btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 22, 2012 at 5:39 AM, Miao Xie <miaox@cn.fujitsu.com> wrote:
> Step to reproduce:
>  # mkfs.btrfs <disk>
>  # mount <disk> <mnt>
>  # btrfs sub create <mnt>/subv0
>  # btrfs sub snap <mnt> <mnt>/subv0/snap0
>  # change <mnt>/subv0 from R/W to R/O
>  # btrfs sub del <mnt>/subv0/snap0
>
> We deleted the snapshot successfully. I think we should not be able to delete
> the snapshot since the parent subvolume is R/O.

snap0 isn't read-only in that case, right?  From a user interaction
standpoint, this seems like it just forces a user to rm -rf rather
btrfs sub del, which strikes me as a bit ham-handed when all we really
care about is leaving a (the?) directory entry where snap0 used to be.
