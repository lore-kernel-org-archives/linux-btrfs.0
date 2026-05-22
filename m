Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8996C44CAE0
	for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 15:20:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779463204; cv=pass; b=pjjdkM7cYZIavdqMaxhqfCoc5oe0TzppiP2R5Yj1wMa++Ysqjqctuj4JEwRsThSF3fgSGL9QUI7SgF6cGDbdo48g3SJSk9H/uTEMOlU6w5SitT0MlZxn1Kg+0LlYn3jL/Eb3F1UdiQhflBfrw1lSbI7JQn6H7xBpJZeOpJWe3T4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779463204; c=relaxed/simple;
	bh=2HtmqG4q23SlDc0TprSnoWWCilLLRLaGT8J58ZRkDng=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t+9ln4grxKgMSsFv9wmQN3XTDh/loE4HTYNLnJ9M5fOyKcaEr/VRi3ZBBywQY6LIpSdXWxKkNW8nWzdyE+4shouzLpqs9AaocY1VXaHY95kbVHSaaqHpHPT0Ypz0F7ZgKhitAYvyAFfsPZOdY+8oFSXvlRiAa56sdx1l64ffmHY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DpsRkvzp; arc=pass smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DpsRkvzp"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-95f6b47b309so1509559241.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2026 08:20:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779463198; cv=none;
        d=google.com; s=arc-20240605;
        b=ZG3wBDmPWdCSCaxgEmQVeotzU8ivS8oAJF0yreNOD8DZEMjJdpwK2i1pQQvrxQKQDA
         VYapIIbURrnpDQBfc9uzR8ReKO3k076oLvU0quGsh9nAa+Qm4E7srHoec0sUAk9R6cGW
         BtlCR91PLS7o4SNBPRafnVlZ1daFLIuvlauxCERyZuu6hFm949cjlOxaPvObVCuTcHn7
         7cSiW5ATpTvvl1Y5mydPPUjg3RqHvMJcROw4mogP7jaWaBQUnA9SBrp0y25zwx4hHUDO
         3+jFTVWXpHQWPXC9+h/FMGgxs0eztD9OHMcYgh3H32+foCQCu86LNYfjS5XW8JbLMs+a
         GDww==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=30JrZBaUXnPWkKMqU+MyyvNJ9YH6J3oKMQYdAUM1xvo=;
        fh=gccavu6KskZuhdxKZGGZqKbRpE8AZv+Jw1v9OVMw784=;
        b=Gdga+X1tzGOvT5VaSu7DfGnrCMXj3BtfoWN/ZFzqKHoQEQ9k47HLqO1texMprSvfjb
         gBEuX+gp9o1QIf++zHRiYRPs4ykCD93JH2dQ8PEzVUOpYfrDAHxXXQrYVPf4Uj76exby
         6U3cwlfwqB1mIibFpNFeuR/usQdCWxDueuwlfPWqNzzWZjseeXZXN+w6Orh82FAi5aWT
         PR+D/Tadqt00s/Ssq9rwOVyVMDkq+f9VpbMxu7dpmBgCXEV4YcEGeGRGo8Uf/yH9Gqq/
         CY/Nxm33NW+hNan/Cr8tIbZkyeGggEEBGi3kachTMt5/ZVrOKXG/bsph2Gq91mfivsU6
         awAg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779463198; x=1780067998; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=30JrZBaUXnPWkKMqU+MyyvNJ9YH6J3oKMQYdAUM1xvo=;
        b=DpsRkvzppF4Ydv+7zAWeH2v6EIU4g+eZuw5BVeYLAvKVsqHvfx0/9oOwZCVhf6V7Gb
         aMPwLTxBN/CAtTnZh3TDMhrHgKYcZanCA0QdBtk506w9D79Jq3NswgkWWRYvto3Ootky
         D9D7eTup1yCGXTaEINjrE+CAVCwqaBjzQl+KR/RfaWd8D+pe2nMP6d01nq6rhvGhK7Cg
         SWSBCoYlSsc86L73zQjDl9K17QebL7qTeABWjEMckxg+yhDuyP01hwRARLJWSjgBLHmB
         NFOPyb+s7ctmZWtsPqxvfG2fg/pl2t3dBdgTZ2jUU6BjIBxj9uh9S/MsyNOJGKHt7gAy
         niXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779463198; x=1780067998;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=30JrZBaUXnPWkKMqU+MyyvNJ9YH6J3oKMQYdAUM1xvo=;
        b=qfHeVGOkOEO9r0/+O0SrUeggpNt/bodckcjfZwRCuFq5Ed7AfxZ7qlAFTWMm09wKJ9
         qkQVkOQ+hIhvlLjO5Rhm7uOpBT5DN/6BCK2XmsTU9jYHfEwp/6xgXxZP169Dd9EIQVWm
         xm4kQ+UhlmeqRy44VK+I39mwdCnVwkGio/O2jRegrP5u6G+ZCYec7gvZzPz14WieqyxC
         DhWhE72wtdihZvwhLnRI1aAnEzmRmoZpWpHyQm37EWNB+6gGaaP8y+14sMQJ7pDEvaT2
         eSj8nMYv9mKEt6bzbOvxBG41yV5BuhbHg4NTF+qo3R5gEJJ4Q4NUpEj85HcQCtP2hMdO
         FWQw==
