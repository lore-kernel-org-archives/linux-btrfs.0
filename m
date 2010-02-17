From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Kernel BUG on mounting BtrFS / after reboot
Date: Wed, 17 Feb 2010 09:18:13 -0500
Message-ID: <20100217141813.GH29430@think>
References: <loom.20100212T220341-877@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Alex Elsayed <eternaleye@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <loom.20100212T220341-877@post.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Feb 12, 2010 at 09:04:39PM +0000, Alex Elsayed wrote:
> I'm getting a rather nasty BUG when I try to mount this filesystem, 
> _including_ when I specify -o ro. I'm unsure what caused it, but the problem 
> manifested after my computer hardlocked while reading my RSS feeds, complete 
> with flashing lights. After I rebooted it, the screen filled with panic 
> messages when the initramfs tried to mount it RO to pivot into. I am running 
> 2.6.33-rc6. The BUG message is as follows:

The good news is this looks like a bug that Yan Zheng fixed.  2.6.33-rc7
or later should mount without problems.  If you're having trouble
getting that image onto that box, I'll get a usb boot image up with it
running for you.

-chris
