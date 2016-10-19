Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from kiara-balancer-1.wellbehavedsoftware.com ([138.201.134.108]:45986
        "EHLO kiara-balancer-1.wellbehavedsoftware.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754904AbcJSXrB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 19 Oct 2016 19:47:01 -0400
From: James Pharaoh <james@pharaoh.uk>
Subject: Re: Rust library for BTRFS
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <2636de69-cd94-1700-f589-9f0c981bbac2@pharaoh.uk>
 <1c974452-3523-d91e-1149-a55986276c7f@mendix.com>
Message-ID: <c39a15dc-622e-a30d-96e8-46871fa0dc52@pharaoh.uk>
Date: Thu, 20 Oct 2016 00:46:38 +0100
MIME-Version: 1.0
In-Reply-To: <1c974452-3523-d91e-1149-a55986276c7f@mendix.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 15/10/16 19:41, Hans van Kranenburg wrote:
> On 10/15/2016 04:31 PM, James Pharaoh wrote:
  >>
>> I've basically reimplemented what I find in other tools because, as far
>> as I can tell, there is no C library for BTRFS at this point.
>
> For code operating on an online filesystem, using the IOCTLs, you don't
> really need a lot from btrfs-progs. You need to known about some structs
> and throw them back and forth to the kernel. And not being afraid of
> doing some reverse engineering helps. :o)

Yeah I've managed fine so far. I feel like someone needs to split out 
this library, really, but I'm not particularly interested into doing C 
dev myself, except when it's necessary to interface with something.

> The btrfs-progs programs operate in two ways:
> 1. Using the IOCTLs, implementing a command/args input model and
> converting the output back to text on the console.
> 2. Also directly doing low-level plumbing, reading and writing inside
> unmounted btrfs filesystems. For this, there's a copy of a bunch of code
> from the kernel, to be able to read/write a filesystem that is not
> mounted from the running program, in a similar way that kernel does when
> it's live. If you don't plan to write your own btrfs check --repair,
> this is also not what you need to import as a library.

I have realised this as well. If I understand correctly, and this is one 
of the things I find most interesting about BTRFS, is that it has a kind 
of "microkernel" approach to managing it's on-disk data structures, 
where a small, well-tested core of code manages some basic storage, and 
advanced features are built on top of this.

As I understand it, the tools are able to simply read these data 
structures directly from the disk, presumably after acquiring some kind 
of "read lock" from the kernel, which is sufficient because I believe 
BTFRS is COW at a low level, so with a read lock on the "committed root" 
you are looking at, there is a guarantee all the data structures inside 
it will be valid.

Any confirmation or comment on this would be appreciated, I am planning 
to delve in further soon with my current efforts..

> This might be interesting:
> https://patchwork.kernel.org/patch/9356749/

Will take a look...

> But, I'm not the C expert here, this is what I know.
>
>> The currently supported functions are:
>>
>> - Deduplication
>> - File system info
>> - Space info
>
> Is there a specific use case you're building this for?

I am building a dense hosting platform, a kind of alternative-to-cloud 
solution which acts/looks much more like traditional hosting, but with 
immensely better backups and space efficiency.

I am also using zbackup as a way to store a LOT of similar builds of 
entire containers (ie entire operating systems minus the kernel which is 
shared), storing them efficiently, and deploying them efficiently.

> My primary trigger to start on it is best described as: "Tired of
> parsing the output of btrfs <foo> <bar>? Try this!"
>
> Also, if you're using IRC, #btrfs on freenode is a good place to hang out.

I have tried this but often don't get a response. I feel IRC is a bit 
packed these days and people go for the easy answers and ignore the more 
in depth ones...

Nevertheless, I've exchanged several emails with the author of ZBackup 
and have a list of issues/feature requests/suggestions which I will be 
adding to github and opening for discussion on the mailing list very soon.

> Have fun,

Always!

James