X-Gm-Message-State: AOJu0Yw+OwTBlROCrGpMroQHEhz8OqFDzGhAe7pcXuDzEcGOLSXxVCkC
	bSWXomotUbCkFND7S5KTq+vCY29ErplHuxnxEIMGKDUhgVunfJGLNg/LJceTepfeHzqsnBTSvYr
	mTUnJEVvqhoiJI34Ce5tL0oxSrmNDJ+F5k5RQCh0=
X-Gm-Gg: Acq92OHsTHhaGdNdja+DW6nAHfDBVQil9iG3htKKACGGE2D44203xtjdZGoBbNjcAOo
	cn/qPxkNOtB/rYcq1zrBdiYRpetzMKEWZHH+vootmMbJVoo4MBtnSiZqy+E0T/KqwA2YU1bBOg3
	5FBvUOKvKqavfSze5UbMLHuU5wa7tYT1YnIWOvLF3y32hPxD2O3MSXEc3zC4Ml2Kzq40JUx0al7
	UL2cwZP3Iry9VL1B/yIh/2nvCfsZu/szc0L3EJbkoHXKFOepiwD87iANV3q+up5xVp9V3UJNIbI
	vql/QQ8=
X-Received: by 2002:a05:6102:4494:b0:633:2389:3a82 with SMTP id
 ada2fe7eead31-67c8706b1a3mr2059049137.28.1779463198269; Fri, 22 May 2026
 08:19:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAKWORBBVbZBKqxNsmMkWnx-MjLf2uCPFJCU2LJBUMsciu+XfPA@mail.gmail.com>
 <3a32a311-8299-4023-9dfb-40cb5d5cd739@suse.com>
In-Reply-To: <3a32a311-8299-4023-9dfb-40cb5d5cd739@suse.com>
From: Brad Brown <drundel@gmail.com>
Date: Fri, 22 May 2026 10:19:47 -0500
X-Gm-Features: AVHnY4LOVi6xkJvjP9rHZgmjs90KbIdGcyFkXK1sU_BjW3vE74w63-8PsVIuiuY
Message-ID: <CAKWORBC9-zpOMsK1xVzKUvs9a_LU5eMt8J8LmwCg46_XbgP7+g@mail.gmail.com>
Subject: Re: Linux won't boot, drive is btrfs
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Thanks for the suggestions.

This PC does have timeshift installed, so if I can get the partition
to mount, I should be able to run a restore from a Timeshift backup.

