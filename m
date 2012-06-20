Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp207.alice.it ([82.57.200.103]:44518 "EHLO smtp207.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753210Ab2FTSL2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 14:11:28 -0400
Message-ID: <4FE2125A.5080806@libero.it>
Date: Wed, 20 Jun 2012 20:11:38 +0200
From: Goffredo Baroncelli <kreijack@libero.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Calvin Walton <calvin.walton@kepstin.ca>
CC: Alexander Block <ablock84@googlemail.com>, kreijack@inwind.it,
        linux-btrfs@vger.kernel.org, dave@jikos.cz, hch@infradead.org,
        linux-fsdevel@vger.kernel.org, chris.mason@fusionio.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com>  <4FE205CF.9020509@libero.it>  <CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com> <1340215644.6961.12.camel@cwalton-XPS-8300>
In-Reply-To: <1340215644.6961.12.camel@cwalton-XPS-8300>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 08:07 PM, Calvin Walton wrote:
> On Wed, 2012-06-20 at 19:27 +0200, Alexander Block wrote:
>> On Wed, Jun 20, 2012 at 7:18 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>>> Hi Alexander,
>>>
>>> On 06/20/2012 12:35 PM, Alexander Block wrote:
>>>> The patch also does proper vfs mount checks, so cross mount
>>>> point reflinks are not possible with this patch. It only allows cross
>>>> reflinks between two subvolumes which are in the same mount point.
>>>
>>> Thanks for working on that. What happens if two subvolumes of the same
>>> filesystem are mounted on two different places ?
>>>
>>> I usually do:
>>>  mount -o subvol=__active /dev/sdX /
>>>  mount -o subvol=.        /dev/sdX /var/btrfs
>>>
>>> So two different subvolumes of the same filesystem (the one on /dev/sdX)
>>> are mounted on two different places.
>>>
>>> Is it possible to do
>>>  cp --reflink /tmp/foo /var/btrfs/tmp/foo2
>> This will fail with -EXDEV. The patch explicitly forbids reflinks crossing vfs
>> mount boundaries.
> 
> Which means that if I want to do a reflink copy between two separately
> mounted subvolumes, I will have to go and do a third mount with a common
> subvolume above those two, then do the reflink operation within this
> extra mount? This seems slightly impractical.
> 
> Is it any extra code to enable doing cross-mount reflinks? Why was the
> decision made not to allow them?
> 
> Is there some particular opposition to supporting cross-mount operations
> on multiple mounts of the same filesystem in general? (I'd love to have
> rename() work across bind mounts, for example...)

Yes please, could someone explain the reason behind this decision ? May
be there are valid reasons, I am asking only to know which ones ?

