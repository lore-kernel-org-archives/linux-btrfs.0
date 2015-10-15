Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:35516 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266AbbJOQkh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Oct 2015 12:40:37 -0400
Received: by igbkq10 with SMTP id kq10so139754404igb.0
        for <linux-btrfs@vger.kernel.org>; Thu, 15 Oct 2015 09:40:36 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtR2-q3NUcDi6bfQUTzChu6wEbozvYEB_eNuK8toMf7KQQ@mail.gmail.com>
References: <2402569.dCkKzGyGNU@hoefnix>
	<CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
	<561EBC3D.8060004@bouton.name>
	<CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
	<CAGfcS_nid0dz2V+H=gAb-diRxwfj4sdYgCp6hR+5wucCwQHAWw@mail.gmail.com>
	<CAJCQCtR2-q3NUcDi6bfQUTzChu6wEbozvYEB_eNuK8toMf7KQQ@mail.gmail.com>
Date: Thu, 15 Oct 2015 12:40:36 -0400
Message-ID: <CAGfcS_mGHBzdevkaj8DHh=2Hkan8CVHmHrTak53UheaBH9pwLA@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 9:47 PM, Chris Murphy <lists@colorremedies.com> wrote:
>
> For that matter, now that GlusterFS has checksums and snapshots...

Interesting - I haven't kept up with that.  Does it actually do
end-to-end checksums?  That is, compute the checksum at the time of
storage, store the checksum in the metadata somehow, and ensure the
checksum matches when data is retrieved?

I forget whether it was glusterfs or ceph I was looking at, but some
of those distributed filesystems will only checksum data while in
transit, but not while it is at rest.  So, if a server claims it has a
copy of the file, then it is assumed to be a good copy and you never
realize that even though you have 5 copies of that file distributed
around the server you ended up using differs from the other 4.

I'm also not sure if it supports an n+1/2 model like raid5/6, or if it
is just a 2*n model like raid1.  If I want to store 5TB of data with
redundancy, I'd prefer to not need 10TB worth of drives to do it,
regardless of how many systems they're spread across.

--
Rich
