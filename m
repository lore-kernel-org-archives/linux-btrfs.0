Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f178.google.com ([209.85.192.178]:64899 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753527Ab3JIOSG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Oct 2013 10:18:06 -0400
Received: by mail-pd0-f178.google.com with SMTP id w10so998652pde.9
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Oct 2013 07:18:05 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could free
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20131008164951.GC12986@twin.jikos.cz>
Date: Wed, 9 Oct 2013 22:17:49 +0800
Cc: "linux-btrfs@vger.kernel.org FILE SYSTEM list:BTRFS"
	<linux-btrfs@vger.kernel.org>
Message-Id: <237D022A-BBC2-412C-9E41-45EB4B299660@gmail.com>
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com> <525220DC.2030403@oracle.com> <20131008164951.GC12986@twin.jikos.cz>
To: "dsterba@suse.cz Sterba" <dsterba@suse.cz>,
        Anand Jain <anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hello David, Anand,

> On Mon, Oct 07, 2013 at 10:47:56AM +0800, Anand Jain wrote:
>>  I was also thinking if this should be inside kernel
>>  facilitated by a new ioctl? so that we avoid number
>>  of search ioctl thats required.
> 
> I think so. And for the feature itself, it can be handy in case where
> qgroups are not established.

Actually, i have not found an effectively way to work out this.

Whatever we implement this as an ioctl in kernel space or just in userspace,
why not just trigger quota enabled, but not set qgroup limit.

If quota been enabled, quota rescan will calculate every subvolume's
referenced and exclusive size(to implement this we have to iterate extent tree though).

Luckily, after that, quota itself will track every subvolume's sole size(exclusive size).

Justing using 'btrfs qgroup show', we can figure out every subvolume's  referenced size
and exclusive size easily, i think this is another important use of qgroup.

If users want to find top subvolume's sole size, they can use:

btrfs qgroup show  <mnt>  --sort=+/-excl

This approach maybe a little tricky,  but it is better than implement an ioctl to calculate
one subvolume's size every time.


Thanks,
Wang
> 
> david

