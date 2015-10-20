Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-33.italiaonline.it ([212.48.25.161]:38711 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753398AbbJTUhZ (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 20 Oct 2015 16:37:25 -0400
Reply-To: kreijack@inwind.it
Subject: Re: How to remove missing device on RAID1?
References: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
        Wang Shilong <wangsl.fnst@cn.fujitsu.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
To: Kyle Manna <2bluesc@gmail.com>
Message-ID: <5626A602.1030106@inwind.it>
Date: Tue, 20 Oct 2015 22:37:22 +0200
MIME-Version: 1.0
In-Reply-To: <CAM9fjH6M2yqSiqXbT4DBvHbQGq9Cdw-wzMvsYkztPSsQG=PLqQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-10-20 19:24, Kyle Manna wrote:
> Hi all,
[...]
> How do I remove the missing device?  I tried the `btrfs device delete
> missing /mnt` but was greeted with "ERROR: missing is not a block
> device".  A quick look at that btrfs-progs git repo shows that
> `stat("missing")` is called, which of course fails since missing isn't
> a block device.  Nothing other then `btrfs replace` seemed intuitive
> and all the docs mention the older command.  What's the move?

In the past the device name was passed directly to the kernel, which operated in an appropriate manner if it was "missing".

The commit e3c9596d3fc8b0df647a6cbae55c2d77570de759 introduced a check so if the argument is not a real device, an error is raised.

So, now, if "missing" is passed, btrfs(-progs) stops because it is not a real device.

This change is quite old (dec 2013); however it seems that this is the first time that a complaint is raised.


> 
> Thanks!
> - Kyle
> 
> Versions:
> Kernel: 4.2.3-1-ARCH
> btrfs-progs: 4.2.2-1
> ᐧ
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
