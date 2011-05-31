From: Dennis Bergmann <d.bergmann@ftml.net>
Subject: Re: Damaged super block / fs root
Date: Tue, 31 May 2011 10:50:48 +0200
Message-ID: <4DE4ABE8.20902@ftml.net>
References: <4DE3BEFA.7080106@ftml.net> <20110530161216.GA8002@carfax.org.uk> <4DE3CA05.6020709@ftml.net> <1306782166-sup-3731@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Chris Mason <chris.mason@oracle.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1306782166-sup-3731@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

Hello Chris

On 30.05.2011 21:03, Chris Mason wrote:
> How big is the FS?
About 100 G on a  500 G partition. I would only like to recover some 
plain text files from it (source code),
I don't need the partition to be mountable again.

>   What command did you use to overwrite the super
> block?  Please try to tell us exactly which commands were run.
I had to install FreeBSD on that disk (with Linux, a btrfs partition, 
and several free partitions on it).
When using the FreeBSD partition tool, I didn't create or delete any 
partitions. I only assigned a
free partition to FreeBSD. When I booted later in Linux the Btrfs 
partition did not mount anymore.

> There are other ways we can try to pull things off, but you should try
> btrfsck -s 2 as well.
btrfcsk -s 2 exits with:

using SB copy 2, bytenr 274877906944
No valid Btrfs found on /dev/sda10



