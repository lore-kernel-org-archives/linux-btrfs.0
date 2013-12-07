Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f45.google.com ([209.85.214.45]:43467 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786Ab3LGOst convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Dec 2013 09:48:49 -0500
Received: by mail-bk0-f45.google.com with SMTP id mx13so731921bkb.18
        for <linux-btrfs@vger.kernel.org>; Sat, 07 Dec 2013 06:48:48 -0800 (PST)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: bo.li.liu@oracle.com
Cc: linux-btrfs@vger.kernel.org
Subject: Re: btrfs-ino-cache runs on every boot for 6 minutes
Date: Sat, 07 Dec 2013 15:48:23 +0100
Message-ID: <2569324.x9XeZ2FMSO@linux-suse.hu>
In-Reply-To: <20131206133033.GC20595@localhost.localdomain>
References: <1531404.tFNCiHaLVH@linux-suse.hu> <14005207.4jWyJLzXAX@linux-suse.hu> <20131206133033.GC20595@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Liu Bo a következőt írta ekkor: 2013. december 6. 21:30:34
> It seems that we should owe credit to the updated 3.13 kernel, could you
> please try again 3.13 kernel without the patch?
> 
> thanks,
> -liubo

I forcibly reinstalled the 3.13 kernel from the repository, booted from it 
twice and yes, it really seems that this bug is fixed now.

Thank you for your time.

Ákos
