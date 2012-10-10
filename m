Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.workshopit.co.uk ([93.191.37.100]:34523 "EHLO
	mx1.workshopit.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756649Ab2JJWL2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 18:11:28 -0400
Date: Wed, 10 Oct 2012 23:11:07 +0100
From: Rory Campbell-Lange <rory@campbell-lange.net>
To: Alex Lyakas <alex.btrfs@zadarastorage.com>
Cc: Arne Jansen <sensille@gmx.net>, linux-btrfs@vger.kernel.org
Subject: Re: btrfs receive to subdirectory
Message-ID: <20121010221107.GA19266@campbell-lange.net>
References: <20121008163010.GA22763@campbell-lange.net>
 <50733D66.5020600@gmx.net>
 <20121009111830.GC31743@campbell-lange.net>
 <CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAOcd+r2DwTz_F3VHLRiQ7+fafqLrSTvib=P38hHYqYCY-5gGkA@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/10/12, Alex Lyakas (alex.btrfs@zadarastorage.com) wrote:
> Hi Rory, Arne,
> I think the problem is that currently mnt_fd in struct btrfs_receive
> is used both as "mount root" and "directory in which the
> subvolume/snapshot needs to be created".
> Arne, does the following patch make sense? It uses Jan's
> find_mount_root function. With this patch both Rory's tests seem to
> work for me.

Hi Alex

I haven't had a chance to test this. I'm also on 89fe5b5f of progs
recommended to my by Chris for send/receive testing and your patch
doesn't apply for me. Are you using another revision?

Regards
Rory

-- 
Rory Campbell-Lange
rory@campbell-lange.net
