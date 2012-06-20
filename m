Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:53952 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756951Ab2FTQej (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 12:34:39 -0400
Message-ID: <4FE1FB9B.1090203@libero.it>
Date: Wed, 20 Jun 2012 18:34:35 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: cwillu <cwillu@cwillu.com>, helmut@hullen.de, linux-btrfs@vger.kernel.org
Subject: Re: R: Re: Subvolumes and /proc/self/mountinfo
References: <32353828.234981340193742067.JavaMail.defaultUser@defaultHost> <4FE1EE52.20002@zytor.com>
In-Reply-To: <4FE1EE52.20002@zytor.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 05:37 PM, H. Peter Anvin wrote:
> On 06/20/2012 05:02 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>>
>> If I swap (via a rename) __active and __rollback, in the next boot my system
>> uses a "good" copy of the root filesystem. This is a simple way to swap 
>> two subvolumes, without involving the boot logic
>>
>> Instead if I had tracked the subvolume-id, to swap the root filesystem I 
>> would have update the boot logic.
>>
>> I suspect that could exists other cases where it is preferable to track the 
>> subvolume-id instead the path. However what I would highlight it is the two
>> ways aren't equal.
>>
> 
> Yes.  The question here is what makes sense for the low-level part of a
> bootloader (Syslinux in this case) to use, and it sounds like you have
> some experience here that would be highly useful to have.
> 
> The thing to keep in mind here is that the low level bootloader code
> *must* match what is installed in the boot block (functionally another
> part of the bootloader), or all hell will break loose.  I think that
> means that relying on the subvolume ID makes more sense.  To upgrade the
> bootloader, invoke the bootloader installer at the end of the update;
> that will repoint *everything*, which is rather nice.


At the first I tough that having the /boot separate could be a good
thing. Unfortunately /boot contains both the bootloader code and the
kernel image. The kernel image should be in sync with the contents of
/lib/modules/....

This is the tricky point. If I handle /boot inside the filesystem
submodule a de-sync between the bootloader code and the boot sector
could happens. In I handle /boot as separate subvolume/filesystem a
de-sync between the kernel image and the modules could happens.

Anyway, from a bootloader POV I think that /boot should be handle
separately (or as filesystem or as subvolume identified by specific ID).
The best could be move the kernel in the same subvolume as /lib/modules,
so a switch of the subvolume as root filesystem would be coherent.


GB
> 
> 	-hpa
> 

