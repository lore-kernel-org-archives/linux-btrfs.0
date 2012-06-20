Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp208.alice.it ([82.57.200.104]:56870 "EHLO smtp208.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754408Ab2FTUPY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 20 Jun 2012 16:15:24 -0400
Message-ID: <4FE22F64.3010101@inwind.it>
Date: Wed, 20 Jun 2012 22:15:32 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Alexander Block <ablock84@googlemail.com>
CC: Calvin Walton <calvin.walton@kepstin.ca>, linux-btrfs@vger.kernel.org,
        dave@jikos.cz, hch@infradead.org, linux-fsdevel@vger.kernel.org,
        chris.mason@fusionio.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Allow cross subvolume reflinks (2nd attempt)
References: <1340188512-5761-1-git-send-email-ablock84@googlemail.com> <4FE205CF.9020509@libero.it> <CAB9VWqB8z_faPNRJo8+9JWsQFDe507iTxwQK4sctUYGF9zCL4Q@mail.gmail.com> <1340215644.6961.12.camel@cwalton-XPS-8300> <4FE2125A.5080806@libero.it> <CAB9VWqAF5QS6BppN7Xei6JGsDU9ThBpcipk4r=PCwzu8c2AKgQ@mail.gmail.com>
In-Reply-To: <CAB9VWqAF5QS6BppN7Xei6JGsDU9ThBpcipk4r=PCwzu8c2AKgQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/20/2012 10:05 PM, Alexander Block wrote:
> On Wed, Jun 20, 2012 at 8:11 PM, Goffredo Baroncelli <kreijack@libero.it> wrote:
>>
>> Yes please, could someone explain the reason behind this decision ? May
>> be there are valid reasons, I am asking only to know which ones ?
>>
> The reason is that at the moment no user visible operations span mount
> boundaries
> and there were discussion on whether this should be allowed for the
> clone ioctl or
> not. 

Yes, I understood the same. But nobody was able to explain why .

For the moment, I would already be happy to have cross subvolume reflinks
> which do not span mount points, this would already be much more as we have at
> the moment.

This is reasonable.

> .
> 

