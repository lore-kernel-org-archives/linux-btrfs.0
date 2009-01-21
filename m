From: Chris Mason <chris.mason@oracle.com>
Subject: Re: Misleading error message in btrfsctl
Date: Wed, 21 Jan 2009 10:05:29 -0500
Message-ID: <1232550329.17244.8.camel@think.oraclecorp.com>
References: <49733138.4010309@aon.at>  <1232287950.10058.6.camel@trillian>
Mime-Version: 1.0
Content-Type: text/plain
Cc: Peter Klotz <peter.klotz@aon.at>, linux-btrfs@vger.kernel.org
To: Calvin Walton <calvin.walton@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1232287950.10058.6.camel@trillian>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, 2009-01-18 at 09:12 -0500, Calvin Walton wrote:
> On Sun, 2009-01-18 at 14:40 +0100, Peter Klotz wrote:
> > Calling btrfsctl results in this message when module btrfs.ko is not loaded:
> > 
> > root@asus:/root# btrfsctl -A /dev/sda
> > ioctl:: Bad file descriptor
> ..
> > The output with applied patch:
> > 
> > root@asus:/root# btrfsctl -A /dev/sda
> > failed to open /dev/btrfs-control
> 
> It would probably be better to use perror() instead of fprintf, in order
> to give the actual error message. I often find it useful to know why the
> device failed to open - is it missing, permission issues? I've updated
> the patch:
> 

Thanks

-chris


