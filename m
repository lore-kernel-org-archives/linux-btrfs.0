Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.21]:52567 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752148AbaDWQep (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Apr 2014 12:34:45 -0400
Message-ID: <5357EBA2.7030605@gmx.net>
Date: Wed, 23 Apr 2014 18:34:42 +0200
From: Marcel Partap <mpartap@gmx.net>
MIME-Version: 1.0
To: Mitch Harder <mitch.harder@sabayonlinux.org>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: How to view transaction log chronologically, human-readable?
References: <53113626.3060706@gmx.net>	<5322E39C.3030802@gmx.net>	<5352D26A.70601@gmx.net> <CAKcLGm9Ng4J2rGsC_JUpG+A6Q5bR81kSD8zBAONjkrqsLuUyWQ@mail.gmail.com>
In-Reply-To: <CAKcLGm9Ng4J2rGsC_JUpG+A6Q5bR81kSD8zBAONjkrqsLuUyWQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> I am not a "dev", but since BTRFS utilizes a COW (Copy On Write)
> architecture, it doesn't keep a journal or history of transactions
> that can be unwound.
Ok, thanks for making that clear, I wasn't aware of that.
But shouldn't the chain of recent root trees kinda allow similar
functionality?

> It sounds like you've effectively tried this manually, but here's a
> link to an btrfs undelete script that also makes use of
> btrfs-find-root and 'btrfs restore':
Actually I was using that script as a starting point.. Unfortunately,
the files I was looking for were nowhere to be found..
>From a journal-type functionality I was hoping for a way to actually see
the most recent file system actions..
Is there no hope to recreate that information from the roots
btrfs-find-root comes up with?

#Regards
