From: Chris Ball <cjb@laptop.org>
Subject: Re: Kernel oops with 2.6.31 in btrfs_set_acl
Date: Fri, 18 Sep 2009 16:50:11 -0400
Message-ID: <m3ws3wasfw.fsf@pullcord.laptop.org>
References: <20090918144353.GA9761@eskimo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Elladan <elladan@eskimo.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20090918144353.GA9761@eskimo.com> (elladan@eskimo.com's message
	of "Fri, 18 Sep 2009 07:43:53 -0700")
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

   > Hi, I got an oops this morning with btrfs on the Ubuntu 2.6.31
   > kernel.  I mounted with compress and thread_pool=4.  This is on a
   > 64 bit quad AMD machine.
   > 
   > [614439.132228] [<ffffffffa0f3c157>] ? btrfs_set_acl+0x87/0x230

Could you tell us what line of the source code that is?  This should
work, after gdb btrfs.ko:

(gdb) list *btrfs_set_acl+0x87

- Chris.
-- 
Chris Ball   <cjb@laptop.org>
One Laptop Per Child
