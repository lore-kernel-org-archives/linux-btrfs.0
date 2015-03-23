Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yh0-f42.google.com ([209.85.213.42]:32878 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751766AbbCWF1Y (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 01:27:24 -0400
Received: by yhpt93 with SMTP id t93so63635990yhp.0
        for <linux-btrfs@vger.kernel.org>; Sun, 22 Mar 2015 22:27:23 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150323045314.GD19498@gardel-login>
References: <CAJCQCtRFUMAeyjLxADKLVaHA0wqQBY_tbyZoJJ6Hze7AeeTa_w@mail.gmail.com>
	<550C7655.10907@libero.it>
	<CAJCQCtRFnCm=ug4Byd=A+mT+CrUPrrGW_T+SzYaD+mLc6wypOA@mail.gmail.com>
	<20150323045314.GD19498@gardel-login>
Date: Sun, 22 Mar 2015 23:27:22 -0600
Message-ID: <CAJCQCtSw=+=+LF9MCP6hsHQ1yew_Q=J4bWGy=tv3Ugz+rSHLrw@mail.gmail.com>
Subject: Re: [systemd-devel] systemd and nested Btrfs subvolumes
From: Chris Murphy <lists@colorremedies.com>
To: Lennart Poettering <mzerqung@0pointer.de>
Cc: kreijack@inwind.it,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 22, 2015 at 10:53 PM, Lennart Poettering
<mzerqung@0pointer.de> wrote:
> On Fri, 20.03.15 18:08, Chris Murphy (lists@colorremedies.com) wrote:
>
>> Sure but now it's missing if you do a rollback, or if you mount any
>> different root tree, so immediately special handling is needed.
>>
>> If machines is a subvolume at the top level, it can always be mounted
>> at /var/lib/machines regardless of which root is used.
>>
>> I also think this is more consistent with
>> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
>> specifically the section "What We Propose" when it comes to the
>> location and naming convention for Btrfs subvolumes.
>
> containers are recursively stackable, hence having toplevel subvolumes
> doesn't work, since the containers should be able to have
> subcontainers of their own...
>
> Also, it kinda defeats the whole point of btrfs' subvolume concept,
> where subvolumes are little more than special directories.

They're much more than that, they're a separate fs tree. They're maybe
something between a completely separate filesystem volume, and a
directory. They each have their own inodes, so it's possible (if not
likely) that on a Btrfs volume an inode will point to multiple files
in different subvolumes.

http://marc.info/?l=linux-btrfs&m=137462926329422&w=2

-- 
Chris Murphy
