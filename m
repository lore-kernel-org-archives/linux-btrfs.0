Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from rin.romanrm.net ([37.187.97.211]:59779 "EHLO rin.romanrm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750812AbaJWQSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 23 Oct 2014 12:18:06 -0400
Date: Thu, 23 Oct 2014 22:18:03 +0600
From: Roman Mamedov <rm@romanrm.net>
To: Piotr =?UTF-8?B?UGF3xYJvdw==?= <pp@siedziba.pl>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: "Transaction commit" in btrfs sub del
Message-ID: <20141023221803.13832b4e@natsu>
In-Reply-To: <5449226E.606@siedziba.pl>
References: <20141023202411.701bd1f3@natsu>
	<5449226E.606@siedziba.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 23 Oct 2014 17:44:46 +0200
Piotr Pawłow <pp@siedziba.pl> wrote:

> On 23.10.2014 16:24, Roman Mamedov wrote:
> > I was under impression that the "Transaction commit:" setting in 'btrfs sub
> > del' finally allows us to make it not return until all free space from the
> > snapshots that are being deleted, is completely freed up.
> 
> This is not what "commit-each" or "commit-after" options do. These are 
> only to make sure, that the deletion is commited and the subvolume 
> doesn't reappear after a crash.

But is that not already ensured by a regular 'sync', or 'btrfs fi sync'?

> You probably want "subvolume sync" command, introduced in btrfs-progs 3.17:
> 
> btrfs subvolume sync <path> [<subvol-id>...]
>          Wait until given subvolume(s) are completely removed from the 
> filesystem.

Oh right, *that*'s the one I was thinking of.

-- 
With respect,
Roman
