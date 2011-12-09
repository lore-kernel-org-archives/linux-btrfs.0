From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: WARNING: at fs/btrfs/extent-tree.c:4754 followed by BUG: unable
 to handle kernel NULL pointer dereference at (null)
Date: Fri, 9 Dec 2011 14:34:07 +0100
Message-ID: <CAMthOuPdU_h+XOYiBBU8M=qMRSBHCLmrEi9Ty=XJzO0jhCKb0Q@mail.gmail.com>
References: <vhv4r8-hb5.ln1@hurikhan.ath.cx>
	<4EE0DFEB.2000904@jan-o-sch.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: linux-btrfs@vger.kernel.org
To: Jan Schmidt <list.btrfs@jan-o-sch.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EE0DFEB.2000904@jan-o-sch.net>
List-ID: <linux-btrfs.vger.kernel.org>

Hello!

2011/12/8 Jan Schmidt <list.btrfs@jan-o-sch.net>:
> On 07.12.2011 21:40, Kai Krakow wrote:
[...]
>> The problematic file seems to be in /usr/portage but scrubbing doesn't tell
>> me the filename (I was under the impression 3.2.x adds a patch which should
>> report filenames).
>
> It should. Did you take a look at dmesg output after scrubbing? If it
> doesn't contain a hint on the file or block, please paste what you get.

I watched dmesg while scrubbing. Nothing there. To paste what I got I
need to find a way to make my 3.2-rc4 system boot again (without
freezing to due services and background jobs touching certain parts of
the broken filesystem) or create a 3.2 rescue system...

>> Everytime I run "emerge" (it is a gentoo system) my
>> screen goes black after a few seconds and I can only revert to using ssh.
>>
>> Problem is: As soon as this happens, some filesystem accesses block the
>> process in disk state, it cannot be killed. This initiates some feedback
>> loop: From now on any other process trying to access the FS freezes. I can
>> only reisub now. It seems to be fine if data comes from cache instead from
>> disk.
>
> Please try to grab sysrq+w output in this state.

I tried, nothing there. I wondered, why... This changed between 3.1
and 3.2. There is probably no blocking process because it got killed
by the kernel. Next process accessing the filesystem blocks (gets not
killed). I try to get a sysrq+w from this situation via ssh to
copy&paste dmesg somewhere but it will be difficult because usually
ssh communication freezes, too.

Maybe related: When the system was still running I was sometimes
seeing it use 100% CPU on one or two cores, looking at "top" I could
not see a process or kernel thread using the CPU but I saw the CPU
usage distributing on SYS%, WA% and USER%... This effect could only be
resolved by rebooting. It can be seen in both kernel 3.1 and 3.2, but
3.2 with much lower likelihood. However, even nice'd processes were
still able to acquire 100% cpu usage per core, so it didn't have any
effect on system performance.

I think I even made my situation worse... In an attempt to get the
error fixed, I deleted and recreated the subvolume with /usr/portage
(content is easily restorable from the internet). On next reboot the
btrfs cleaner kernel thread spit out a lot of errors and traces into
dmesg, system froze some minutes later so I couldn't save the output.
Now I cannot reliably boot and btrfs has problems accessing files all
over the filesystem, even in subvolumes that worked fine before. I
thought subvolumes are clearly separated from each other? Now I have
at least 3 different classes of error messages instead of only 1
single error.

Josef's repair program fails an assertion and cannot continue on the volume.

I think in order to stabilize btrfs it is important to make it handle
structure errors gracefully, and then invest into some repair utility.
I'd like to contribute but at some point in time I will need to get my
system back into a stable state and will recreate my filesystem from
scratch. Mounting the fs read-only allows me to access all parts of
the filesystem without problems. I still see errors in dmesg but no
kernel bugs or warnings with traces.

Regards,
Kai
