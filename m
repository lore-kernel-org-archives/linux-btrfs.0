From: Mitch Harder <mitch.harder@sabayonlinux.org>
Subject: Re: [PATCH v2] btrfs: Remove all sysfs entries
Date: Wed, 15 Jun 2011 10:54:13 -0500
Message-ID: <BANLkTik5TXXBx6tnYiKNs075n9xHq4_zSw@mail.gmail.com>
References: <4DF86FFF.5000406@gmail.com>
	<20110615103431.GA15127@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Hugo Mills <hugo@carfax.org.uk>,
	Maarten Lankhorst <m.b.lankhorst@gmail.com>,
	Chris Mason <chris.mason@oracle.com>,
	linux-btrfs@vger.kernel.org,
	Linux Kernel Mailing List <linux-kern
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110615103431.GA15127@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 15, 2011 at 5:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Wed, Jun 15, 2011 at 10:40:31AM +0200, Maarten Lankhorst wrote:
>> Seems that currently none of the sysfs are created any more, so just
>> remove sysfs support entirely.
>>
>> Fixes compiling warnings in 3.0rc3
>
> =A0 I would actually like to retain sysfs support -- the current
> entries may not be used (or useful, or in the right place, or even
> visible these days), but there's plenty of things that could and
> should go in sysfs from btrfs.
>
> =A0 So, please do remove the unwanted/unused file entries, but could
> you leave the sysfs file itself, and the (limited) bits that create
> the btrfs subdir? Otherwise, I'm going to be putting it all back in
> this weekend when I get the time to revisit Goffredo's old sysfs
> patch...
>
> =A0 Thanks,
> =A0 Hugo.
>
>> Signed-off-by: Maarten Lankhorst <m.b.lankhorst@gmail.com>
>>
>> --
>
> =A0 (I think this should be three - signs, not two: my signature-
> cropping script removed the whole patch)
>

I'm not sure if Goffredo is following this thread, but I think you'll
need a missing patch to provide a fs/btrfs/sysfs.h file in order to
use his sysfs patch.
