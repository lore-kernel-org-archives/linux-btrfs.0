Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:56271 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753294Ab3CCP2n (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Mar 2013 10:28:43 -0500
Received: from mx1.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 8D8D07C039C
	for <linux-btrfs@vger.kernel.org>; Sun,  3 Mar 2013 08:28:42 -0700 (MST)
Date: Sun, 3 Mar 2013 10:28:39 -0500
From: Chris Mason <chris.mason@fusionio.com>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: same EXTENT_ITEM appears twice in the extent tree
Message-ID: <20130303152839.GC18135@shiny.masoncoding.com>
References: <CAOcd+r2p9AonnEwGZCS4CPUJ8O2EuQkSAA15twERY47FtrqLEw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <CAOcd+r2p9AonnEwGZCS4CPUJ8O2EuQkSAA15twERY47FtrqLEw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Mar 03, 2013 at 06:40:50AM -0700, Alex Lyakas wrote:
> Greetings all,
> I have an extent tree that looks like follows:
> 
> 	item 22 key (27059916800 EXTENT_ITEM 16384) itemoff 2656 itemsize 24
> 		extent refs 1 gen 164 flags 1
> 	item 23 key (27059916800 EXTENT_ITEM 98304) itemoff 2603 itemsize 53
> 		extent refs 1 gen 165 flags 1
> 		extent data backref root 257 objectid 257 offset 17446191104 count 1
> 	item 24 key (27059916800 SHARED_DATA_REF 47169536) itemoff 2599 itemsize 4
> 		shared data backref count 1

Have you been experimenting on this FS with snapshot deletion patches?

-chris
