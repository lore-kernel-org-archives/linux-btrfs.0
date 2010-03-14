From: Mike Fedyk <mfedyk@mikefedyk.com>
Subject: Re: [BUG] scheduling while atomic: init/1/0x00000002
Date: Sat, 13 Mar 2010 22:26:01 -0800
Message-ID: <93cdabd21003132226s2201c067vfdbcaad56ecffd81@mail.gmail.com>
References: <45e1b66a1003131549k28173905r85ab74cd870db36e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Phillip Michael <oopsicrappe@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <45e1b66a1003131549k28173905r85ab74cd870db36e@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Sat, Mar 13, 2010 at 3:49 PM, Phillip Michael <oopsicrappe@gmail.com=
> wrote:
> I have a btrfs filesystem with three subvolumes. One of them (named
> arch64) has 64 bit linux, one (arch32) =C2=A0has 32 bit linux, and th=
e
> third (files) has various files. After an unsuccessful tuxonice
> resume, the arch64 subvolume will no longer boot. It shows this bug:
>
> VFS: Mounted root (btrfs filesystem) readonly on device 0:13.
> Freeing unused kernel memory: 480k freed
> BFS CPU scheduler v0.315 by Con Kolivas.
> BUG: scheduling while atomic: init/1/0x00000002
> Modules linked in:
> Pid: 1, comm: init Not tainted 2.6.33-zen2-20100307-stable #6

Can you reproduce this error on stock 2.6.33 without the zen patches?
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
