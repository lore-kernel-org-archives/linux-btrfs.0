Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38718 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754410Ab2FTR1P convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 13:27:15 -0400
MIME-Version: 1.0
In-Reply-To: <4FE205CF.9020509@libero.it>
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>
	<4FE205CF.9020509@libero.it>
Date: Wed, 20 Jun 2012 19:27:14 +0200
Message-ID: <CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com>
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
From: Alexander Block <ablock84@googlemail.com>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, dave@jikos.cz, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, chris.mason@fusionio.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jun 20, 2012 at 7:18 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> Hi Alexander,
>
> On 06/20/2012 12:35 PM, Alexander Block wrote:
>> The patch also does proper vfs mount checks, so cross mount
>> point reflinks are not possible with this patch. It only allows cross
>> reflinks between two subvolumes which are in the same mount point.
>
> Thanks for working on that. What happens if two subvolumes of the same
> filesystem are mounted on two different places ?
>
> I usually do:
>  mount -o subvol=__active /dev/sdX /
>  mount -o subvol=.        /dev/sdX /var/btrfs
>
> So two different subvolumes of the same filesystem (the one on /dev/sdX)
> are mounted on two different places.
>
> Is it possible to do
>  cp --reflink /tmp/foo /var/btrfs/tmp/foo2
This will fail with -EXDEV. The patch explicitly forbids reflinks crossing vfs
mount boundaries.
>
> Thanks
> G.Baroncelli
>
