Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wm0-f54.google.com ([74.125.82.54]:37466 "EHLO
        mail-wm0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754741AbdGXUn3 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 16:43:29 -0400
Received: by mail-wm0-f54.google.com with SMTP id c184so41090130wmd.0
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 13:43:29 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAMp4zn8YUdVShFibUKCXtwZTZpicCbmm7zSYMn7+K5CNt-cxGA@mail.gmail.com>
References: <CAJCQCtQiCcWZXhXo1nDt0qeGHr=WQH1cs8Syrbc9cXwez8ENjg@mail.gmail.com>
 <20170713223205.GB6181@lim.localdomain> <CAJCQCtSpJkVzH=jL7+1J2jHncCBxwFS_eDNs_q+q6uUdTG8DAQ@mail.gmail.com>
 <9a73851d-e4c7-f395-285e-5cf3e835c2b7@gmx.com> <CAMp4zn8YUdVShFibUKCXtwZTZpicCbmm7zSYMn7+K5CNt-cxGA@mail.gmail.com>
From: Chris Murphy <lists@colorremedies.com>
Date: Mon, 24 Jul 2017 14:43:28 -0600
Message-ID: <CAJCQCtQRX0pwh2DgMdZOqc3Gk8zhYL2Bjt1+Z4gw8VntV6BVrQ@mail.gmail.com>
Subject: Re: Containers, Btrfs vs Btrfs + overlayfs
To: Sargun Dhillon <sargun@sargun.me>
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Chris Murphy <lists@colorremedies.com>,
        bo.li.liu@oracle.com, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 13, 2017 at 8:24 PM, Sargun Dhillon <sargun@sargun.me> wrote:

> We've been running Btrfs with Docker at appreciable scale for a few
> months now (100-200k containers  / day ).

Is this on a single Btrfs file system? Or is it distributed among
multiple Btrfs file systems?

I'm curious how many containers or more specifically how many
snapshots you've typically accumulated before doing cleanups (deleting
containers and their snapshots).


> Since containers are ephemeral, they really shouldn't fsync. One of
> the biggest (recent) problems has been workloads that use O_SYNC, or
> sync after a large number of operations -- this stalls out all of the
> containers (subvolumes) on the machine because the transaction lock is
> under hold. This, in turn, manifests itself in soft lockups, and
> operational trouble. Our plan to work around it is patch the VFS
> layer, and stub out sync for certain cgroups.

This could even be useful for out of band OS updates. That use case is
a much smaller scale, so it's not such a big problem. But I see heavy
fsyncing for OS/application updates in the RPM world, and it's just
not necessary if the update is happening on its own tree. If there's a
problem with the update, just blow away the partially updated snapshot
and start over. The fsyncing throughout gains nothing but slow downs.



-- 
Chris Murphy
