Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mondschein.lichtvoll.de ([194.150.191.11]:51236 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756760Ab2IJJMg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Sep 2012 05:12:36 -0400
Received: from merkaba.localnet (ppp-93-104-152-209.dynamic.mnet-online.de [93.104.152.209])
	by mail.lichtvoll.de (Postfix) with ESMTPSA id 6B75918E
	for <linux-btrfs@vger.kernel.org>; Mon, 10 Sep 2012 11:12:35 +0200 (CEST)
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-btrfs@vger.kernel.org
Subject: Re: Workaround for hardlink count problem?
Date: Mon, 10 Sep 2012 11:12:34 +0200
References: <20120908165620.GA17951@merlins.org> (sfid-20120908_190409_427728_9FF73D4B)
In-Reply-To: <20120908165620.GA17951@merlins.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201209101112.34839.Martin@lichtvoll.de>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Samstag, 8. September 2012 schrieb Marc MERLIN:
> I read the discussions on hardlinks, and saw that there was a proposed
> patch (although I'm not sure if it's due in 3.6 or not, or whether I
> can apply it to my 3.5.3 tree).
> 
> I was migrating a backup disk to a new btrfs disk, and the backup had a
> lot of hardlinks to collapse identical files to cut down on inode
> count and disk space.
> 
> Then, I started seeing:
[…]
> Has someone come up with a cool way to work around the too many link
> error and only when that happens, turn the hardlink into a file copy
> instead? (that is when copying an entire tree with millions of files).

What about:

- copy first backup version
- btrfs subvol create first next
- copy next backup version
- btrfs subvol create previous next

I use this scheme for my backup since quite a while. Except that first 
backup, then create a read only snapshot. And at some time remove old 
snapshots.

Works like a charm and is easily scriptable.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
