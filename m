From: Chris Mason <chris.mason@oracle.com>
Subject: Re: How to know whether disks "handle flush requests correctly"
Date: Fri, 06 May 2011 09:48:32 -0400
Message-ID: <1304688928-sup-8382@think>
References: <N1-HLiSwHA1HL@Safe-mail.net> <4DC3F33F.80309@redhat.com>
Content-Type: text/plain; charset=UTF-8
Cc: Paul Schroeder <prq@safe-mail.net>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-reply-to: <4DC3F33F.80309@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

Excerpts from Josef Bacik's message of 2011-05-06 09:10:23 -0400:
> On 05/06/2011 05:13 AM, Paul Schroeder wrote:
> > The btrfs wiki Main Page warns that "it is currently possible to corrupt
> > a filesystem irrecoverably if your machine crashes or loses power on disks
> > that don't handle flush requests correctly."
> >
> > How do you know if this applies to your drives? Is there a way to test it,
> > or a model list, or are newer SATA drives (magnetic, not SSDs) always ok?
> > Does it depend on the controller? (I have a SiI 3114, latest BIOS.)
> >
> > I would also be using btrfs on top of dm-crypt (with the latest release
> > kernel). Some kernel versions ago, the message that write barriers aren't
> > supported disappeared; can I assume the device mapper / dm-crypt is not a
> > problem with regards to flushing?
> >
> 
> Yeah if you don't see those messages you can be fairly certain you are 
> ok.  Thanks,

The easiest way to tell for sure is to do two tests:

dd if=/dev/zero of=/mnt/foo bs=4K count=10000
dd if=/dev/zero of=/mnt/foo bs=4K count=10000 oflag=sync

Run this with the filesystem mounted normally and again with the
filesystem mounted -o nobarrier.  -o nobarrier should be dramatically
and hugely faster, almost like we're not writing to the disk at all.

-chris
