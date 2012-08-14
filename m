Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from licorne.daevel.fr ([178.32.94.222]:36172 "EHLO
	licorne.daevel.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab2HNNwI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 14 Aug 2012 09:52:08 -0400
Message-ID: <502A5804.7080003@daevel.fr>
Date: Tue, 14 Aug 2012 15:52:04 +0200
From: Olivier Bonvalet <btrfs.list@daevel.fr>
MIME-Version: 1.0
To: Daniel Pocock <daniel@pocock.com.au>
CC: linux-btrfs@vger.kernel.org
Subject: Re: raw partition or LV for btrfs?
References: <5027DDFC.60504@pocock.com.au> <CAG1y0scy=6NByQ9DBF_9m6MrmNrYe1WvX9-JkmbEUKWjd77w8Q@mail.gmail.com> <502A529B.8060201@pocock.com.au>
In-Reply-To: <502A529B.8060201@pocock.com.au>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14/08/2012 15:28, Daniel Pocock wrote:
> If I create 10 LVs today, with btrfs on each,


 From my understanding of Btrfs, it achieve good write performance by 
making near all writes "sequential". But if you split your disk in 10 
sub-parts, and set btrfs on each of them, writes operations of Btrfs 
will not really be sequential anymore.

So, for me, to have good performance btrfs should manage all the disk
(maybe excepting the /boot/ directory, just to avoid any problem with grub).
