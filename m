From: Arnd Hannemann <arnd@arndnet.de>
Subject: Re: [PATCH] Btrfs-progs: satisfy compiler and change printf modifier
Date: Mon, 14 Nov 2011 16:51:44 +0100
Message-ID: <4EC13910.7050102@arndnet.de>
References: <1321284250-15265-1-git-send-email-arnd@arndnet.de> <CA+qvzFPH8qsdGap4U1rLexMhNzaC8f+HoaqZoGB424OqmS6nTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Cc: linux-btrfs@vger.kernel.org, chris.mason@oracle.com
To: Christian Parpart <trapni@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CA+qvzFPH8qsdGap4U1rLexMhNzaC8f+HoaqZoGB424OqmS6nTQ@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

Am 14.11.2011 16:30, schrieb Christian Parpart:
> On Mon, Nov 14, 2011 at 4:24 PM, Arnd Hannemann <arnd@arndnet.de <mailto:arnd@arndnet.de>> wrote:
> 
>     One-liner which fixes the gcc warning:
>     warning: format '%u' expects argument of type 'unsigned int',
>     but argument 3 has type 'long unsigned int' [-Wformat]
> 
> 
> [snip] 
> 
>     -               printf("Size is %u, needs to be %u, slot %d\n", item_size,
>     +               printf("Size is %u, needs to be %zu, slot %d\n", item_size,
>                           sizeof(*ei), path->slots[0]);
> 
> 
> shouldn't it be %lu then (instead of %zu) ? 

No, the return type of sizeof() is size_t which is of different size on different
architectures (eg. amd64 versus i386)

If %lu would be used, there would be a warning when compiled on an architecture where
long is 32 bit.

Best regards,
Arnd

