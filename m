From: Josef Bacik <jbacik@redhat.com>
Subject: Re: Kernel oops when running bonnie++ on btrfs
Date: Thu, 13 Nov 2008 14:20:05 -0500
Message-ID: <20081113192005.GA17006@unused.rdu.redhat.com>
References: <20081113184907.GA16224@tux64-02>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Lee Trager <lt73@cs.drexel.edu>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20081113184907.GA16224@tux64-02>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 13, 2008 at 01:49:07PM -0500, Lee Trager wrote:
> I wanted to see how btrfs compares to other filesystems so I have been
> running bonnie++ on it. While the results are good(much faster then
> ext2) every once in awhile I get a kernel oops. I am testing on xubuntu
> 8.10 with the 2.6.27-7-686 kernel using the latest git sources. Most of the
> time the oops happens within 20min of running bonnie++ but sometimes it
> takes a few hours. This happens with and without compression.
> 
> To reproduce this bug you can run
> 
> while true; do bonnie++ -s 5120 -n 4:524288:0:512; done
>

Thanks, still tracking down random places where we ENOSPC too soon.  Have you
updated today?  There was a fix that went in earlier today that may help you.  I
wll run with your command and see if I can replicate here and fix it.

Josef
 
