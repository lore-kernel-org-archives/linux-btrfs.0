From: CACook@quantum-sci.com
Subject: Re: Cannot Deinstall a Debian Package
Date: Tue, 3 May 2011 17:12:42 -0700
Message-ID: <201105031712.43222.CACook@quantum-sci.com>
References: <201105031227.43619.CACook@quantum-sci.com> <201105031520.49993.CACook@quantum-sci.com> <201105031802.43215.chuck@thesouthernlibertarian.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: Btrfs mailing list <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201105031802.43215.chuck@thesouthernlibertarian.com>
List-ID: <linux-btrfs.vger.kernel.org>


I know what the error says;  we've established that / is in fact mounted.  The system boots and runs, but grub doesn't understand it.  My only answer is that grub-probe does not understand BTRFS.

The question is what to do about this.  I have three major systems committed to this filesystem.  Can you not see how this is an emergency?

How is re-reading the error supposed to help anything?  Or was your intention to help?


On Tuesday 3 May, 2011 16:02:43 Chuck Burns wrote:
> On Tuesday, May 03, 2011 05:20:49 PM CACook@quantum-sci.com wrote:
> <-snip-> 
> > I would be happy to upgrade grub, but the package management system is
> > jammed because of this.
> <-snip->
> 
> You should Re-read the error you posted.  The package management system goes bonkers, because
> 
> > /usr/sbin/grub-probe: error: cannot find a device for / (is /dev mounted?).
> > run-parts: /etc/kernel/postrm.d/zz-update-grub exited with return code 1
> 
> 
