From: Gordan Bobic <gordan@bobich.net>
Subject: Re: hard links across snapshots/subvolumes are actually a bad idea.
Date: Wed, 24 Nov 2010 23:29:16 +0000
Message-ID: <4CED9FCC.9080804@bobich.net>
References: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinMrCMQhnmrG6P_Xro+dFob=-gsatPTR2oiRXqr@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/2010 10:07 PM, David Nicol wrote:
> I've been thinking about this for a while, from a perspective of how
> to make it work by allocating i-node numbers from a global pool, but
> yesterday I realized that offering the feature would be a bad idea
> because it violates the semantics of file systems.
>
> I will be happy to expand on that point if anyone disagrees with it.

One thing I would like to see is copy-on-write hard-links. The 
hard-links that span snapshots should be possible, but they should be 
copy-on-write, i.e. as soon as hard-linked file that spans snapshots is 
written, the snapshot that wrote it should have it's own forked copy 
henceforth.

This would be immensely useful for things like virtualization and memory 
saving. Not only would it save memory in the caches, but if multiple 
instances of the same OS are used in LXC containers cloned using 
snapshots, then two DLLs with the same inode number would mmap into the 
same memory segment. That means that no matter how many VMs you run, if 
they have the same DLLs, the memory requirement for all those would be 
the same as if there was only one VM running.

Linux Vserver does exactly this (it patches several of the FS drivers to 
add this feature. This is pretty much the only reason why I use it 
instead of the already merged LXC.

Gordan
