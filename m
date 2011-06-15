From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Subject: Re: [PATCH v2] btrfs: Remove all sysfs entries
Date: Wed, 15 Jun 2011 18:02:16 +0200
Message-ID: <4DF8D788.4050105@gmail.com>
References: <4DF86FFF.5000406@gmail.com> <20110615103431.GA15127@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110615103431.GA15127@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

Op 15-06-11 12:34, Hugo Mills schreef:
> On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote:
>> Seems that currently none of the sysfs are created any more, so just
>> remove sysfs support entirely.
>>
>> Fixes compiling warnings in 3.0rc3
>    I would actually like to retain sysfs support -- the current
> entries may not be used (or useful, or in the right place, or even
> visible these days), but there's plenty of things that could and
> should go in sysfs from btrfs.
>
>    So, please do remove the unwanted/unused file entries, but could
> you leave the sysfs file itself, and the (limited) bits that create
> the btrfs subdir? Otherwise, I'm going to be putting it all back in
> this weekend when I get the time to revisit Goffredo's old sysfs
> patch...
Currently sysfs.c is just 2 function calls, rest is unused, so I'll wait then.

Will in_sysfs in struct btrfs_root be used again? Currently it's not
used but only assigned zero.

~Maarten
