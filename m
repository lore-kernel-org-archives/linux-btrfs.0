From: David Sterba <dave@jikos.cz>
Subject: Re: compression ratio
Date: Mon, 20 Jun 2011 15:46:19 +0200
Message-ID: <20110620134619.GG12709@twin.jikos.cz>
References: <4DFF2F29.4040108@corp.mail.ru>
Reply-To: dave@jikos.cz
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4DFF2F29.4040108@corp.mail.ru>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Mon, Jun 20, 2011 at 03:29:45PM +0400, Proskurin Kirill wrote:
> What we have:
> SL6 - kernel 2.6.32-131.2.1.el6.x86_64
> mdadm RAID5 with 8 HDD - 27T partition.

btw .32 is very old

> Mount options is "noatime,noacl,compress-force"
> I use scribe daemon to copy log files from 200 hosts to that
> partition for stress testing.
> 
> But I found what compression ratio is really small.

It is and it will be due to nature of compression method used and the
constraints given:

* compression has to be fast, only real-time methods can be considered
  which have natural speed/ratio tradeoff
* you're using zlib (lzo was added recently), which is not that fast and
  does not have a great compression ratio
* there is maximum length of compressed data per round, it's hardcoded
  to 128KB by now
* zlib works in streaming mode, which compresses whole 128KB with
  dictionary reused
* lzo (as implemented in btrfs) however does not reuse dictionary and
  compresses each page separately; resulting size is even bigger than it
  would be when full 128KB were compressed

> Partition is full of regular log files - plain text. Most of them a
> big ones(10-20Gb) and they grow in realtime.

Realtime growth should not be a problem.

The situation can be slightly improved if we use a method capable of
streamed compression (ie. dictionary reuse). This is naturally supported
by eg. quicklz and snappy.
There are a few other realtime methods (fastlz, lzrw, lzjb) which may be
extended to support streaming compression, but with careful evaluation
of the result.


david
