From: C Anthony Risinger <anthony@xtfx.me>
Subject: Re: [PATCH] Btrfs: make lzo the default compression scheme
Date: Sat, 28 May 2011 00:12:04 -0500
Message-ID: <BANLkTi=AZJC7Uitfm0emxjACgE9dvuzGkg@mail.gmail.com>
References: <4DDDCB57.6090405@cn.fujitsu.com> <20110527073212.GA28453@attic.humilis.net>
 <BANLkTikG4Af1fBExKHe+4UwVAm81U077Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: sander@humilis.net, Li Zefan <lizf@cn.fujitsu.com>,
	"linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
To: "Fajar A. Nugraha" <list@fajar.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <BANLkTikG4Af1fBExKHe+4UwVAm81U077Mg@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 27, 2011 at 2:41 AM, Fajar A. Nugraha <list@fajar.net> wrote:
> On Fri, May 27, 2011 at 2:32 PM, Sander <sander@humilis.net> wrote:
>> Li Zefan wrote (ao):
>>> As the lzo compression feature has been established for quite
>>> a while, we are now ready to replace zlib with lzo as the default
>>> compression scheme.
>>
>> Please be aware that grub2 currently can't load files from a btrfs with
>> lzo compression (on debian sid/experimental at least).
>>
>> Just found out the hard way after a kernel upgrade on a system with no
>> separate /boot partition :-)
>>
>> Found this: https://bugs.archlinux.org/task/23901
>
> IIRC what matters is compression actually used by the files.
> If /boot/grub/* and kernel/initrd is not compressed, or compressed
> with zlib, then grub2 can read it just fine, even when the filesystem
> is usually mounted with -o compress=lzo (I'm using Ubuntu Natty).
>
> I think the move to use lzo compression by default is a good thing, since:
> - it's superior performance-wise to zlib
> - btrfs is not really recommended (yet) for production uses, so it's
> valid enough to assume users brave enough to use btrfs will know the
> necessary workarounds (like having separate /boot, or temporary
> remount with -o compress=zlib when upgrading kernel)
> - even if by accident you ended with unbootable system due to lzo, you
> can "fix" it using livecd and "btrfs filesystem defragment" to force
> the needed files to be uncompressed/compressed with zlib.

i'd agree with the LZO default and everything else you've said, but i
was bitten by this too :-)

in my case however, i was using syslinux, and even though /boot was
not compressed syslinux still failed with something like:

"Found compressed data! cannot continue!"

... or similar, i don't recall exactly.  funny thing is, if i typed
out the full kernel boot line (which was super annoying for about a
week until i updated to a separate /boot) the system would start up
just fine ... so i don't know if syslinux was checking the incompat
bit or what, but it failed even though the files themselves were
technically ok.

something for others to keep in mind at the least.

C Anthony
