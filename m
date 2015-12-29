Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:34074 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752370AbbL2VB7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 29 Dec 2015 16:01:59 -0500
Received: by mail-io0-f173.google.com with SMTP id 1so11352879ion.1
        for <linux-btrfs@vger.kernel.org>; Tue, 29 Dec 2015 13:01:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <568198A6.10806@GMX.net>
References: <567323AA.70203@GMX.net>
	<568198A6.10806@GMX.net>
Date: Wed, 30 Dec 2015 08:01:58 +1100
Message-ID: <CA+GUGJ0uJbRe04FxPqm_OBTYTcpWzPCUMDo5BRJm1JgL_vs1HA@mail.gmail.com>
Subject: Re: Trouble with broken RAID5/6 System after trying to solve a
 problem, want to recover contained Data
From: Alistair Grant <akgrant0710@gmail.com>
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Dec 29, 2015 at 7:16 AM, Christian <Kamiekatze@gmx.net> wrote:
> I found out, that i can also show more Information about Files and Diretories contained in the Filesystem.
>
> btrfs-debug-tree show me the following Infos:
>
> parent transid verify failed on 2234958286848 wanted 35674 found 35675
> parent transid verify failed on 2234958286848 wanted 35674 found 35675
> ...
>
>
> Does someone know how to recover the files from the Filesystem?
>
> Kind regards,
>         Christian

The first place to look is: https://btrfs.wiki.kernel.org/index.php/Restore

If you search the list history, Duncan has also written several
informative responses.  The one I have bookmarked is:

* https://mail-archive.com/linux-btrfs@vger.kernel.org/msg49181.html
  - my original cry for help
* https://mail-archive.com/linux-btrfs@vger.kernel.org/msg49282.html
  - this is a short cut to the main description, but the whole thread
    should probably be read.

Cheers,
Alistair
