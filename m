From: youagree <n3ocort3x@gmail.com>
Subject: Re: Rename BTRfs to MuchSlowerFS ?
Date: Thu, 08 Sep 2011 09:04:25 +0200
Message-ID: <j49p85$f41$1@dough.gmane.org>
References: <4E64F77B.1090401@wpkg.org> <20110905162521.GA29124@infradead.org> <20110905162944.GQ9907@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20110905162944.GQ9907@carfax.org.uk>
List-ID: <linux-btrfs.vger.kernel.org>

On 09/05/2011 06:29 PM, Hugo Mills wrote:
> On Mon, Sep 05, 2011 at 12:25:21PM -0400, Christoph Hellwig wrote:
>> On Mon, Sep 05, 2011 at 06:23:23PM +0200, Tomasz Chmielewski wrote:
>>>>   That's because dpkg is known for using (f)sync very heavily.  btrfs
>>>> honours the sync request in all cases, so it's much much slower than
>>>> ext3, which doesn't.
>>>
>>> Hmm, is it really the case with ext3/ext4 (ignoring fsync in some cases)?
>>>
>>> Sounds like a bug in ext3/ext4 then.
>>>
>>> Is it documented anywhere where ext3/ext4 would just silently ignore fsync?
>>
>> They don't.  Unteil recently ext3 and reiserfs would not flush the
>> disk caches unless enabled by a mount option, but even that has recently
>> been fixed.
> 
>    Apologies for disseminating my misunderstanding, then.
> 
>    Hugo.
> 

I'm wondering if this may be the very same unacceptable behavior as
discussed earlier also in the following message threads:

btrfs always writes something after sync
news://news.gmane.org:119/CABVOS09hntXYUsCJBg+byEGC5y53j4DeT6b49Rx1AaRpqFV54A@mail.gmail.com

Re: Writes in idle/How to debug filesystem activity
news://news.gmane.org:119/4E5C8A20.7030604@wpkg.org

Re: Applications using fsync cause hangs for several seconds every few
minutes
news://news.gmane.org:119/4E41A6A4.9070702@uvm.edu

Btrfs slowdown
news://news.gmane.org:119/CAO47_-9BLKWUGDEuzaLqHSq9tZkAUaO8FMQEy1pPk9A2Hb+5AQ@mail.gmail.com

PLEASE TEST: Everybody who is seeing weird and long hangs
news://news.gmane.org:119/4E36C47E.70309@redhat.com

and this:

curious writes on mounted, not used btrfs filesystem
http://thread.gmane.org/gmane.comp.file-systems.btrfs/10840

and probably this:

2.6.37: Multi-second I/O latency while untarring
http://www.spinics.net/lists/linux-btrfs/msg08516.html


Hasn't the slowdown been fixed yet?
For those experiencing the slowdown issue btrfs is entirely useless...
(I had to stop using btrfs because of these frequent slowdowns, while
btrfs was doing most likely needless disk writes for multiple seconds, I
couldn't work at all)

Can someone look into this if this is not fixed? There are numerous
analysis reports in the above threads, without any constructive result.

Thanks

