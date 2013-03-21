Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f181.google.com ([209.85.214.181]:42404 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab3CUPaD (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Mar 2013 11:30:03 -0400
Received: by mail-ob0-f181.google.com with SMTP id ni5so2958398obc.26
        for <linux-btrfs@vger.kernel.org>; Thu, 21 Mar 2013 08:30:01 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <514B232E.2050705@redhat.com>
References: <CAKuK5J05iXaDd7Q4fLby9vJyPXBURx06xb0_--WmgTpJ0j2RoA@mail.gmail.com>
 <514B232E.2050705@redhat.com>
From: Jon Nelson <jnelson@jamponi.net>
Date: Thu, 21 Mar 2013 10:29:40 -0500
Message-ID: <CAKuK5J3Fd+ya3SOwQPZohJArE+cPNZKchzH3UkvpvoAnK-6Hng@mail.gmail.com>
Subject: Re: btrfs-show vs. btrfs different output
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Mar 21, 2013 at 10:11 AM, Eric Sandeen <sandeen@redhat.com> wrote:
> On 3/21/13 10:04 AM, Jon Nelson wrote:
...
>> 2. the current git btrfs-show and btrfs fi show both output
>> *different* devices for device with UUID
>> b5dc52bd-21bf-4173-8049-d54d88c82240, and they're both wrong.
>
> does blkid output find that uuid anywhere?
>
> Since you're working in git, can you maybe do a little bisecting
> to find out when it changed?  Should be a fairly quick test?

blkid does /not/ report that uuid anywhere.

git bisect, if I did it correctly, says:


6eba9002956ac40db87d42fb653a0524dc568810 is the first bad commit
commit 6eba9002956ac40db87d42fb653a0524dc568810
Author: Goffredo Baroncelli <kreijack@inwind.it>
Date:   Tue Sep 4 19:59:26 2012 +0200

    Correct un-initialized fsid variable

:100644 100644 b21a87f827a6250da45f2fb6a1c3a6b651062243
03952051b5e25e0b67f0f910c84d93eb90de8480 M      disk-io.c





-- 
Jon
Software Blacksmith
