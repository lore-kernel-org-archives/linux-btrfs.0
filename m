Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i6.italiaonline.it ([212.48.14.166]:43360 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751149AbdHQPhD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 17 Aug 2017 11:37:03 -0400
Reply-To: kreijack@inwind.it
Subject: Re: btrfs fi du -s gives Inappropriate ioctl for device
To: Piotr Szymaniak <szarpaj@grubelek.pl>, linux-btrfs@vger.kernel.org
References: <20170814225740.GK19638@pontus.sran>
From: Goffredo Baroncelli <kreijack@libero.it>
Message-ID: <ac3d9310-9b88-dc18-56bf-3e02b15686df@libero.it>
Date: Thu, 17 Aug 2017 17:37:00 +0200
MIME-Version: 1.0
In-Reply-To: <20170814225740.GK19638@pontus.sran>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On 08/15/2017 12:57 AM, Piotr Szymaniak wrote:
> and... some issues:
> ~ # btrfs fi du -s /mnt/red/\@backup/
>      Total   Exclusive  Set shared  Filename
> ERROR: cannot check space of '/mnt/red/@backup/': Inappropriate ioctl for device


could you share the output of 

strace btrfs fi du -s /mnt/red/\@backup/

this shouldn't  contain sensible information

BR
G.Baroncelli

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
