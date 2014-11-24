Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:33273 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754112AbaKXUHw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Nov 2014 15:07:52 -0500
Date: Mon, 24 Nov 2014 15:07:45 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [RFC PATCH] Btrfs: add sha256 checksum option
To: Liu Bo <bo.li.liu@oracle.com>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <1416859665.3019.6@mail.thefacebook.com>
In-Reply-To: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
References: <1416806586-18050-1-git-send-email-bo.li.liu@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 24, 2014 at 12:23 AM, Liu Bo <bo.li.liu@oracle.com> wrote:
> This brings a strong-but-slow checksum algorithm, sha256.
> 
> Actually btrfs used sha256 at the early time, but then moved to 
> crc32c for
> performance purposes.
> 
> As crc32c is sort of weak due to its hash collision issue, we need a 
> stronger
> algorithm as an alternative.
> 
> Users can choose sha256 from mkfs.btrfs via
> 
> $ mkfs.btrfs -C 256 /device

Agree with others about -C 256...-C sha256 is only three letters more ;)

What's the target for this mode?  Are we trying to find evil people 
scribbling on the drive, or are we trying to find bad hardware?

-chris

