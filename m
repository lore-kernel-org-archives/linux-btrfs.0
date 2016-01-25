Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:33115 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757062AbcAYLeJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jan 2016 06:34:09 -0500
Subject: Re: btrfs-progs 4.4 re-balance of RAID6 is very slow / limited to one
 cpu core?
To: Henk Slager <eye1tm@gmail.com>, linux-btrfs <linux-btrfs@vger.kernel.org>
References: <56A230C3.3080100@netcologne.de>
 <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56A6082C.3030007@netcologne.de>
Date: Mon, 25 Jan 2016 12:34:04 +0100
MIME-Version: 1.0
In-Reply-To: <CAPmG0jZoVmnUjqaWoZgAGEXUREyMyXPxQ_+M282F640jTw5b_A@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey there Henk, btrfs-enthusiasts,


On 01/24/2016 03:30 AM, Henk Slager wrote:
> It might be that just a full balance runs faster, so no filters, you
> could try that. Otherwise I wouldn't know how to speedup, hopefully
> the fs is still usable while balancing.

Yes the FS is still usable, munin shows just a little increate in iops
and disk latency. The filter should not affect the performance of a
balance at all. I am simply saying to only consider chunks which are not
spread across all disks yet. Finding out a chunks data distribution
should not add any burden on the balancing.

The balancing is still VERY VERY slow, we still have 93% left to
balance. But since I did not hit any hardware limit (CPU or disk IO) I
am confident to say btrfs-balance is buggy in this regard. CPU single
thread performance will not explode anytime soon. But disks (or SSD)
will still grow in size and so will their potential iops.

With a 8 - 12 disk array growth I am not doing something crazy that has
never been done before on a storage array either ;-)



Regards

Christian
