From: Josef Bacik <jbacik@redhat.com>
Subject: Re: [DEBUG PATCH] for anybody who gets a panic due to ENOSPC
Date: Wed, 19 Nov 2008 12:12:43 -0500
Message-ID: <20081119171243.GB16041@unused.rdu.redhat.com>
References: <4922214A.5090904@cs.drexel.edu> <20081118163007.GA1425@unused.rdu.redhat.com> <20081119164535.GA22904@tux64-01>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <jbacik@redhat.com>, linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081119164535.GA22904@tux64-01>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Nov 19, 2008 at 11:45:35AM -0500, Lee Trager wrote:
> Sorry it took so long to reply it took awhile to run this test. It
> didn't cause a kernel panic for about 8 hours. df says only 623M of the
> available 7539M are used. Anyway this is with the latest checkin by Chris Mason with the patch you sent me.
> 
> Also since you said you cann't reproduce this I thought it might be
> helpful to know the environment I'm doing testing on. I have been
> running bonnie++ on xubuntu 8.10 fully updated on vmware 6.5. No vmware
> tools are instead except for the mouse and video xorg drivers which come by
> default with ubuntu. I have two 8G prealloced virtual drives. The first
> one is where the xubuntu install is using ext2 for /boot and / and has a
> 512M swap partition. The second one is where I do all of the btrfs testing. 
> I have it partitioned because I was experimenting with booting with btrfs 
> as root so the partition btrfs is on has 7539M. The VM has 512M of RAM
> dedicated to it and is using one core of my Intel Core 2 Duo T7500
> running at 2.2GHz.
> 
> Lee

Ok this is almost everything I need, I just need a few more lines of the debug
output, so all of this plus lets say the last 100 lines, that should be
everything I need.  Or if you have full logs that you can post somewhere that
would be great and I can filter through them myself.  Thanks much for testing
this stuff for me,

Josef