---

I tried these commands (assuming my syntax is correct).

sudo blkid
/dev/nvme0n1p2: UUID=3D"64e55b77-65ef-43d7-b84f-458aa9c35d38"
UUID_SUB=3D"a7209ea7-9eb6-4481-8793-a4ce35061099" BLOCK_SIZE=3D"4096"
TYPE=3D"btrfs" PARTUUID=3D"d454e189-6415-4050-b30e-42ef3650af7b"

sudo mount -t btrfs -o rescue=3Dall,ro,
subvold=3D64e55b77-65ef-43d7-b84f-458aa9c35d38 /mnt
mount: /mnt: special device
subvold=3D64e55b77-65ef-43d7-b84f-458aa9c35d38 does not exist.

sudo mount -t btrfs -o rescue=3Dall,ro,
subvold=3Da7209ea7-9eb6-4481-8793-a4ce35061099 /mnt
mount: /mnt: special device
subvold=3Da7209ea7-9eb6-4481-8793-a4ce35061099 does not exist.

mint@mint:~$ sudo mount -o ro,rescue=3Dall /dev/nvme0n1p2 /mnt
mount: /mnt: can't read superblock on /dev/nvme0n1p2.
       dmesg(1) may have more information after failed mount system call.

mint@mint:~$ sudo btrfs rescue chunk-recover /dev/nvme0n1p2
Scanning: 13956239360 in dev0scan chunk headers error

mint@mint:~$ sudo mount -t btrfs -U
64e55b77-65ef-43d7-b84f-458aa9c35d38 /mnt/data
mount: /mnt/data: can't read superblock on /dev/nvme0n1p2.

mint@mint:~$ sudo mount -t btrfs -o rescue=3Dall,ro -U
64e55b77-65ef-43d7-b84f-458aa9c35d38 /mnt/data
mount: /mnt/data: can't read superblock on /dev/nvme0n1p2.
       dmesg(1) may have more information after failed mount system call.

---

Any other suggestions or should I just wipe it and start over?

Thank you

