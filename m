From: Chris Mason <chris.mason@oracle.com>
Subject: Re: btrfsck segmentation fault + trace
Date: Wed, 16 Jun 2010 13:29:00 -0400
Message-ID: <20100616172900.GA27466@think>
References: <4C18F348.80509@gmx.de>
 <20100616163109.GX27466@think>
 <4C18FD4D.4070100@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: John Wyzer <john.wyzer@gmx.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4C18FD4D.4070100@gmx.de>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 16, 2010 at 06:35:25PM +0200, John Wyzer wrote:
> On 16/06/10 18:31, Chris Mason wrote:
> > On Wed, Jun 16, 2010 at 05:52:40PM +0200, John Wyzer wrote:
> >> I tried 2.6.35-rc3 and got error messages during the boot process about not being able
> >> to dirty inodes and no space left on device.
> > 
> > Is 2.6.34 working normally?
> 
> 
> Yes. I can boot with 2.6.34.y and everything works fine. (Actually,
> before trying 2.6.45-rc3, I had an uptime of two weeks on this laptop.
> Now, I'm writing this email on 2.6.34.y.)

But every time you boot 2.6.35 you get errors?  Would it be possible to
save the console output (netconsole works well)

-chris

