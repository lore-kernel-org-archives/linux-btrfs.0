Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31851 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752807Ab3GAQKO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 1 Jul 2013 12:10:14 -0400
Date: Mon, 1 Jul 2013 09:10:02 -0700
From: Zach Brown <zab@redhat.com>
To: Josef Bacik <jbacik@fusionio.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 0/6] fix INT_MAX readdir hang, plus cleanups
Message-ID: <20130701161002.GO10265@lenny.home.zabbo.net>
References: <1370384280-28652-1-git-send-email-zab@redhat.com>
 <20130701125435.GE4288@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20130701125435.GE4288@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> > code.  It's all lightly tested with xfstests but it wouldn't surprise
> > me if I missed something so review is appreciated.

*mmm, hmmm*

> One of these patches is making new entries not show up in readdir.  This was
> discovered while running stress.sh overnight, it complained about files not
> matching but when they were checked the files matched.  Dropping the entire
> series made stress.sh run fine.  So I'm dropping these for the next merge window
> but I'll dig into it and try and figure out what was causing the problem.

Nerts.  It's got to be the delayed inode stuff.

Maybe it's some unlink/recreate pattern?  Is this a thing that stress.sh
does?  (Where's stress.sh live?)

- z 
