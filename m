From: Geoff Ritter <geoff.ritter@gmail.com>
Subject: Re: filesystem seeding ... BUGs on .38, .39, loopback, real
 devices, tmp branch ... everything
Date: Thu, 02 Jun 2011 04:40:41 -0700
Message-ID: <1307014855.13841.10.camel@quintos.origo>
References: <BANLkTikZyg0gyUZH5pQ9d=P4brsTUA9PCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: C Anthony Risinger <anthony@xtfx.me>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikZyg0gyUZH5pQ9d=P4brsTUA9PCg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, 2011-06-02 at 04:20 -0500, C Anthony Risinger wrote:
> 
> i tried with loop devices at first, then "real" devices -- this is all
> under KVM/QEMU, and with FSs that are/will be smaller than 1G.

I have tried the seed option as well.  I was able to successfully mount
the read write partition after setting up the seed.  However, both had
to be independent partitions on a real device.

During testing, both .38 and .39rc could NOT create a seed if one or
both partitions were encrypted.  I believe encrypted partitions also
work with a loop device for the unlocked version you write too.  The
response I got after a few days is as follows:

> Chris Mason chris.mason@oracle.com
> cwillu <cwillu@cwillu.com>
> date	Thu, May 5, 2011 at 4:42 PM
> Ok, looks like I busted the seed support
> when I fixed up some of the chunk
> allocations.  I'll reproduce this and
> work out a fix.

I just assumed it would take a while to fix so I haven't tried again
since.  If the root of the problem appears to be loop devices, you might
want to report that.  Err I guess you did.  To me, this doesn't explain
why it wouldn't work in a Virtual Machine.  I would have thought the VM
would treat it as a real device.



