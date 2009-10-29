From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Thu, 29 Oct 2009 21:53:01 +0100
Message-ID: <200910292153.01171.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED68.6090801@redhat.com> <200910282230.25307.johannes.hirte@fem.tu-ilmenau.de> <4AE8CD70.2060703@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward.shishkin@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AE8CD70.2060703@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Donnerstag 29 Oktober 2009 00:02:08 schrieb Edward Shishkin:
> Johannes Hirte wrote:
> [...]
> > This compiles and works, but only with stage2. When using stage1_5, grub hangs
> > on boot with
> >
> > GRUB loading stage1.5 
> >
> > and blinking cursor. Is the multidevice patch also necessary for single 
> > devices?
> 
> Yes, please use both patches!
> I have split the stuff because the mailing list refuse attachments >100K.
> 
> Thanks,
> Edward.

With both patches applied it works now with stage1_5. Thank you. The patch for
gentoo is available on http://bugs.gentoo.org/show_bug.cgi?id=283637, if
somebody is interested.

Johannes
