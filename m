From: Thomas Kupper <thomas@kupper.org>
Subject: Re: R: Re: mount command not honoring rootflags passed
Date: Fri, 22 Jan 2010 14:18:49 +0100
Message-ID: <03220294-6494-4E57-A2A2-329454FB2C25@kupper.org>
References: <16366420.67811264163868365.JavaMail.defaultUser@defaultHost>
Mime-Version: 1.0 (Apple Message framework v1077)
Content-Type: text/plain; charset=us-ascii
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>,
	Leszek Ciesielski <skolima@gmail.com>
To: "kreijack@libero.it" <kreijack@libero.it>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <16366420.67811264163868365.JavaMail.defaultUser@defaultHost>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Goffredo,

On 22 Jan 2010, at 13:37, kreijack@libero.it wrote:

> Hi Thomas,
> 
>> ----Messaggio originale----
>> Da: thomas@kupper.org
>> Data: 22/01/2010 10.48
>> A: "Leszek Ciesielski"<skolima@gmail.com>
>> Cc: "linux-btrfs"<linux-btrfs@vger.kernel.org>
>> Ogg: Re: mount command not honoring rootflags passed
>> 
>> 
>> On 22 Jan 2010, at 10:40, Leszek Ciesielski wrote:
>> 
>>> On Fri, Jan 22, 2010 at 10:30 AM, Thomas Kupper <thomas@kupper.org> wrote:
> [...]
>>> Doesn't 'cat /proc/mounts' show the actually used mount options?
>> 
>> No, it doesn't in my case - Ubuntu 9.10 with 2.6.32-10-generic kernel.
>> 
>> thomas # cat /proc/mounts | fgrep ' / '
>> rootfs / rootfs rw 0 0
>> /dev/sda3 / btrfs rw,relatime 0 0
>> 
>> thomas # cat /proc/cmdline
>> [...] root=/dev/sda3 ro rootflags=subvol=rootfs-snapshot-001--
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
> The btrfs code doesn't show the subvol= mount option in cat /proc/mount. I 
> sent a patch which should solve it.
> 
> http://article.gmane.org/gmane.comp.file-systems.btrfs/4487
> 
> But today it is not merged.

Excellent! That was fast, thanks alot. I have to get around how to compile one module only first anyway (the Ubuntu or Debian way).

> Br
> Goffredo

Have a good day,
Thomas