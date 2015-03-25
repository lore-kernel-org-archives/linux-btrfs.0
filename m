Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:34455 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbbCYTC6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 25 Mar 2015 15:02:58 -0400
Received: by wibg7 with SMTP id g7so140235wib.1
        for <linux-btrfs@vger.kernel.org>; Wed, 25 Mar 2015 12:02:57 -0700 (PDT)
Message-ID: <5513077A.4000004@gmail.com>
Date: Wed, 25 Mar 2015 20:07:38 +0100
From: Goffredo Baroncelli <kreijack@gmail.com>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH V2][BTRFS-PROGS] Improve output of mkfs.btrfs command
References: <1418847252-14184-1-git-send-email-kreijack@inwind.it> <20150323234623.GQ20767@twin.jikos.cz>
In-Reply-To: <20150323234623.GQ20767@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-03-24 00:46, David Sterba wrote:
> FYI, I've added the following patches to 3.19 queue
> 
>  * btrfs-progs: return the fsid from make_btrfs()
>  * btrfs-progs: add strdup in btrfs_add_to_fsid() to track the device path
>  * btrfs-progs: add verbose option to btrfs_add_to_fsid()
>  * btrfs-progs: add -v and -q switches in the mkfs.btrfs man page
>  * btrfs-progs: add -v -q switches to mkfs.btrfs
> 
> ie. the patch that adds the the summary is not there yet but I'm planning to
> add it as well with some modifications. If that turns out to be too different
> from your proposal, I'm going to send it for comments.
> 
Ok, many thanks
Goffredo

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
