From: CACook@quantum-sci.com
Subject: Re: Kernel Modules
Date: Sat, 9 Jul 2011 10:28:03 -0700
Message-ID: <201107091028.04403.CACook@quantum-sci.com>
References: <201107090919.12739.CACook@quantum-sci.com> <4E188C0B.4060004@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E188C0B.4060004@gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Saturday 9 July, 2011 10:12:43 you wrote:
> If your btrfs lives on two or more devices you will have to run 'btrfs
> device scan' prior to mount or give all devices as arguments to mount.btrfs.

Ohhh, I'd added a disk drive without modifying fstab.  Thanks.

Where would you put a device scan to happen at boot?


On another subject, I guess there are two ways to remove old snapshot directories:
- btrfs subvolume delete
- rm -rf

I understand that snapshots are cumulative for files and do not duplicate, but is it necessary to use the subvolume delete command to preserve the integrity of remaining snapshots?


And also, about once a week KDE locks up on me after a suspend, and I have to power-cycle it.  Is there any maintenance I should do on a btrfs part when this happens?

