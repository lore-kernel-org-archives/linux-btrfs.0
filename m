Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65274 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751768Ab2GTWjA (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 20 Jul 2012 18:39:00 -0400
Received: by pbbrp8 with SMTP id rp8so6831756pbb.19
        for <linux-btrfs@vger.kernel.org>; Fri, 20 Jul 2012 15:38:59 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5009B323.3040607@libero.it>
References: <1342811743-8748-1-git-send-email-jbacik@fusionio.com>
	<5009B323.3040607@libero.it>
Date: Fri, 20 Jul 2012 15:38:59 -0700
Message-ID: <CABgxfbFUQn0F4LDpUH=xcmwL_YTGK4HbU2-z0+3iW5uk=+xp_A@mail.gmail.com>
Subject: Re: [PATCH] Btrfs-progs: detect if the disk we are formatting is a
 ssd V2
From: Wendy Cheng <s.wendy.cheng@gmail.com>
To: kreijack@inwind.it
Cc: Josef Bacik <jbacik@fusionio.com>, linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jul 20, 2012 at 12:36 PM, Goffredo Baroncelli
<kreijack@libero.it> wrote:
> On 07/20/2012 09:15 PM, Josef Bacik wrote:
>> SSD's do not gain anything by having metadata DUP turned on.  The underlying
>> file system that is a part of all SSD's could easily map duplicate metadat
>
> If I understood correctly you are stating that because an SSD *might*
> "eliminates the benefit of duplicating the metadata"  mkfs.btrfs *must*
> remove _silently_ this behaviour on all SSD ?
>
> To me it seems too strong; or almost it should be documented in the man
> page and/or issuing a warning during the format process.

I'll have to second this .. this is my first time looking into btrfs -
do feel free to correct me if my reading is not correct.

Based on https://btrfs.wiki.kernel.org/index.php/Glossary, I assume
the DUP is a flag to ask for meta-data duplication within the same
device entity. This implies whenever an FS (meta-data) block is
updated, the duplicated FS block needs to be modified as well (true
?). So within a conventional SSD firmware implementation, it is true
that both FS blocks could end up in the same SSD block that get erased
and re-allocated together. Similar thing could happen with disks that
have embedded de-duplication feature turned on.

However, this should have been a task for the admin (or whoever types
this mkfs command). It is not a filesystem's job to assume how the
firmware works and silently ignore the DUP request, *unless* there is
a standard specification clearly describes linux devices that claim to
be not "rotational" should behave this way.

-- Wendy
