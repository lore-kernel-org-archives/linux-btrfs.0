From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Re: kernel 3.3.4 damages filesystem (?)
Date: Tue, 8 May 2012 12:41:43 +0200
Message-ID: <CAFvQSYTK1HAS+gK=SqvXngrESkG5J2nJh5r9FraVGfL7XzmoEQ@mail.gmail.com>
References: <CAG1y0sfCN8qJ2hra0pu2H1HnsrwPNdWi=YG+nCDWAaJWT9e8oQ@mail.gmail.com>
	<C8TEkB+PCXB@helmut.hullen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: helmut@hullen.de, linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <C8TEkB+PCXB@helmut.hullen.de>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Helmut,

>> But where's the gain? If a disk fails I have a lot of tools for
>> repairing an ext2/3/4 system.

Nope, when a disk in your ext4 raid0 array fails, you are just as doomed.


> But when I use ext2/3/4 I neither need RAID0 nor do I need LVM.

You can use btrfs, without using its raid capabilities.
Face it, you used an experimental filesystem and you configured it the
wrong way.
Btrfs is not the one to blame here.

- Clemens
