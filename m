Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:52650 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753412AbaLANrv (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 08:47:51 -0500
Date: Mon, 1 Dec 2014 18:47:49 +0500
From: Roman Mamedov <rm@romanrm.net>
To: MegaBrutal <megabrutal@gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Marc MERLIN <marc@merlins.org>,
        Shriramana Sharma <samjnaa@gmail.com>,
        Austin S Hemmelgarn <ahferroin7@gmail.com>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141201184749.0fd67b62@natsu>
In-Reply-To: <CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org>
	<547C6922.6030206@gmail.com>
	<CAE8gLhmn3aX88t1FO2=BnHXk0-+2xQ4dnW57dga93iA-bFaUzQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Dec 2014 14:38:16 +0100
MegaBrutal <megabrutal@gmail.com> wrote:

> I've also noticed, a subvolume can just be deleted with an "rm -r",
> just like an ordinary directory. I'd consider to only allow subvolume
> deletions with exact "btrfs subvolume delete" commands, and they

This is already the case. 'rm -r' will remove all files in a subvolume, but
the empty subvolume itself is only deletable via the 'btrfs' command.

If you want to make snapshots which can't be removed by ordinary tools, use
the 'read-only' mode when creating them.

-- 
With respect,
Roman
