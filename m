Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fw11a-158.wadns.net ([196.220.39.158]:63769 "EHLO
	fw11a.wadns.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753182Ab3C0E2I (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 27 Mar 2013 00:28:08 -0400
Message-ID: <51527547.2010007@swiftspirit.co.za>
Date: Wed, 27 Mar 2013 06:27:51 +0200
From: Brendan Hide <brendan@swiftspirit.co.za>
MIME-Version: 1.0
To: Roger Binns <rogerb@rogerbinns.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/5] [RFC] RAID-level terminology change
References: <1362861071-12589-1-git-send-email-hugo@carfax.org.uk> <khgcsi$1k4$1@ger.gmane.org> <20130310014434.GB30771@carfax.org.uk> <khh6er$nmk$1@ger.gmane.org> <20130310220422.GF30771@carfax.org.uk> <khj826$386$1@ger.gmane.org>
In-Reply-To: <khj826$386$1@ger.gmane.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bit late - but that could be explored in future. The main downside I see 
with "automatic" redundancy/optimisation is the complexity it 
introduces. Likely this would be best served with user-space tools.

On 11/03/13 02:21, Roger Binns wrote:
> On 10/03/13 15:04, Hugo Mills wrote:
>> Given that this is going to end up rewriting *all* of the data on the
>> FS,
> Why does all data have to be rewritten?  Why does every piece of data have
> to have exactly the same storage parameters in terms of
> non-redundancy/performance/striping options?
This is a good point. You don't necessarily have to rewrite everything 
all at once so the performance penalty is not necessarily that bad. More 
importantly, some "restripe" operations actually don't need much change 
on-disk (in theory).

Let's say we have disks with 3c chunk allocation and this needs to be 
reallocated into 2c chunks.

In practice at present what would actually happen is that it would first 
create a *new* 2c chunk and migrate the data over from the 3c chunk. 
Once the data is moved across we finally mark the space taken up by the 
original 3c chunk as available for use. Rinse; Repeat.

In theory we can skip this rebalance/migration step by "thinning" out 
the chunks in-place: relabel the chunk as 2c and mark the unneeded 
copies as available diskspace.

A similar situation applies to other types of "conversions" in that they 
could be converted in-place with much less I/O or that the I/O could be 
optimised (for example sequential I/O between disks with minimal 
buffering needed vs moving data between two locations on the same disk). 
I'm sure there are other possibilities for "in-place" conversions too, 
such as moving from 4c to 2c2s or 2c to 2s.

xC -> (x-1)C
xCmS -> (x/2)C(m*2)S

The complexity of the different types of conversions hasn't escaped me, 
and I do see another downside as well. With the 3C->2C conversion there 
is the inevitability of "macro" fragmentation. Again, there could be 
long-term performance implication or it might even be negligible.

-- 
__________
Brendan Hide
http://swiftspirit.co.za/
http://www.webafrica.co.za/?AFF1E97

