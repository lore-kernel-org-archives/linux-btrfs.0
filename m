From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 11:21:14 +0700
Message-ID: <CAG1y0se+ctBx0YpsCGaW-8TKEN7PZix7PA8Eu-FzfVtkNPkkUQ@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
	<4EFBE668.7030800@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4EFBE668.7030800@cn.fujitsu.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 29, 2011 at 11:02 AM, Li Zefan <lizf@cn.fujitsu.com> wrote:
> Martin Steigerwald wrote:

>> With 3.2-rc4 (probably earlier), Ext4 seems to remember what areas it
>> trimmed:

>> But BTRFS does not:


> There's no such plan, but it's do-able, and I can take care of it.
> There's an issue though.

> For btrfs this issue can't be solved without disk format change that
> will break older kernels, but only 3.2-rcX kernels will be affected if
> we push the following change into mainline before 3.2 release.

Slightly off-topic, how useful would trim be for btrfs when using
newer SSD which have their own garbage collection and wear leveling
(e.g. sandforce-based)?

I'm trying fstrim and my disk is now pegged at write IOPS. Just
wondering if maybe a "btrfs fi balance" would be more useful, since:
- with trim, used space will remain used. Thus future writes will only
utilized space marked as "free", making them wear faster
- with "btrfs fi balance", btrfs will move the data around so (to some
degree) the currently-unused space will be used, and  currently-used
space will be unused, which will improve wear leveling.

-- 
Fajar
