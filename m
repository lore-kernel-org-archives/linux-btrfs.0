Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:51561 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932260Ab2KBTF4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 15:05:56 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TUMZ7-0007s9-RQ
	for linux-btrfs@vger.kernel.org; Fri, 02 Nov 2012 20:06:01 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 20:06:01 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Fri, 02 Nov 2012 20:06:01 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri, 2 Nov 2012 19:05:37 +0000 (UTC)
Message-ID: <k715i0$7go$1@ger.gmane.org>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
	<201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Nov 2012 13:02:32 +0100, Goffredo Baroncelli wrote:
> On 2012-11-02 12:18, Martin Steigerwald wrote:
>> Metadata, DUP is displayed as 3,50GB on the device level and as 1,75GB
>> in total. I understand the logic behind this, but this could be a bit
>> confusing.
>> 
>> But it makes sense: Showing real allocation on device level makes
>> sense,
>> cause thats what really allocated on disk. Total makes some sense,
>> cause thats what is being used from the tree by BTRFS.
> 
> Yes, me too. At the first I was confused when you noticed this
> discrepancy. So I have to admit that it is not so obvious to understand.
> However we didn't find any way to make it more clear...
> 
>> It still looks confusing at first…
> We could use "Chunk(s) capacity" instead of total/size ? I would like an
> opinion from a "english people" point of view..

This is easy to fix, here's a mockup:

Metadata,DUP: Size: 1.75GB ×2, Used: 627.84MB ×2
   /dev/dm-0        3.50GB

           Data   Metadata Metadata    System System              
           Single Single   DUP         Single DUP         Unallocated
                                                               
/dev/dm-16 1.31TB   8.00MB  56.00GB    4.00MB  16.00MB           0.00
           ====== ======== =========== ====== =========== ===========
Total      1.31TB   8.00MB  28.00GB ×2 4.00MB   8.00MB ×2        0.00
Used       1.31TB     0.00   5.65GB ×2   0.00 152.00KB ×2            

Also, I don't know if you could use libblkid, but it finds more 
descriptive names than dm-NN (thanks to some smart sorting logic).


