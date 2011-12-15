From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:4754 followed by BUG: unable to handle kernel NULL pointer dereference at (null)
Date: Thu, 15 Dec 2011 05:11:04 +0100
Message-ID: <sj8or8-fqk.ln1@hurikhan.ath.cx>
References: <vhv4r8-hb5.ln1@hurikhan.ath.cx> <4EE0DFEB.2000904@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

Hello,

I managed to mount my broken btrfs partition in read-only mode and clone my 
rootfs subvolume to an ext4 partition and boot from that - so I now have the 
original system bootable.

Jan Schmidt wrote:
> On 07.12.2011 21:40, Kai Krakow wrote:
[...]
>> The problematic file seems to be in /usr/portage but scrubbing doesn't
>> tell me the filename (I was under the impression 3.2.x adds a patch which
>> should report filenames).
> 
> It should. Did you take a look at dmesg output after scrubbing? If it
> doesn't contain a hint on the file or block, please paste what you get.

[  187.136485] device fsid 311dda08-f33f-4cb9-9d59-6eac6026b1b1 devid 2 
transid 146954 /dev/sda3
[  187.136776] btrfs: use lzo compression
[  187.136777] btrfs: disk space caching is enabled
[  190.874110] zcache: created ephemeral tmem pool, id=2, client=65535
[  243.659298] checksum error at logical 622147694592 on dev /dev/sda3, 
sector 301624: metadata leaf (level 0) in tree 2
[  243.659302] checksum error at logical 622147694592 on dev /dev/sda3, 
sector 301624: metadata leaf (level 0) in tree 2
[  243.725126] btrfs: unable to fixup (regular) error at logical 
622147694592
[  306.023952] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  306.023960] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  306.023963] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  306.023966] parent transid verify failed on 622147694592 wanted 130733 
found 134506
[  306.023968] parent transid verify failed on 622147694592 wanted 130733 
found 134506

Here's the last scrub status:

scrub status for 311dda08-f33f-4cb9-9d59-6eac6026b1b1
        scrub started at Sat Dec 10 10:34:57 2011 and was aborted after 2711 
seconds
        total bytes scrubbed: 318.77GB with 3 errors
        error details: read=1 verify=2
        corrected errors: 0, uncorrectable errors: 1, unverified errors: 0

I'm not sure what "read" and "verify" mean in this context.

This happens with 3.2.0-rc4... I'm switching to rc5 soon. But as you (@Jan) 
can see: No file pathes are printed.

Regards,
Kai

