From: Stefan Behrens <sbehrens@giantdisaster.de>
Subject: Re: BTRFS and power loss ~= corruption?
Date: Wed, 09 Nov 2011 18:33:16 +0100
Message-ID: <4EBAB95C.3080607@giantdisaster.de>
References: <4E54F884.9090004@cyberwizzard.nl> <CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Berend Dekens <btrfs@cyberwizzard.nl>, linux-btrfs@vger.kernel.org
To: Gregory Maxwell <gmaxwell@gmail.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <CAAS2fgRfW3J441Xv8x6cnKWyKGao-ZGi4_Od=iB-fLX3YixV5g@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On 8/26/2011 1:01 AM, Gregory Maxwell wrote:
> On Wed, Aug 24, 2011 at 9:11 AM, Berend Dekens <btrfs@cyberwizzard.nl> wrote:
> [snip]
>> I thought the idea of COW was that whatever happens, you can always mount in
>> a semi-consistent state?
> [snip]
> 
> 
> It seems to me that if someone created a block device which recorded
> all write operations a rather excellent test could be constructed
> where a btrfs filesystem is recorded under load and then every partial
> replay is mounted and checked for corruption/data loss.
> 
> This would result in high confidence that no power loss event could
> destroy data given the offered load assuming well behaved
> (non-reordering hardware).  If it recorded barrier operations the a
> tool could also try many (but probably not all) permissible
> reorderings at every truncation offset.
> 
> It seems to me that the existence of this kind of testing is something
> that should be expected of a modern filesystem before it sees
> widescale production use.

Gregory, Thank you for the idea to implement a tool that verifies the
file system consistency.
Following your idea, I have just written a runtime tool for this
purpose, refer to the message-id
<cover.1320849129.git.sbehrens@giantdisaster.de> in the btrfs mailing
list. The tool examines all btrfs disk write operations at runtime. It
verifies that the on-disk data is always in a consistent state, in order
to create confidence that power loss (or kernel panics) cannot cause
corrupted file systems.
