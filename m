Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from resqmta-po-01v.sys.comcast.net ([96.114.154.160]:34152 "EHLO
	resqmta-po-01v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751914AbaLASTV (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Dec 2014 13:19:21 -0500
Message-ID: <547CB121.9030807@pobox.com>
Date: Mon, 01 Dec 2014 10:19:13 -0800
From: Robert White <rwhite@pobox.com>
MIME-Version: 1.0
To: Gour <gour@atmarama.net>, linux-btrfs@vger.kernel.org
Subject: Re: pro/cons of raid1 with mdadm/lvm2
References: <20141130121147.45884217@atmarama>	<E4D50A09-CBA8-47DB-833B-D80D7BD6BD92@coker.com.au> <20141201102624.1224bc54@atmarama>
In-Reply-To: <20141201102624.1224bc54@atmarama>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/01/2014 01:26 AM, Gour wrote:
> On Mon, 01 Dec 2014 09:06:19 +1100
> Russell Coker <russell@coker.com.au> wrote:
>
>> When the 2 disks have different data mdadm has no way of knowing
>> which one is correct and has a 50% chance of overwriting good data.
>> But BTRFS does checksums on all reads and solves the problem of
>> corrupt data - as long as you don't have 2 corrupt sectors in
>> matching blocks.
>
> Hmm, this is very interesting and valuable info. Thank you.
>

Don't get too excited. If the data disagrees in either system because of 
partial starts (e.g. one mount /dev/sda1 is hot, the next mount 
/dev/sdb1 is hot) leaving both disks with equally valid but disagreeing 
data, "magical guessing" _will_ ensue.

In the BTRFS case the system will guess based on generation numbers.

In the MDADM case the system will guess based on the write intent bitmaps.

In both cases, you are _way_ better off invalidating any missing array 
elements if you find yourself reaching a write-available event with said 
missing elements.

BTRFS checksums really help when a write goes to both devices (e.g. 
/dev/sda1 and /dev/sdb1) and the disk subsystem silently fails one of 
the necessary writes, creating a disagreement between the checksum and 
the data block on the drive in question.

It's an outstanding feature, but it doesn't protect you from weak 
maintenance after a partial start.
