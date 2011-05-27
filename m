From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: [PATCH] Btrfs: make lzo the default compression scheme
Date: Fri, 27 May 2011 14:41:56 +0700
Message-ID: <BANLkTikG4Af1fBExKHe+4UwVAm81U077Mg@mail.gmail.com>
References: <4DDDCB57.6090405@cn.fujitsu.com>
	<20110527073212.GA28453@attic.humilis.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: sander@humilis.net
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110527073212.GA28453@attic.humilis.net>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2011 at 2:32 PM, Sander <sander@humilis.net> wrote:
> Li Zefan wrote (ao):
>> As the lzo compression feature has been established for quite
>> a while, we are now ready to replace zlib with lzo as the default
>> compression scheme.
>
> Please be aware that grub2 currently can't load files from a btrfs with
> lzo compression (on debian sid/experimental at least).
>
> Just found out the hard way after a kernel upgrade on a system with no
> separate /boot partition :-)
>
> Found this: https://bugs.archlinux.org/task/23901

IIRC what matters is compression actually used by the files.
If /boot/grub/* and kernel/initrd is not compressed, or compressed
with zlib, then grub2 can read it just fine, even when the filesystem
is usually mounted with -o compress=lzo (I'm using Ubuntu Natty).

I think the move to use lzo compression by default is a good thing, since:
- it's superior performance-wise to zlib
- btrfs is not really recommended (yet) for production uses, so it's
valid enough to assume users brave enough to use btrfs will know the
necessary workarounds (like having separate /boot, or temporary
remount with -o compress=zlib when upgrading kernel)
- even if by accident you ended with unbootable system due to lzo, you
can "fix" it using livecd and "btrfs filesystem defragment" to force
the needed files to be uncompressed/compressed with zlib.

-- 
Fajar
