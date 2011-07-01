From: Li Zefan <lizf@cn.fujitsu.com>
Subject: Re: subvolumes missing from "btrfs subvolume list" output
Date: Fri, 01 Jul 2011 09:08:53 +0800
Message-ID: <4E0D1E25.9060402@cn.fujitsu.com>
References: <chaz20110629143747.GA28702@seebyte.com> <chaz20110629150041.GB28702@seebyte.com> <4E0BC7AA.7000709@cn.fujitsu.com> <chaz20110630084046.GC28702@seebyte.com> <4E0C3F72.5040508@gmail.com> <chaz20110630104340.GD28702@seebyte.com> <20110630105813.GD11170@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: Hugo Mills <hugo@carfax.org.uk>,
	Stephane Chazelas <stephane.chazelas@gmail.com>,
	Andreas Philipp <philipp.andreas@gmail.com>,
	linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110630105813.GD11170@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

>>> Hugo Mills keeps an integration branch with nearly all patches to
>>> btrfs-progs applied.
>>> See
>>>
>>> http://www.spinics.net/lists/linux-btrfs/msg10594.html
>>>
>>> and for the last update
>>>
>>> http://www.spinics.net/lists/linux-btrfs/msg10890.html
>> [...]
>>
>> Thanks.
>>
>> It might be worth adding a link to that to
>> https://btrfs.wiki.kernel.org/index.php/Btrfs_source_repositories
>>
>> Note that it (integration-20110626) doesn't seem to include the fix in
>> http://marc.info/?l=linux-btrfs&m=129238454714319&w=2 though.
> 
>    No, I didn't see it when I did my trawl through the mailing list
> archives, because it wasn't marked as [PATCH]. I'll pull it in for the
> next round of the integration tree, though.
> 

This is my SOB for the patch:

Signed-off-by: Li Zefan <lizf@cn.fujitsu.com>
