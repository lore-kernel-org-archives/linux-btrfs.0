From: Josef Bacik <josef@redhat.com>
Subject: Re: cp --reflink with Btrfs
Date: Mon, 14 Dec 2009 11:23:23 -0500
Message-ID: <20091214162323.GA2165@localhost.localdomain>
References: <hg1cge$74i$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Jason White <jason@jasonjgw.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <hg1cge$74i$1@ger.gmane.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Dec 13, 2009 at 12:29:03AM +0000, Jason White wrote:
> I am testing a Btrfs root file system with Debian (kernel 2.6.32) under KVM.
> 
> jason@vrtl:~$ touch testfile
> jason@vrtl:~$ cp --reflink testfile /tmp
> cp: failed to clone `/tmp/testfile': Invalid argument
> 
> This is with GNU Coreutils 8.0 taken from debian Sid.
> 
> Is this a Coreutils issue, a Btrfs problem or something in my local
> configuration?
>

Try using bcp, if that works then its likely a problem with coreutils.

> All the other issues that I have encountered so far are known limitations, for
> example, lack of Btrfs support in Grub 2 and the current inability of the
> initrd scripts from Debian to recognize the file system type. All of this will
> be fixed, no doubt, over time.
> 

Yeah the initrd stuff is all debian "problems".  When I added btrfs support to
fedora there were alot of various utilities and such that needed to be changed
in order to accomodate it, so the same sort of thing likely needs to be done
with debian.  There are patches for Grub1 since thats what Fedora uses, I
suppose that there will be Grub2 patches in the future, but since the author of
the grub patches uses fedora and we're on grub1 it's all we care about :).
Thanks,

Josef
