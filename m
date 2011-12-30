From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fstrim on BTRFS
Date: Fri, 30 Dec 2011 13:35:23 +0700
Message-ID: <CAG1y0sdAenG+_jzX19QP_3Kf_79wS-O2s1BGYbmHSSmHbxEwVQ@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
	<CAG1y0scg0vA1jfrp7GX8m9Puh0HJWBNgABHiXqrOuUGgH6p8KQ@mail.gmail.com>
	<4EFC356F.4060904@cn.fujitsu.com>
	<CAG1y0sceqdqqPUQBYEuL-2og=AVFfkEeJksbXyREHNQ5Xy40EQ@mail.gmail.com>
	<4EFD57DC.30502@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Li Zefan <lizf@cn.fujitsu.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFD57DC.30502@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 30, 2011 at 1:19 PM, Li Zefan <lizf@cn.fujitsu.com> wrote:
>> Or would some data
>> block group can be converted to metadata, and vice versa?
>>
>
> This won't happen. Also empty block groups won't be reclaimed, but it's
> in TODO list.

Ah, OK.

6G for metadata out of 50G total seems a bit much, but I can live with
it for now.

Thanks,

Fajar
