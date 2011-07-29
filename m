From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: kernel BUG at fs/btrfs/delayed-inode.c:1693!
Date: Fri, 29 Jul 2011 13:42:20 +0800
Message-ID: <4E32483C.4060708@cn.fujitsu.com>
References: <CALFpzo5MPj10Hkf2Peq3Zko9wE+DccxmS070S0VmRbFYEQk2pQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Marcus Sorensen <shadowsor@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CALFpzo5MPj10Hkf2Peq3Zko9wE+DccxmS070S0VmRbFYEQk2pQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Marcus Sorensen wrote:
> I too have run into this just today, file system is nearly fresh:
> 
> 
> ------------[ cut here ]------------
> kernel BUG at fs/btrfs/delayed-inode.c:1693!

I just sent out a patch to fix it, see:

[PATCH] Btrfs: reverse enough space for file clone

--
Li Zefan
