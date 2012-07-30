Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63555 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752736Ab2G3MSW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 30 Jul 2012 08:18:22 -0400
Received: by yenl2 with SMTP id l2so4688156yen.19
        for <linux-btrfs@vger.kernel.org>; Mon, 30 Jul 2012 05:18:22 -0700 (PDT)
Message-ID: <50167B88.3080500@gmail.com>
Date: Mon, 30 Jul 2012 20:18:16 +0800
From: Liu Bo <liub.liubo@gmail.com>
MIME-Version: 1.0
To: Florian Lindner <mailinglists@xgm.de>
CC: linux-btrfs@vger.kernel.org
Subject: Re: subvolumes: default and IDs
References: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
In-Reply-To: <CAJtBfr-ndERMvhG2dEwKJVsUe++sqGk_ZU=0gHDr3vbZLSyo_w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 07/30/2012 03:56 PM, Florian Lindner wrote:
> Hey!
>
> I recently starting playing with btrfs and subvolume, but it has left
> me puzzled:
> Distribution is Archlinux, Kernel is 3.4.6.
>
>>>>
> root@horus /mnt # mkfs.btrfs -L test /dev/sdb1
>
> WARNING! - Btrfs Btrfs v0.19 IS EXPERIMENTAL
> WARNING! - see http://btrfs.wiki.kernel.org before using
>
> fs created label test on /dev/sdb1
>          nodesize 4096 leafsize 4096 sectorsize 4096 size 2.73TB
> Btrfs Btrfs v0.19
> root@horus /mnt # mount /dev/sdb1 test
> root@horus /mnt # cd test
> root@horus /mnt/test # btrfs subvolume create sv1
> Create subvolume './sv1'
> root@horus /mnt/test # btrfs subvolume create sv2
> Create subvolume './sv2'
> root@horus /mnt/test # touch sv1/sv1.file
> root@horus /mnt/test # touch sv2/sv2.file
> root@horus /mnt/test # btrfs subvolume get-default .
> ID 256 top level 5 path sv1
> ID 259 top level 5 path sv2
> <<<
>
> What is the default subvolume now? How can I tell?
>
>>>>
> root@horus /mnt/test # btrfs subvolume set-default 259 .
> root@horus /mnt/test # btrfs subvolume get-default .
> ID 256 top level 5 path sv1
> ID 259 top level 5 path sv2
> <<<
>
> Seems to have changed nothing....?
>
>>>>
> root@horus /mnt/test # cd ..
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv2.file
> <<<
>
> Ah, sv2 seems to be default, like I had set it.
>
>>>>
> root@horus /mnt # btrfs subvolume set-default 5 test
> root@horus /mnt # umount test && /mnt # mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Ok, 5 seems to be the root subvolume id. Is it always like that? I
> remembered to have read somewhere it was 0 ? (which makes a kind of
> more sense for me)
>
>>>>
> root@horus /mnt # btrfs subvolume set-default 256 test
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1.file
> <<<
>
> Fine! But:
>
>>>>
> root@horus /mnt # btrfs subvolume set-default 0 test
> root@horus /mnt # umount test && mount /dev/sdb1 test
> root@horus /mnt # ls test
> sv1.file
> <<<
>
> set-default 0 seems to do nothing but does not produce an error
> either. What about subvolume 0? Still I can do:
>
>>>>
> root@horus /mnt # umount test
> root@horus /mnt # mount -o subvolid=0 /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Ok, here 0 as subvolid works. What about subvolid=5?
>
>>>>
> root@horus /mnt # umount test
> root@horus /mnt # mount -o subvolid=5 /dev/sdb1 test
> root@horus /mnt # ls test
> sv1/  sv2/
> <<<
>
> Works too.
>
> Sorry for the lengthy posting, but writing this posting has puzzled me
> even more I was yesterday. I hope someone could shed some light on it.
>

Hi Florian,

Thanks for reporting these!

They are old bugs that had been fixed recently in latest btrfs progs,
you can checkout the latest btrfs-progs from
git://git.kernel.org/pub/scm/linux/kernel/git/mason/btrfs-progs.git

subvolid=0 will be translated to subvolid=5 since 5 indicates btrfs' fs 
tree (the root subvolume as you mentioned)

thanks,
liubo

> Thanks!
>
> Florian
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

