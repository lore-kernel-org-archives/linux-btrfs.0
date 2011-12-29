From: "Fajar A. Nugraha" <list@fajar.net>
Subject: Re: fstrim on BTRFS
Date: Thu, 29 Dec 2011 11:42:51 +0700
Message-ID: <CAG1y0se5nXPjMz9FWexr-zN-aFRbFgz_DLDvysYuyu8Hn7fvQg@mail.gmail.com>
References: <201112281757.16019.Martin@lichtvoll.de>
	<4EFBE668.7030800@cn.fujitsu.com>
	<CAG1y0se+ctBx0YpsCGaW-8TKEN7PZix7PA8Eu-FzfVtkNPkkUQ@mail.gmail.com>
	<20111229103736.26a3a07d@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Roman Mamedov <rm@romanrm.ru>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20111229103736.26a3a07d@natsu>
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Dec 29, 2011 at 11:37 AM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Thu, 29 Dec 2011 11:21:14 +0700
> "Fajar A. Nugraha" <list@fajar.net> wrote:
>
>> I'm trying fstrim and my disk is now pegged at write IOPS. Just
>> wondering if maybe a "btrfs fi balance" would be more useful, since:


> Modern controllers (like the SandForce you mentioned) do their own wear leveling 'under the hood', i.e. the same user-visible sectors DO NOT neccessarily map to the same locations on the flash at all times; and introducing 'manual' wear leveling by additional rewriting is not a good idea, it's just going to wear it out more.

I know that modern controllers have their own wear leveling, but AFAIK
they basically:
(1) have reserved a certain size for wear leveling purposes
(2) when a write request comes, they basically use new sectors from
the pool, and put the "old" sectors to the pool (doing garbage
collection like trim/rewrite in the process)
(3) they can't re-use sectors that are currently being used and not
rewritten (e.g. sectors used by OS files)

If (3) is still valid, then the only way to reuse the sectors is by
forcing a rewrite (e.g. using "btrfs fi defrag"). So the question is,
is (3) still valid?

-- 
Fajar
