Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:40110 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751321AbdACQmC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 11:42:02 -0500
Date: Tue, 3 Jan 2017 17:41:45 +0100
From: David Sterba <dsterba@suse.cz>
To: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: utils: negative numbers are more
 plausible than sizes over 8 EiB
Message-ID: <20170103164145.GS12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1480797594-2337-1-git-send-email-ce3g8jdj@umail.furryterror.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1480797594-2337-1-git-send-email-ce3g8jdj@umail.furryterror.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Dec 03, 2016 at 03:39:54PM -0500, Zygo Blaxell wrote:
> I got tired of seeing "16.00EiB" whenever btrfs-progs encounters a
> negative size value, e.g. during resize:
> 
> Unallocated:
>    /dev/mapper/datamd18   16.00EiB
> 
> This version is much more useful:
> 
> Unallocated:
>    /dev/mapper/datamd18  -26.29GiB
> 
> Signed-off-by: Zygo Blaxell <ce3g8jdj@umail.furryterror.org>

>From some perspective, negative numbers are better than the insane EiB
sizes. I've started to fix it properly, ie account for the size of the
device under deletion. Turns out this needs to retrieve information from
the protected search ioctl, so in some cases we wouldn't be able to
calculate the numbers exactly anyway. This similar to calculating the
space stats in case of raid5/6.

So I'm going to merge this patch, tough I'd not modify the the function
prototype but rather add a new unit mode so the caller can actually say
how the 64bit numbers should be printed.
