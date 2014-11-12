Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:8458 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752872AbaKLSCa (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 13:02:30 -0500
Date: Wed, 12 Nov 2014 12:59:33 -0500
From: Chris Mason <clm@fb.com>
Subject: Re: [PATCH] btrfs: Don't check for file->private_data on open(). It
 is set by the core.
To: Martin Kepplinger <martink@posteo.de>
CC: <linux-btrfs@vger.kernel.org>, <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, Martin Kepplinger <martink@posteo.de>
Message-ID: <1415815173.25389.2@mail.thefacebook.com>
In-Reply-To: <1415810308-24243-1-git-send-email-martink@posteo.de>
References: <1415810308-24243-1-git-send-email-martink@posteo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 12, 2014 at 11:38 AM, Martin Kepplinger <martink@posteo.de> 
wrote:
> The miscdevice core now sets file->private_data to the struct 
> miscdevice
> so don't fail when this is not NULL.
> 
> Signed-off-by: Martin Kepplinger <martink@posteo.de>
> ---
> This is a question: what does this check provide and does overwriting
> file->private_data make any difference?
> 
> Is miscdevice's open() by the user not allowed here, if 
> file->private_data
> is set?
> 
> thanks!!

Btrfs uses this in the transaction start ioctl to record the 
transaction handle being started.  Ceph is the main user of the ioctl, 
and we could setup a hash table if needed.  But which call path in 
miscdevice is doing this?

With your patch in place, btrfs would end up overwriting the miscdevice 
private_data field, which would probably cause problems.

-chris

