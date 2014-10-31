Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52242 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756286AbaJaJIg (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 31 Oct 2014 05:08:36 -0400
Date: Fri, 31 Oct 2014 10:08:30 +0100
From: Karel Zak <kzak@redhat.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH 2/2 v4] btrfs-progs: optimize btrfs_scan_lblkid() for
 multiple calls
Message-ID: <20141031090830.GP10134@x2.net.home>
References: <1413334270-25766-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-1-git-send-email-anand.jain@oracle.com>
 <1414728680-25468-2-git-send-email-anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1414728680-25468-2-git-send-email-anand.jain@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 31, 2014 at 12:11:20PM +0800, Anand Jain wrote:
> btrfs_scan_lblikd() is called by most the device related command functions.
> And btrfs_scan_lblkid() is most expensive function and it becomes more expensive
> as number of devices in the system increase. Further some threads call this

wouldn't be possible to ask udev rather than scan all devices? I
understand than in some cases it's necessary to have robust and
independent solution, but for usual use-cases it would be less
expensive to read the info from udev where we already keep track about
all block devices and where we call libblkid. 

It would be possible to implement it as optional feature (#ifdev HAVE_LIBUDEV),
the library API is very easy to use.

(For example lsblk uses libblkid as fallback, the default is udev).

    Karel


-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
