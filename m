From: Arne Jansen <sensille@gmx.net>
Subject: Re: 3.2-rc4: scrubbing locks up the kernel, then hung tasks on boot
Date: Tue, 24 Jan 2012 10:28:11 +0100
Message-ID: <4F1E79AB.10206@gmx.net>
References: <201112171833.34720.Martin@lichtvoll.de> <201112202146.32265.Martin@lichtvoll.de> (sfid-20111220_235230_709484_89771306) <201201211149.53403.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Martin Steigerwald <Martin@lichtvoll.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201201211149.53403.Martin@lichtvoll.de>
List-ID: <linux-btrfs.vger.kernel.org>

On 21.01.2012 11:49, Martin Steigerwald wrote:
> Am Dienstag, 20. Dezember 2011 schrieb Martin Steigerwald:
> 
> When I do btrfs scrub start / the machine locks immediately up hard.

Can you please give me the output of sysrq-w when the machine is locked up?

Thanks,
Arne

> 
> Then usually on next boot it stops on space_cache enabled message, but not 
> the one for /, but the one for /home which is mounted later.
> 
> When I then boot with 3.1 it works. BTRFS redos the space_cache then while 
> the machine takes ages to boot - I mean ages - 10 minutes till KDM prompt 
> is no problem there.
> 
> I thought I just mention it here.
> 
> Since I got no hints on what to do, I probably redo both filesystems on the 
> machine. Should that not work out, I switch the box to Ext4.
> 
> btrfs filesystem scrub works on my ThinkPad T520 with 64-bit debian and 
> Intel SSD 320 and one 2,5 inch external drive as well as a 3,5 inch 
> external backup drive both via eSATA, so this seems to be no principal 
> issue. It also works on a workstation at work which has 32-bit debian as 
> well.
> 
> Thanks,

