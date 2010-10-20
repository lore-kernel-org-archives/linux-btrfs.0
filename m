From: David Nicol <davidnicol@gmail.com>
Subject: Re: newbie question about inode numbers
Date: Wed, 20 Oct 2010 08:51:22 -0500
Message-ID: <AANLkTimHQfszXJs9wEff-j9L4+kcOaG385qACK0wzkLs@mail.gmail.com>
References: <AANLkTinE03sBL=K3xfL41VZyFLhafNxHooheTv1PSQTD@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: BTRFS MAILING LIST <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTinE03sBL=K3xfL41VZyFLhafNxHooheTv1PSQTD@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Wow, vger categorically refuses HTML e-mail!

On Tue, Oct 19, 2010 at 4:41 PM, David Nicol <davidnicol@gmail.com> wrote:
>
> the inode number is an "unsigned long" which on a 32 bit system may be merely 32 bits, yet btrfs allows a full 64 bits of files in a file system (which is impossible; but ZFS allows 128 bits of files, which is just silly.)
> My question is, how are inode number collisions prevented on a 32-bit system, with a fs with five billion files?
