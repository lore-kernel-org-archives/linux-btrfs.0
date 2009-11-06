From: Josef Bacik <josef@redhat.com>
Subject: Re: Unexpected ENOSPC on a SSD-drive after day of uptime,
	kernel?2.6.32-rc5
Date: Thu, 5 Nov 2009 20:25:15 -0500
Message-ID: <20091106012514.GE22737@dhcp231-156.rdu.redhat.com>
References: <fe72f2c80911051238y299bab12g5f4b878851a25f13@mail.gmail.com> <20091105210234.GD22737@dhcp231-156.rdu.redhat.com> <loom.20091105T214826-537@post.gmane.org> <20091105215524.GA13953@localhost.localdomain> <fe72f2c80911051437u4c79ff74nc7cd2c2ff8d45138@mail.gmail.com> <20091105224303.GB13953@localhost.localdomain> <fe72f2c80911051507t7fbb95c0s2134bf2018a6a413@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Josef Bacik <josef@redhat.com>, linux-btrfs@vger.kernel.org
To: miyamoto moesasji <miyamoto.31b@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <fe72f2c80911051507t7fbb95c0s2134bf2018a6a413@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Nov 05, 2009 at 11:07:27PM +0000, miyamoto moesasji wrote:
> I'm not 100% sure what is the correct answer.
> 
> This is a clean install, just installed this weekend so the system
> itself has only been running with the 2.6.32-rc5 kernel, nothing older
> than that and the drive itself was completely new/clean. However for
> the install itself I've used SystemRescueCD which was using a 2.6.31.1
> kernel. Hence the partitions have been formatted using the kernel
> 2.6.31.1 and that is also the kernel used during the install of the
> system.
>

Yeah if most of the data was put on the disk under the old kernel then its
likely everything was skewed towards metadata and thats why you are having
problems.  Theres not much more I can say other than sorry :(.  If you can, try
copying the data from that volume to a new volume, format the old volume, and
copy it back under the new kernel and it should work out better.  Thanks,

Josef 
