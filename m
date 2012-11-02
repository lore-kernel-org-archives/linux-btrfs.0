Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:60826 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758026Ab2KBXer (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 2 Nov 2012 19:34:47 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1TUQlI-0005TR-UM
	for linux-btrfs@vger.kernel.org; Sat, 03 Nov 2012 00:34:52 +0100
Received: from pro75-5-88-162-203-35.fbx.proxad.net ([88.162.203.35])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 00:34:52 +0100
Received: from g2p.code by pro75-5-88-162-203-35.fbx.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Sat, 03 Nov 2012 00:34:52 +0100
To: linux-btrfs@vger.kernel.org
From: Gabriel <g2p.code@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS] Enhance btrfs fi df
Date: Fri, 2 Nov 2012 23:34:33 +0000 (UTC)
Message-ID: <k71la9$7go$4@ger.gmane.org>
References: <1351851339-19150-1-git-send-email-kreijack@inwind.it>
	<201211021218.29778.Martin@lichtvoll.de> <5093B658.3000007@gmail.com>
	<k715i0$7go$1@ger.gmane.org> <50941FAC.1010803@gmail.com>
	<k71b30$7go$2@ger.gmane.org> <20121102214635.GN2297@yeono.kjorling.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 02 Nov 2012 21:46:35 +0000, Michael Kjörling wrote:
> On 2 Nov 2012 20:40 +0000, from g2p.code@gmail.com (Gabriel):
>> Now that I've started bikeshedding, here is something that I would
>> find pretty much ideal:
>> 
>>             Data    Metadata           System             Unallocated              
>> 
>> VolGroup/Btrfs
>>   Reserved   1.31TB 8.00MB + 2×28.00GB 16.00MB + 2×4.00MB           -
>>   Used       1.31TB          2× 5.65GB         2×152.00KB           
>>             ======= ================== ================== ===========
>> Total
>>   Reserved   1.31TB            56.00GB            24.00MB           -
>>   Used       1.31TB            11.30GB           304.00KB           
>>   Free      12.34GB            44.70GB            23.70MB           -
> 
> If we can take such liberties, then why bother with the 2× at all?

It does save a line.

> Also, I think the "B" can go, since it's implied by talking about
> storage capacities. A lot of tools do this already; look at GNU "df -h"
> and "ls -lh" for just two examples. That gives you a few extra columns
> which can be used to make the table column spacing a little bigger even
> in an 80-column terminal.

Good idea.

> I'm _guessing_ that you meant for metadata reserved to be 2 × 28 GB and
> not 2 × 28 MB, because otherwise the numbers really don't add up.

Feh, that's just a typo from when I swapped the 8.00M to the left.

>               Data    Metadata        System            Unallocated
> 
> VolGroup/Btrfs
>   Reserved      1.31T  8.00M + 28.00G  16.00M +   4.00M            -
>    ResRedun         -          28.00G             4.00M            -
>   Used          1.31T           5.65G           152.00K            -
>    UseRedun         -           5.65G           152.00K            -
>               =======  ==============  ================  ===========
> Total
>   Reserved      1.31T          56.01G            24.00M            -
>   Used          1.31T          11.30G           304.00K            -
>   Free         12.34G          44.71G            23.70M            -
> 
> This way, the numbers should add up nicely. ("Redun" for "redundancy" or
> something like that.) 8M + 28G + 28G = 56.01G, 5.65G + 5.65G = 11.30G,
> 56.01G - 11.30G = 44.71G. I'm not sure you couldn't even work 8.00M +
> 28.00G into a single 28.01G entry at Reserved/Metadata, with
> ResRedun/Metadata 28.00G. That would require some care when the units
> are different enough that the difference doesn't show up in the numbers,
> though, since then there is nothing to indicate that parts of the
> metadata is not stored in a redundant fashion.

I tried to work out DUP vs RAID redundancy in my message to Hugo.

> If some redundancy scheme (RAID 5?) uses an oddball factor, that can
> still easily be expressed in a view like the above simply by displaying
> the user data and redundancy data separately, in exactly the same way.
> 
> And personally, I feel that a summary view like this, for Data, if an
> exact number cannot be calculated, should display the _minimum amount of
> available free space_, with "free space" being _usable by user files_.
> If I start copying a 12.0GB file onto the file system exemplified above,
> I most assuredly _don't_ want to get a report of "device full" after 10
> GB! ("You mating female dog, you told me I had 12.3 GB free, wrote 10 GB
> and now you're saying there's NO free space?! To hell with this, I'm
> switching to Windows!") That also saves this tool from having to take
> into account possible compression ratios for when file system level
> compression is enabled, savings from possible deduplication of data, etc
> etc. Of course it also means that the amount of free space may shrink by
> less than the size of the added data, but hey, that's a nice bonus if
> your disk grows bigger as you add more data to it. :-)

I think we can guarantee minimum amounts of free space, as long as
data/metadata/system are segregated properly?
OK, reshapes complicate this. For those we could to take the worst
case between now and the completed reshape.
Or maybe add a second tally:

devices
===
total
 reserved
 used
 free
===
anticipated (reshaped 8% eta 3:12)
 reserved
 used
 free

>> I suggest cutting out the /dev and putting a line break after the
>> name. The extra info makes it more human-friendly, and the line
>> break may complicate machine parsing but the non-tabular format is
>> better at that anyway.
> 
> That might work well for anything under /dev, but what about things that
> aren't?

Absolute path for those, assuming it ever happens.

> And I stand by my earlier position that the tabular data
> shouldn't be machine-parsed anyway. As you say, the non-tabular format
> is better for that.

