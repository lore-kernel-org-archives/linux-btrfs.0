From: Goffredo Baroncelli <kreijack@gmail.com>
Subject: Re: Ubuntu and btrfs root fs
Date: Thu, 21 Jan 2010 19:35:28 +0100
Message-ID: <201001211935.29285.kreijack@libero.it>
References: <4A7FF988-4F77-4358-8F47-3DF32289D92F@kupper.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Cc: linux-btrfs@vger.kernel.org
To: Thomas Kupper <thomas@kupper.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4A7FF988-4F77-4358-8F47-3DF32289D92F@kupper.org>
List-ID: <linux-btrfs.vger.kernel.org>

On Thursday 21 January 2010, you (Thomas Kupper) wrote:
> Hello Goffredo,
> 
> I thought maybe email is a more practial way to ask you about it. But if 
there's a better place in your opinion (mailling list?) let me know.

I cc'ed the btrfs-mailing list.


[speaking about a btrfs setup for a root filesystem]
> 
> After setting the permissions on the rootfs folder right it boots with my 
kernel (Hypernation doesn't work although). I did compile the btrfs module 
into the kernel but would like to use a stock kernel with an updated initrd 
image.
> 
> As you I now additionally installed the 2.6.32-10-generic kernel but tried 
to use the stock btrfs. But it drops to BusyBox because it can't load the 
btrfs module ... because of the libcrc32c module can't be loaded. libcrc32c 
can't be loaded because of a unknown symbol crc32c (of course I added btrfs to 
the module file of initramfs-tools)
[...]

The list of btrfs dependencies is

$ cat /etc/initramfs-tools/modules
[..]
zlib_deflate
crc32c
libcrc32c
btrfs


I discovered that after a lot of tests...

And for what matters, on my fedora laptop (yes the root fs is btrfs)  the 
hibernation seems to work; even tough after the resume an error message 
appeared.

> 
> Thanks for any advise and have a good day,
> Thomas

BR
G.Baroncelli
-- 
gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512
