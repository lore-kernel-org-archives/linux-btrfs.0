From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: linux-next: build warninga in Linus' tree
Date: Wed, 1 Jun 2011 10:16:48 -0500
Message-ID: <BANLkTi=t5H8sAc_0sHyFt_xJgbeVibO3KQ@mail.gmail.com>
References: <20110530113653.5c7084f0.sfr@canb.auug.org.au>
	<20110531175709.GC12709@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: dave@jikos.cz, Stephen Rothwell <sfr@canb.auug.org.au>,
	Chris Mason <chris.mason@oracle.com>,
	linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110531175709.GC12709@twin.jikos.cz>
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 31, 2011 at 12:57 PM, David Sterba <dave@jikos.cz> wrote:
> Hi,
>
> On Mon, May 30, 2011 at 11:36:53AM +1000, Stephen Rothwell wrote:
>> After merging the Linus' tree, today's linux-next build (powerpc
>> ppc64_defconfig) produced these warnings:
>>
>> fs/btrfs/sysfs.c:76:26: warning: 'btrfs_root_attrs' defined but not used
>> fs/btrfs/sysfs.c:97:26: warning: 'btrfs_super_attrs' defined but not used
>> fs/btrfs/sysfs.c:153:13: warning: 'btrfs_super_release' defined but not used
>> fs/btrfs/sysfs.c:160:13: warning: 'btrfs_root_release' defined but not used
>>
>> I have started using gcc v4.5.2 (instead of v4.4.4) if that makes a
>> difference.
>
> the warning probably started to show up after one of my cleanup patches,
> removing unused functions (f2a97a9dbd86eb1ef956bdf20e05c507b32beb96).
> The sysfs interface is not being used right now, but there's a unmerged
> patchset which adds the interesting bits like info about available btrfs
> filesystems and devices. I don't know what are the intentions regarding
> sysfs.
>
>
> david

I've been playing around with resurrecting the basic sysfs
capabilities that had been previously incorporated into btrfs.

As it stands right now, it was relatively easy to re-implement sysfs
as it was originally.  However, that implementation of sysfs wasn't
populated with much information (only total_blocks, blocks_used, and
blocksize).

I also had to reverse a small portion of code that was in the last clean-up.

If a CONFIG_BTRFS_DEBUG type configuration flag is ever introduced, it
would be interesting to resurrect btrfs' sysfs capabilities.
