From: Goffredo Baroncelli <kreijack@libero.it>
Subject: Re: Kernel Modules
Date: Sun, 10 Jul 2011 10:24:26 +0200
Message-ID: <4E1961BA.8020603@libero.it>
References: <201107090919.12739.CACook@quantum-sci.com> <4E188C0B.4060004@gmail.com> <201107091028.04403.CACook@quantum-sci.com>
Reply-To: kreijack@inwind.it
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: CACook@quantum-sci.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201107091028.04403.CACook@quantum-sci.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 07/09/2011 07:28 PM, CACook@quantum-sci.com wrote:
> On Saturday 9 July, 2011 10:12:43 you wrote:
>> If your btrfs lives on two or more devices you will have to run
>> 'btrfs device scan' prior to mount or give all devices as arguments
>> to mount.btrfs.
> 
> Ohhh, I'd added a disk drive without modifying fstab.  Thanks.
> 
> Where would you put a device scan to happen at boot?

The more recent distro put the scanning logic in the initrd. This should
be the right place.


> On another subject, I guess there are two ways to remove old snapshot
> directories: - btrfs subvolume delete - rm -rf

with rm -rf you can remove only the subvolume contents, but you cannot
delete a subvoulume.

> 
> I understand that snapshots are cumulative for files and do not
> duplicate, but is it necessary to use the subvolume delete command to
> preserve the integrity of remaining snapshots?

No. Apart removing the subvolume entry, "rm -rf" and "btrfs subvolume
delete" reach the same result. The latter is only a lot more efficient.

> And also, about once a week KDE locks up on me after a suspend, and I
> have to power-cycle it.  Is there any maintenance I should do on a
> btrfs part when this happens?

Normally you don't do anything. In any case you are not able to do
anything because there no is a tool like fsck available :-)


> 
> -- To unsubscribe from this list: send the line "unsubscribe
> linux-btrfs" in the body of a message to majordomo@vger.kernel.org 
> More majordomo info at  http://vger.kernel.org/majordomo-info.html .
> 

