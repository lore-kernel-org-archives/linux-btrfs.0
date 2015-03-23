Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from gardel.0pointer.net ([85.214.157.71]:46375 "EHLO
	gardel.0pointer.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752872AbbCWFBZ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 23 Mar 2015 01:01:25 -0400
Date: Mon, 23 Mar 2015 05:53:14 +0100
From: Lennart Poettering <mzerqung@0pointer.de>
To: Chris Murphy <lists@colorremedies.com>
Cc: kreijack@inwind.it,
        systemd Mailing List <systemd-devel@lists.freedesktop.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [systemd-devel] systemd and nested Btrfs subvolumes
Message-ID: <20150323045314.GD19498@gardel-login>
References: <CAJCQCtRFUMAeyjLxADKLVaHA0wqQBY_tbyZoJJ6Hze7AeeTa_w@mail.gmail.com>
 <550C7655.10907@libero.it>
 <CAJCQCtRFnCm=ug4Byd=A+mT+CrUPrrGW_T+SzYaD+mLc6wypOA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAJCQCtRFnCm=ug4Byd=A+mT+CrUPrrGW_T+SzYaD+mLc6wypOA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 20.03.15 18:08, Chris Murphy (lists@colorremedies.com) wrote:

> Sure but now it's missing if you do a rollback, or if you mount any
> different root tree, so immediately special handling is needed.
> 
> If machines is a subvolume at the top level, it can always be mounted
> at /var/lib/machines regardless of which root is used.
> 
> I also think this is more consistent with
> http://0pointer.net/blog/revisiting-how-we-put-together-linux-systems.html
> specifically the section "What We Propose" when it comes to the
> location and naming convention for Btrfs subvolumes.

containers are recursively stackable, hence having toplevel subvolumes
doesn't work, since the containers should be able to have
subcontainers of their own...

Also, it kinda defeats the whole point of btrfs' subvolume concept,
where subvolumes are little more than special directories.

Lennart

-- 
Lennart Poettering, Red Hat
