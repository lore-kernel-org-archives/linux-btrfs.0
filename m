Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:53489 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759996Ab3EBDA7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 1 May 2013 23:00:59 -0400
Received: by mail-la0-f48.google.com with SMTP id eg20so106979lab.21
        for <linux-btrfs@vger.kernel.org>; Wed, 01 May 2013 20:00:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABNez5RD9qzZ7-hM7u0-mwUx5MFCMOOCsqW-LBxQx-vcmoKcdg@mail.gmail.com>
References: <CABNez5RD9qzZ7-hM7u0-mwUx5MFCMOOCsqW-LBxQx-vcmoKcdg@mail.gmail.com>
Date: Thu, 2 May 2013 11:00:57 +0800
Message-ID: <CAF1ivSashGu_yYge1wxMqzfA-5uh+af=11nzj5=VSU=_gqbF8w@mail.gmail.com>
Subject: Re:
From: Lin Ming <mlin@kernel.org>
To: =?ISO-8859-1?Q?Peter_W=FCrtz?= <pwuertz@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Apr 27, 2013 at 5:42 PM, Peter Würtz <pwuertz@gmail.com> wrote:
> Hi!
>
> I recently had some trouble with my root and home btrfs filesystems.
> My system (Ubuntu 13.04, Kernel 3.8) started freezing when copying
> larger numbers of files around (hard freeze, no logs about what
> happened).
>
> At some time booting up wasn't possible anymore due to a kernel bug
> while mounting the homefs. Btrfsck built from git wasn't able to
> repair the fs and segfaulted. Btrfs-zero-log was able to make home

Hi,

Here is the patch to fix the segfault.
https://patchwork.kernel.org/patch/2509881/

Could you also report the bug onto bugzilla.kernel.org?
http://marc.info/?l=linux-btrfs&m=136733749808576&w=2

Lin Ming
