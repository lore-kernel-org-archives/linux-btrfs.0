From: Edward Shishkin <edward.shishkin@gmail.com>
Subject: Re: [patch 1/2] grub-0.97: btrfs support for a singe device configuration
Date: Thu, 29 Oct 2009 00:02:08 +0100
Message-ID: <4AE8CD70.2060703@gmail.com>
References: <4ABBED68.6090801@redhat.com> <200910272335.04825.johannes.hirte@fem.tu-ilmenau.de> <4AE77BD3.2010400@gmail.com> <200910282230.25307.johannes.hirte@fem.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-6; format=flowed
Cc: The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Johannes Hirte <johannes.hirte@fem.tu-ilmenau.de>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <200910282230.25307.johannes.hirte@fem.tu-ilmenau.de>
List-ID: <linux-btrfs.vger.kernel.org>

Johannes Hirte wrote:
[...]
> This compiles and works, but only with stage2. When using stage1_5, grub hangs
> on boot with
>
> GRUB loading stage1.5 
>
> and blinking cursor. Is the multidevice patch also necessary for single 
> devices?

Yes, please use both patches!
I have split the stuff because the mailing list refuse attachments >100K.

Thanks,
Edward.

>  I've omitted this patch, since my root-fs (with /boot) lies on a 
> single partition.
>
>   

