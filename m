Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:35872 "EHLO pim.lukas-pirl.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1030470AbdIZLum (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 26 Sep 2017 07:50:42 -0400
Subject: Re: btrfs scrub crashes OS
To: Qu Wenruo <quwenruo.btrfs@gmx.com>
References: <6e6dc9a3-b3e9-2831-8149-94f7c11b9df1@lukas-pirl.de>
 <67942154-0940-e1f3-318a-6a9a893fe351@gmx.com>
 <f01fc6f7-a0d4-dbae-b5fa-ea51842c4793@lukas-pirl.de>
 <9e86bf20-a686-4c73-22d8-1f8332409c54@gmx.com>
 <e9cfdde0-f07d-c73b-23f0-49ef55709240@lukas-pirl.de>
 <2c7db235-827c-1f17-484b-2a7f8da4810c@gmx.com>
Cc: linux-btrfs@vger.kernel.org
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <2d813e0f-2b9e-90b0-039f-58cc6a55d4e4@lukas-pirl.de>
Date: Tue, 26 Sep 2017 13:50:32 +0200
MIME-Version: 1.0
In-Reply-To: <2c7db235-827c-1f17-484b-2a7f8da4810c@gmx.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/26/2017 11:36 AM, Qu Wenruo wrote as excerpted:
> This is strange, this means that we can't find a chunk map for a 72K
> length data extent.
> 
> Either the new mapper code has some bug, or it's a big problem.
> But I think it's more possible for former case.
> 
> Would you please try to dump the chunk tree (which should be quite
> small) using the following command?
> 
> $ btrfs inspect-internal dump-tree -t chunk <device>

Sure, happy to provide that:
  https://static.lukas-pirl.de/dump-chunk-tree.txt
(too large for Pastebin, file will probably go away in a couple of weeks).

Cheers,

Lukas