On Thu, May 21, 2026 at 2:23=E2=80=AFAM Qu Wenruo <wqu@suse.com> wrote:
>
>
>
> =E5=9C=A8 2026/5/21 01:22, Brad Brown =E5=86=99=E9=81=93:
> > Hello,
> >
> > I hope this email will send with the attachment, but please see below
> > about an issue with a Linux computer.
> >
> > I needed to verify a card in a Dell Precision 7730 so I took off the
> > case, I disconnected the battery and I guess the CMOS battery is dead
> > because when I tried to boot it back up it gave me a generic Windows
> > error (there is no Windows on the drive) and then a wrong time BIOS. I
> > got into the BIOS and sure enough, the UEFI boot sequence was back to
> > factory with no listing for Linux and many of my other settings were
> > wrong, keyboard light, charging, etc.
> >
> > Ok so boot to Mint Live USB, run the Boot Repair, it says successful
> > repair but a message about Locked-NVram and to add in the boot details
> > manually. Below is the link for the repair log.
> >
> > https://paste.ubuntu.com/p/Xf3JJHbwft/
> >
> > Ok back into BIOS, I added it, but the File System List looked very
> > weird, but I was able to start booting and see the normal screen, but
> > then it went into a bunch of error scrolling and hung. I power cycled
> > it and now it just goes into GRUB.
> >
> > That's when I started googling and one thing that might be helpful is
> > when running ls from GRUB when booting to grubx64.efi it doesn't
> > really see the partitions. I mean it sees them, but not what they are.
> > If I change the boot to shimx64.efi (it again boots into grub) but ls
> > sees the partitions and what they are.
> >
> > If booting into Live USB from shimx64.efi file and running gparted it
> > tells me there are issues on the btrfs partition but it can't fix
> > them.
> >
> > I took a bunch of pictures to help let me know what pictures would be
> > helpful and I will just link to google drive.
> >
> > mint@mint:~$ efibootmgr
> > BootCurrent: 0007
> > Timeout: 0 seconds
> > BootOrder: 0002,0001,0003,0006,0004,0007,0008
> > Boot0000* Windows Boot Manager
> > HD(1,GPT,137a5fe7-5c51-415f-aede-fe406ab629db,0x800,0x100000)/File(\EFI=
\Microsoft\Boot\bootmgfw.efi)57494e444f575300010000008800000078000000420043=
0044004f0042004a004500430054003d007b00390064006500610038003600320063002d003=
5006300640064002d0034006500370030002d0061006300630031002d006600330032006200=
330034003400640034003700390035007d000000a1620100000010000000040000007fff040=
0
> > Boot0001 Linux HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x10=
0000)/File(\EFI\ubuntu\grubx64.efi)
> > Boot0002* Old boot
> > HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x100000)/File(\EFI=
\ubuntu\shimx64.efi)
> > Boot0003* Onboard NIC(IPV4)
> > PciRoot(0x0)/Pci(0x1f,0x6)/MAC(8c04ba01b112,0)/IPv4(0.0.0.00.0.0.0,0,0)=
0000424f
> > Boot0004* Onboard NIC(IPV6)
> > PciRoot(0x0)/Pci(0x1f,0x6)/MAC(8c04ba01b112,0)/IPv6([::]:<->[::]:,0,0)0=
000424f
> > Boot0006 UEFI: PM981 NVMe Samsung 256GB, Partition 1
> > HD(1,GPT,238692d6-7da0-493e-8329-08bd94eaa0bc,0x800,0x100000)/File(\EFI=
\Microsoft\Boot\bootmgfw.efi)0000424f
> > Boot0007* UEFI: USB
> > PciRoot(0x0)/Pci(0x14,0x0)/USB(18,0)/CDROM(1,0x1234,0xa000)0000424f
> > Boot0008* UEFI: USB, Partition 2
> > PciRoot(0x0)/Pci(0x14,0x0)/USB(18,0)/HD(2,MBR,0xe904b4b7,0x1234,0x2800)=
0000424f
> >
> > Thanks all
> >
> > ------
> >
> >
> > mint@mint:~$ uname -a
> > Linux mint 6.12.48+deb13-amd64 #1 SMP PREEMPT_DYNAMIC Debian 6.12.48-1
> > (2025-09-20) x86_64 GNU/Linux
> >
> > mint@mint:~$ btrfs --version
> > btrfs-progs v6.14
> > -EXPERIMENTAL -INJECT -STATIC +LZO +ZSTD +UDEV +FSVERITY +ZONED CRYPTO=
=3Dbuiltin
> >
> > mint@mint:~$ sudo btrfs fi show
> > Label: none  uuid: 64e55b77-65ef-43d7-b84f-458aa9c35d38
> >          Total devices 1 FS bytes used 122.02GiB
> >          devid    1 size 213.27GiB used 152.02GiB path /dev/nvme0n1p2
> >
> > btrfs fi df /home
> > Can't run as am booted to a live USB
> >
> > dmesg.log attached
>
> Your fs is corrupted, and it looks like some write-from-future corruption=
.
> Normally this means the FUA/flush behavior is unreliable.
>
> If you're not using nobarrier mount option, it's possible your nvme
> drive has some bad firmware, not respecting FUA/flush command.
>
> Since your fs is corrupted, and it's affecting the very important fs
> tree, I do not think the fs can be repaired to a RW state.
>
> You can try mount the fs with "rescue=3Dall,ro" mount option, but I guess
> it will still fail anyway. If you know some subvolume id, you may try
> with "rescue=3Dall,ro,subvold=3D<id>" mount option and may have a chance =
to
> salvage data from that specific subvolume.



--=20

Brad Brown
http://www.drundel.com/

Texas A&M University
Class of 2000
