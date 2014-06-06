Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751541AbaFFKDG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 6 Jun 2014 06:03:06 -0400
Date: Fri, 6 Jun 2014 12:03:02 +0200
From: Karel Zak <kzak@redhat.com>
To: Gui Hecheng <guihc.fnst@cn.fujitsu.com>
Cc: util-linux@vger.kernel.org, linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] mount: add btrfs to mount.8
Message-ID: <20140606100302.GB30975@x2.net.home>
References: <1401933919-23608-1-git-send-email-guihc.fnst@cn.fujitsu.com>
 <20140605080311.GW9000@x2.net.home>
 <1402036359.17740.33.camel@localhost.localdomain>
 <20140606094428.GA30975@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20140606094428.GA30975@x2.net.home>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Jun 06, 2014 at 11:44:28AM +0200, Karel Zak wrote:
>  I personally have no problem to maintain information about arbitrary
>  FS in mount.8, the problem are updates. Unfortunately, kernel FS developers
>  don't care about the man page at all and it's very often not up to date.

 Hmm.. another possible way would be to create a script for util-linux
 that will analyze kernel Documentation/filesystems/<fsname>.txt and
 report changes that is necessary to make to mount.8. It should be
 relative simple with git. I'll try it..

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
