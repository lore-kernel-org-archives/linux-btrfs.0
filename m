Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-16.italiaonline.it ([212.48.25.144]:36527 "EHLO libero.it"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751549AbcKZNYq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 26 Nov 2016 08:24:46 -0500
Reply-To: kreijack@inwind.it
Subject: Re: My system mounts the wrong btrfs partition, from the wrong disk!
References: <a39949b5-abab-40a3-943e-818b6ca7106b@linuxsystems.it>
 <20161125161712.1df4f7b6@natsu>
 <CAJCQCtQNpoYHkjYtiW6kd+CF0ic-qZWFRC1RHnSavj3ntUcFxg@mail.gmail.com>
To: Chris Murphy <lists@colorremedies.com>, Roman Mamedov <rm@romanrm.net>
Cc: =?UTF-8?Q?Niccol=c3=b2_Belli?= <darkbasic@linuxsystems.it>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <4539a551-1d00-1686-f222-c607a1594f29@inwind.it>
Date: Sat, 26 Nov 2016 14:24:44 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQNpoYHkjYtiW6kd+CF0ic-qZWFRC1RHnSavj3ntUcFxg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-11-26 00:56, Chris Murphy wrote:
> On Fri, Nov 25, 2016 at 4:17 AM, Roman Mamedov <rm@romanrm.net> wrote:
>> On Fri, 25 Nov 2016 12:05:57 +0100
>> Niccolò Belli <darkbasic@linuxsystems.it> wrote:
>>
>>> This is something pretty unbelievable, so I had to repeat it several times
>>> before finding the courage to actually post it to the mailing list :)
>>>
>>> After dozens of data loss I don't trust my btrfs partition that much, so I
>>> make a backup copy with dd weekly.
>>
>> https://btrfs.wiki.kernel.org/index.php/Gotchas#Block-level_copies_of_devices
>>
>> "don't make copies with dd."
> 
> Yeah.
> 
> In the user's defense, it's way overdue for the kernel to refuse to
> mount without some override flag like XFS does. This behavior is just
> plain user hostile right now, and Btrfs gets an extra ding because
> it's supposed to be better: easier to admin and have better data
> integrity. Basically this is Btrfs eating at least one, possibly both,
> file systems at the same time without warning, and it's not good
> enough to warn in the wiki.
> 


When I read these "incidents" on the ML, I still think that the actual BTRFS way to handling the devices discovery is overcomplicated and not reliable: currently udev push back the device in the kernel which manages an own list of btrfs devices. Then the mount command suggests the kernel to mount a filesystem on the basis of the UUID. In case of problem nor udev nor mount are capable to print any useful message and/or suggestion. Even in case of UUID conflicts (which could be very simple to handle) this system is unreliable.

In the past I developed a mount.btrfs helper which took care of devices discovery and also of these checks; also it could be a place where develop the handling of incomplete multi-disks filesystem....

I hope that sooner or later someone rethink about that.

http://www.spinics.net/lists/linux-btrfs/msg39706.html


BR
G.Baroncelli


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
