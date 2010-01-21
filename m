From: Thomas Kupper <thomas@kupper.org>
Subject: Re: Ubuntu and btrfs root fs
Date: Thu, 21 Jan 2010 23:40:39 +0100
Message-ID: <4D021FEA-1AC3-489D-9F4C-19B5F75BAE6C@kupper.org>
References: <4A7FF988-4F77-4358-8F47-3DF32289D92F@kupper.org> <201001211935.29285.kreijack@libero.it>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs@vger.kernel.org
To: Goffredo Baroncelli <kreijack@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201001211935.29285.kreijack@libero.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi Goffredo,

On 21 Jan 2010, at 19:35, Goffredo Baroncelli wrote:

> On Thursday 21 January 2010, you (Thomas Kupper) wrote:
>> Hello Goffredo,
>> 
>> I thought maybe email is a more practial way to ask you about it. But if 
> there's a better place in your opinion (mailling list?) let me know.
> 
> I cc'ed the btrfs-mailing list.
> 
> 
> [speaking about a btrfs setup for a root filesystem]
>> 
>> After setting the permissions on the rootfs folder right it boots with my 
> kernel (Hypernation doesn't work although). I did compile the btrfs module 
> into the kernel but would like to use a stock kernel with an updated initrd 
> image.
>> 
>> As you I now additionally installed the 2.6.32-10-generic kernel but tried 
> to use the stock btrfs. But it drops to BusyBox because it can't load the 
> btrfs module ... because of the libcrc32c module can't be loaded. libcrc32c 
> can't be loaded because of a unknown symbol crc32c (of course I added btrfs to 
> the module file of initramfs-tools)
> [...]
> 
> The list of btrfs dependencies is
> 
> $ cat /etc/initramfs-tools/modules
> [..]
> zlib_deflate
> crc32c
> libcrc32c
> btrfs
> 
> 
> I discovered that after a lot of tests...
> 
Now I got working! I summed up two errors, too bad. I was close with the list of modules but forgot to update grub2 (have to do it manually) and I didn't realize that I was booting of an older kernel which I haven't updated the initrd for.
Works great now, thanks a million!

> And for what matters, on my fedora laptop (yes the root fs is btrfs)  the 
> hibernation seems to work; even tough after the resume an error message 
> appeared.
> 
Well, that bit still doesn't work, there's just one line in dmesg:

...
[   1.019071] PM: Resume from disk failed.
...

Have to debug that further, not most critical feature for me since a full boot takes as long as resume on my aging laptop.

>> 
>> Thanks for any advise and have a good day,
>> Thomas
> 
> BR
> G.Baroncelli
> -- 
> gpg key@ keyserver.linux.it: Goffredo Baroncelli (ghigo) <kreijackATinwind.it>
> Key fingerprint = 4769 7E51 5293 D36C 814E  C054 BF04 F161 3DC5 0512

o/
Thomas