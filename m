From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: Bug when resizing FS
Date: Fri, 14 May 2010 17:37:17 -0700
Message-ID: <AANLkTintpvnU4B8cKFtWc62haNQnXEdINEjqTJFj3UAD@mail.gmail.com>
References: <201005141823.44910.mbuerger@edu.uni-klu.ac.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Martin Bueger <mbuerger@edu.uni-klu.ac.at>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201005141823.44910.mbuerger@edu.uni-klu.ac.at>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 14, 2010 at 9:23 AM, Martin Bueger
<mbuerger@edu.uni-klu.ac.at> wrote:
> Hello,
>
> when I try to resize the FS with btrfsctl -r it works using + or -, hence,
> extending or shrinking the FS but when I want to set it to a certain size I
> always hit the follwing bug:
>
> ------------[ cut here ]------------
>
> invalid opcode: 0000 [#1] SMP
> last sysfs file:
> /sys/devices/pci0000:00/0000:00:10.0/host2/target2:0:1/2:0:1:0/block/sdb/size
> Modules linked in: sr_mod i2c_piix4 cdrom processor container thermal ac
> button i2c_core
>
> Pid: 4044, comm: btrfs-delalloc- Not tainted 2.6.33-zen2 #1 440BX Desktop
> Reference Platform/VMware Virtual Platform

Please try this without the zen patchset.  There have been several
interactions with other patches in this tree in the recent past.
