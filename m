Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36744 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751098AbbJOBrm (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 14 Oct 2015 21:47:42 -0400
Received: by igbif5 with SMTP id if5so33534477igb.1
        for <linux-btrfs@vger.kernel.org>; Wed, 14 Oct 2015 18:47:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAGfcS_nid0dz2V+H=gAb-diRxwfj4sdYgCp6hR+5wucCwQHAWw@mail.gmail.com>
References: <2402569.dCkKzGyGNU@hoefnix>
	<CAC=t97Awr6-pWGAXEMaRfFnPGKJiPyRH2g39oN+0WzhNYFrBNg@mail.gmail.com>
	<561EBC3D.8060004@bouton.name>
	<CAC=t97COVc4kQ+A-jSVr3ujGb-0WGNh2qCcohBvLFw=YtnObhA@mail.gmail.com>
	<CAGfcS_nid0dz2V+H=gAb-diRxwfj4sdYgCp6hR+5wucCwQHAWw@mail.gmail.com>
Date: Wed, 14 Oct 2015 19:47:42 -0600
Message-ID: <CAJCQCtR2-q3NUcDi6bfQUTzChu6wEbozvYEB_eNuK8toMf7KQQ@mail.gmail.com>
Subject: Re: RAID6 stable enough for production?
From: Chris Murphy <lists@colorremedies.com>
To: Rich Freeman <r-btrfs@thefreemanclan.net>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 14, 2015 at 3:15 PM, Rich Freeman
<r-btrfs@thefreemanclan.net> wrote:

> This is the main thing that has kept me away from zfs - you can't
> modify a vdev, like you can with an md array or btrfs.

A possible work around is ZoL (ZFS on Linux) used as a GlusterFS brick.

For that matter, now that GlusterFS has checksums and snapshots, if
your workflow permits use a glusterfs only workflow (using SMB or NFS
for Windows or OS X, and the libvirt glusterfs backend for images) you
could build a conventional md/lvm RAID+XFS brick and then glusterfs on
that. And with distributed-replicated you can bail on raid6 and just
go raid 5. Heck if you have enough bricks you could do raid0 and just
let the bricks implode if need be.


-- 
Chris Murphy
