Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from outrelay06.libero.it ([212.52.84.110]:58085 "EHLO
	outrelay06.libero.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751899AbaJVRco (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Oct 2014 13:32:44 -0400
Message-ID: <5447EA3A.6070905@inwind.it>
Date: Wed, 22 Oct 2014 19:32:42 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Robert White <rwhite@pobox.com>, Arnaud Kapp <kapp.arno@gmail.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: 5 _thousand_ snapshots? even 160?
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com> <5446BEC0.8070009@siedziba.pl> <5446C597.9080904@gmail.com> <54470403.8020904@pobox.com>
In-Reply-To: <54470403.8020904@pobox.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/22/2014 03:10 AM, Robert White wrote:
> Each snapshot is effectively stapling down one version of your
> entire metadata tree, right ?
On the best of my knowledge, I cannot confirm that.

I understood (please, be free to correct me if I am wrong) that each snapshot create a copy of the changed leaf (of the (b)tree), and update (doing a copy) all the nodes up to the tree root.

[...]
> (Of course I could be wrong about the "never move" rule, but that 
> would just make the checksums on the potentially hundreds or 
> thousands of references need to be recalculated after a move, which 
> would make incremental send/receive unfathomable.)

Between the physical data on the disk and the logical data see by the tree(s) there is an indirection layer: the tree chunks.
Near all the trees refer to the data in terms of  "logical" position. The logical position is  translated to the physical one by the tree chunks.
The balance is related to the movement of the chunk between the disks. But the data is unchanged.

Anyway I fully agree with you when you say:
> Snapshots are cheap but they aren't free. 

BR
G.Baroncelli



-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
