From: Chris Samuel <chris@csamuel.org>
Subject: Re: Cannot Deinstall a Debian Package
Date: Wed, 04 May 2011 11:20:37 +1000
Message-ID: <4DC0A9E5.1000007@csamuel.org>
References: <201105031227.43619.CACook@quantum-sci.com> <BANLkTinPUPM6+iNUvYfx0_C-Wt32eb_1jQ@mail.gmail.com> <201105031520.49993.CACook@quantum-sci.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031520.49993.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/05/11 08:20, CACook@quantum-sci.com wrote:

> My whole system is installed over BTRFS.  If this is
> non-functional in any OS there should be a warning
> indicating it is non-functional.

The text for btrfs in the kernel configuration says:

 Btrfs is highly experimental, and THE DISK FORMAT IS NOT YET
 FINALIZED.  You should say N here unless you are interested in
 testing Btrfs with non-critical data.

The distros may well enable it for such people but you also
have a duty of care to ensure that you understand the filesystems
that you are choosing to use.  Nevertheless this is not a bug
in btrfs at all.

You need to report the bug in grub-probe (part of the grub-common
package I believe) to Debian. There was a similar bug reported here:

 http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=540786

But that should have been fixed in 1.98+20100602-1 and the
current version in Squeeze is 1.98+20100804-14.

Best of luck,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
