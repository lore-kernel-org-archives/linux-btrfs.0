From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: Problems Implementing Snappy Patches
Date: Thu, 16 Feb 2012 10:06:13 +0800
Message-ID: <4F3C6495.60906@cn.fujitsu.com>
References: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Mitch Harder <mitch.harder@sabayonlinux.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAKcLGm_AgoHWa1TGwxz6PfSkKvxmDXi_3ykHR10WgTFVW9Gt4g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Mitch Harder wrote:
> I've been trying to test the snappy compression patches, but I'm
> getting corruptions when trying to use snappy as built on my system.
> 
> I'm checking out the Linux 3.2.6 kernel, merging that with the latest
> 'for-linus' branch on Chris Mason's kernel.org repo, and then
> integrating the snappy and lz4 patches from David Sterba's git
> repository (dev/compression-squad branch).
> 
> I've tried a simple merge of the dev/compression-squad branch (which
> merged without complaint by git), and I also tried a second build of
> the kernel integrating the dev/compression-squad branch patches with
> format-patch (git format-patch -k -m -U5 --stdout <range> | git am -3
> -k).
> 
> I've also tried sourcing my snappy patches from Chris Mason's snappy
> branch on kernel.org with the same result.
> 

A month ago I saved emails as patches and applied them on linux-btrfs'
for-linus branch, and I got the same problem. Then I used the snappy
branch (plus my fix), and it was fine. Don't know why.

> I get the same results either way.
> 
> My system is a Core 2 Duo x86_64 Sabayon based system (Gentoo is our
> parent distro).  My target btrfs/snappy partition is a 16 GB partition
> I use for testing on a 500GB Western Digital Hard Drive.
> 
> When I copy directory containing a kernel sources git repository to a
> freshly formated partition mounted with snappy, I get a corrupted
> copy.  If I mount with lzo or lz4 compression, I don't see any
> corruptions from the copy.
> 
> I'm not showing any errors in dmesg.
> 

You're not seeing any errors, right?
