Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26255 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab3JOFOj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Oct 2013 01:14:39 -0400
Content-Type: text/plain; charset=US-ASCII
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Subject: Re: OK to take hourly snapshots, then cull older ones?
From: Avi Miller <avi.miller@oracle.com>
In-Reply-To: <525CCD11.3030203@mersenne.com>
Date: Tue, 15 Oct 2013 16:14:30 +1100
Cc: linux-btrfs@vger.kernel.org
Message-Id: <395822F6-3016-4ED1-9DF7-FC50241323A5@oracle.com>
References: <525CBF0D.1020609@mersenne.com> <20131015105306.6a74ec5c@natsu> <525CCD11.3030203@mersenne.com>
To: David Madden <dhm@mersenne.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On 15/10/2013, at 4:05 PM, David Madden <dhm@mersenne.com> wrote:

> I haven't looked at the wiki carefully enough to understand this, but
> could one reasonably back up the snapshots of one BTRFS filesystem to
> an independent BTRFS filesystem, in a more efficient way than just
> dump/restore or cpio or something?


Yes, it's called btrfs send/receive. Take a look at the incremental backup page for usage:

https://btrfs.wiki.kernel.org/index.php/Incremental_Backup

--
Oracle <http://www.oracle.com>
Avi Miller | Principal Program Manager | +61 (412) 229 687
Oracle Linux and Virtualization
417 St Kilda Road, Melbourne, Victoria 3004 Australia

