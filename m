From: Sander <sander@humilis.net>
Subject: Re: Cannot Deinstall a Debian Package
Date: Fri, 6 May 2011 16:58:47 +0200
Message-ID: <20110506145847.GA16132@attic.humilis.net>
References: <201105031227.43619.CACook@quantum-sci.com>
 <201105060656.12544.CACook@quantum-sci.com>
 <20110506141659.GA1804@attic.humilis.net>
 <201105060753.03469.CACook@quantum-sci.com>
Reply-To: sander@humilis.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105060753.03469.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

CACook@quantum-sci.com wrote (ao):
> On Friday 6 May, 2011 07:17:00 you wrote:
> > Hm. Just do cp /bin/true /usr/sbin/grub-probe
> 
> Yikes, it came up with an ncurses screen saying:
> 
> GRUB failed to install to the following devices:                                     ???   
>   ???                                                                                      ???   
>   ??? /dev/sda                                                                             ???   
>   ???                                                                                      ???   
>   ??? Do you want to continue anyway? If you do, your computer may not start up properly.  ???   
>   ???                                                                                      ???   
>   ??? Writing GRUB to boot device failed - continue?                                       ???   
>   ???                                                                                      ???   
>   ???                        <Yes>                           <No>                          ???   
                                                          
Say 'yes', try to finish your upgrade.

Then:
grub-install /dev/sda
update-grub

Do keep an Ubuntu cd in reach though, just in case your grub is screwed
anyway.

	Sander

-- 
Humilis IT Services and Solutions
http://www.humilis.net
