Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52678 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754619AbbDVQEf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 22 Apr 2015 12:04:35 -0400
Date: Wed, 22 Apr 2015 18:04:33 +0200
From: David Sterba <dsterba@suse.cz>
To: =?utf-8?B?546L5pet?= <xuw2015@gmail.com>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: fix btrfs quota rescan failed on PPC64 arch
Message-ID: <20150422160433.GC4996@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1429507996-28224-1-git-send-email-xuw2015@gmail.com>
 <5535119E.3050005@redhat.com>
 <CAPBX1x+0kHqhWeq91X3f1XV7RR5=GrOjs1c7t7k+P+nyyk2_XQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAPBX1x+0kHqhWeq91X3f1XV7RR5=GrOjs1c7t7k+P+nyyk2_XQ@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Apr 21, 2015 at 10:26:23AM +0800, 王旭 wrote:
> > On 4/20/15 12:33 AM, xuw2015@gmail.com wrote:
> >> From: George Wang <xuw2015@gmail.com>
> <snip>
> >> This means the value "_IOW*" will be negative when we store it in the int
> >> variables. Such as the "BTRFS_IOC_QGROUP_CREATE", it will be "0x4010942e" on
> >> X86_64, but "0x8010942e" on PPC64.
> >> Notice that the IOC values are the "unsigned long" type, so we use the
> >> "unsigned long" to store it, and this can insure the comparison between the
> >> variable and BTRFS_IOC_* valid.
> >
> > Looks good - very strange that the manpage states that the interface takes
> > an int.  :(
> 
> I think maybe the manpage of ioctl is stale. But int can also work
> except for comparison.
> And fortunately the kernel interface is unsigned int, such as btrfs:
> 
> 5217 long btrfs_ioctl(struct file *file, unsigned int
> 5218         cmd, unsigned long arg)
> 
> >
> > But - an "unsigned int" would be enough, right?  I don't think it needs
> > to be an unsigned long.  *shrug*
> 
> unsigned int will be OK. But the btrfs-progs is user space, so the
> ioctl I think it should be
> consistent with the glibc:
> /usr/include/sys/ioctl.h:extern int ioctl (int __fd, unsigned long int
> __request, ...) __THROW;
> unsigned long int is same with unsigned long. So maybe the unsigned
> long will be better?

I think we should stick to the glibc interface as it's the closest one,
although kernel uses usigned int in the end. Thanks.
