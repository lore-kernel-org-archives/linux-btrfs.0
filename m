From: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Subject: Re: [patch 2/2] grub-0.97: btrfs multidevice configuration support
Date: Fri, 11 Dec 2009 00:21:21 +0100
Message-ID: <200912110021.22004.johannes.hirte@fem.tu-ilmenau.de>
References: <4ABBED70.30106@redhat.com> <200911022316.39102.johannes.hirte@fem.tu-ilmenau.de> <4AEF807B.6050303@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Edward Shishkin <edward@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4AEF807B.6050303@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am Dienstag 03 November 2009 01:59:39 schrieb Edward Shishkin:
> Johannes Hirte wrote:
> >  Why is the btrfs code
> > dealing with network devices at all?
> 
> Why not? :)

I don't see the possiblity to get a btrfs filesystem this way. So as far as I 
understand this, it's complete useless. The CD support doesn't look very 
usefull too to me. It's possible to put a btrfs filesystem on a CD or DVD. But 
that seems rather theoretical.

regards,
  Johannes

