Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx02.posteo.de ([89.146.194.165]:40507 "EHLO mx02.posteo.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753100AbaKLSgq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 12 Nov 2014 13:36:46 -0500
Message-ID: <5463A84A.8010606@posteo.de>
Date: Wed, 12 Nov 2014 19:34:50 +0100
From: Martin Kepplinger <martink@posteo.de>
MIME-Version: 1.0
To: Chris Mason <clm@fb.com>
CC: linux-btrfs@vger.kernel.org, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Don't check for file->private_data on open().
 It is set by the core.
References: <1415810308-24243-1-git-send-email-martink@posteo.de> <1415815173.25389.2@mail.thefacebook.com>
In-Reply-To: <1415815173.25389.2@mail.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 2014-11-12 um 18:59 schrieb Chris Mason:
> On Wed, Nov 12, 2014 at 11:38 AM, Martin Kepplinger <martink@posteo.de>
> wrote:
>> The miscdevice core now sets file->private_data to the struct miscdevice
>> so don't fail when this is not NULL.
>>
>> Signed-off-by: Martin Kepplinger <martink@posteo.de>
>> ---
>> This is a question: what does this check provide and does overwriting
>> file->private_data make any difference?
>>
>> Is miscdevice's open() by the user not allowed here, if
>> file->private_data
>> is set?
>>
>> thanks!!
> 
> Btrfs uses this in the transaction start ioctl to record the transaction
> handle being started.  Ceph is the main user of the ioctl, and we could
> setup a hash table if needed.  But which call path in miscdevice is
> doing this?
> 
> With your patch in place, btrfs would end up overwriting the miscdevice
> private_data field, which would probably cause problems.
> 
> -chris
> 

I think i was mistaken, sorry. misc_open() used to set
file->private_data _only_ if you use set .open in struct file_operations.

In current -next this changed and file->private_data is set to struct
miscdevice on a (userspace's) open call (misc_open()) just in any case.

You do set .open so this wouldn't affect you and this patch can be ignored.

                        martin
