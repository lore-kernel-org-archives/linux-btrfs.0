Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:39169 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751685AbaBZDEI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Feb 2014 22:04:08 -0500
Message-ID: <530D599F.6090500@oracle.com>
Date: Wed, 26 Feb 2014 11:03:59 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: introduce BTRFS_IOC_GET_DEVS
References: <1393242525-18587-1-git-send-email-Anand.Jain@oracle.com> <1393242525-18587-2-git-send-email-Anand.Jain@oracle.com> <20140225175133.GB16073@twin.jikos.cz>
In-Reply-To: <20140225175133.GB16073@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 26/02/2014 01:51, David Sterba wrote:
> On Mon, Feb 24, 2014 at 07:48:45PM +0800, Anand Jain wrote:
>> The user land progs needs   a simple way to see
>> the raw list of disks and its parameters as seen
>> by the btrfs kernel.
>> As of now btrfs-devlist uses this ioctl.
>
> As discussed before together with Hugo, the ioctl could exist parallel
> to sysfs export of the device data. From that point it's easier to
> maintain and update a set of sysfs files than an ioctl. The way you
> suggest it right now lacks future-proof extensibility and backward
> compatibility handling.
>
> The userspace code is said to be a small and debug program, the sysfs
> would IMHO satsify it needs as well, so I suggest not to continue on the
> ioctl approach.


  sysfs interface has its advantage, but please lets not clutter
  it with the debug info as it just don't belong there. And one
  should be care full enough not to introduce regressions [1]
  when writing sysfs interfaces (sysfs has to be "managed"
  VS debug-friendly memory-dump/ioctl-dump).

  Next, btrfs-kernel device management isn't just ready
  fully[2] so that sysfs interface can be developed as
  of now. It better wait.

[1]
    https://www.mail-archive.com/linux-btrfs@vger.kernel.org/msg31432.html
    http://comments.gmane.org/gmane.comp.file-systems.btrfs/31915

[2] btrfs-kernel has no idea when disk disappears.
     To get this done we appear to need more enhancements
     related to the usage of kobjects with in kernel.

Thanks, Anand
