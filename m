From: Martin <m_btrfs@ml1.co.uk>
Subject: Re: btrfs across a mix of SSDs & HDDs
Date: Wed, 02 May 2012 15:00:59 +0100
Message-ID: <jnrems$tkh$1@dough.gmane.org>
References: <jnpdud$ta9$1@dough.gmane.org> <jnq5os$tdn$1@dough.gmane.org> <CAG1y0sfMJ4TtOE3C6hTBH59ESZcomDs0uHJEpowC-8e=6s86cQ@mail.gmail.com> <jnqf0j$hcd$1@dough.gmane.org> <CAG1y0scNSit6oCvySUiP6RChx3_LLDY1QBML0BpGM-39etnZLQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAG1y0scNSit6oCvySUiP6RChx3_LLDY1QBML0BpGM-39etnZLQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Thanks for good comments.


>> Is the OP using Oracle Linux?
> 
> He didn't say. But he didn't say he WON'T be using oracle linux (or
> other distro which supports btrfs) either. Plus the kernel can be
> installed on top of RHEL/Centos 5 and 6, so he can easily choose
> either the supported version, or the mainline version, each with its
> own consequences.

For further info:

Nope, not using Oracle Linux. Then again, I'm reasonably distro
agnostic. I'm also happy to compile my own kernels.

And the system in question uses a HDD RAID and looks to be more IOPS
bound rather than suffering actual IO data rate bound. The large
directories certainly don't help! It's running postfix + courier-imap at
the moment and I'm looking to revamp it for the gradually ever
increasing workload. CPU and RAM usage is low on average. It serves 2x
Gbit networks + internet users (3 NIC ports).

Hence I'm considering the best way for an revamp/upgrade. SSDs would
certainly help with the IOPS but I'm cautious about SSD wear-out for a
system that constantly thrashes through a lot of data. I could just
throw more disks at it to divide up the IO load.

Multiple pairs of "HDD paired with SSD on md RAID 1 mirror" is a thought
with ext4...

bcache looks ideal to help but also looks too 'experimental'.

And I was hoping that btrfs would help with handling the large
directories and multi-user parallel accesses, especially so for being
'mirrored' by btrfs itself (at the filesystem level) across 4 disks for
example.

Thoughts welcomed.


Is btrfs development at the 'optimising' stage now, or is it all still
very much a 'work in progress'?

Regards,
Martin

