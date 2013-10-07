Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44808 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205Ab3JGCkj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 6 Oct 2013 22:40:39 -0400
Message-ID: <525220DC.2030403@oracle.com>
Date: Mon, 07 Oct 2013 10:47:56 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Wang Shilong <wangshilong1991@gmail.com>
CC: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs-progs: calculate disk space that a subvol could
 free
References: <1380300329-9123-1-git-send-email-anand.jain@oracle.com> <1380468336-5170-1-git-send-email-anand.jain@oracle.com> <20131001133919.GE18291@twin.jikos.cz> <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com>
In-Reply-To: <C56AFBE2-55D0-4E05-9903-5DD61E3C3D1A@gmail.com>
Content-Type: text/plain; charset=GB2312
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>




> If we want to speed up this progress, i think we can split it into two parts:
> 
> 1. First to search inline extent_data
> 2. Secondly search in extent tree to calculate (extent refs=1)
> 
> This will avoid n*n rather than n+n which is better¡­

  (sorry for delay in reply, I was on vacation).

  Thanks for what might help. I was kind of expecting
  this when preliminary patch was sent before. Let me
  try what you suggest and send out v3.

  I was also thinking if this should be inside kernel
  facilitated by a new ioctl? so that we avoid number
  of search ioctl thats required.

Thanks, Anand

