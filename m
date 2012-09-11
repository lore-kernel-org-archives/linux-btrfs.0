Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:46244 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751630Ab2IKOUw (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 11 Sep 2012 10:20:52 -0400
Message-ID: <504F48C1.3020603@gmx.net>
Date: Tue, 11 Sep 2012 16:20:49 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Linux Btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Workaround for hardlink count problem?
References: <20120908165620.GA17951@merlins.org> <201209101112.34839.Martin@lichtvoll.de> <CAG1y0scP+O9kTLiF5ZpxRwZTbOFQWctQDquCu4ATSwYyE3SZmQ@mail.gmail.com> (sfid-20120910_140743_108130_BF222C36) <201209110109.17604.Martin@lichtvoll.de> <alpine.LNX.2.01.1209110121050.22773@frira.zrqbmnf.qr>
In-Reply-To: <alpine.LNX.2.01.1209110121050.22773@frira.zrqbmnf.qr>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11.09.2012 01:38, Jan Engelhardt wrote:
> 
> On Tuesday 2012-09-11 01:09, Martin Steigerwald wrote:
>>>> What about:
>>>>
>>>> - copy first backup version
>>>> - btrfs subvol create first next
>>>> - copy next backup version
>>>> - btrfs subvol create previous next
>>>
>>> Wouldn't "btrfs subvolume snapshot", plus "rsync --inplace" more
>>> useful here? That is. if the original hardlink is caused by multiple
>>> versions of backup of the same file.
>>
>> Sure, I meant subvol snapshot in above example. Thanks for noticing.
>>
>> But I do not use --inplace as it conflicts with some other rsync options I 
>> like to use:
> 
> It is a tradeoff.
> 
> rsync "--inplace" leads to fragmentation which is detrimental for the
> speed of reads (and read-write-cycles as used by rsync) of big files
> (multi-GB) that are regularly updated, but it is probably even worse
> for smaller-than-GB files because percent-wise, they are even more
> fragmented.
> 
> $ filefrag */vm/intranet.dsk
> snap-2012-08-15/vm/intranet.dsk: 23 extents found
> snap-2012-08-16/vm/intranet.dsk: 23 extents found
> snap-2012-08-17/vm/intranet.dsk: 4602 extents found
> snap-2012-08-18/vm/intranet.dsk: 6221 extents found
> snap-2012-08-19/vm/intranet.dsk: 6604 extents found
> snap-2012-08-20/vm/intranet.dsk: 6694 extents found
> snap-2012-08-21/vm/intranet.dsk: 6650 extents found
> snap-2012-08-22/vm/intranet.dsk: 6760 extents found
> snap-2012-08-23/vm/intranet.dsk: 7226 extents found
> snap-2012-08-24/vm/intranet.dsk: 7159 extents found
> snap-2012-08-25/vm/intranet.dsk: 7464 extents found
> snap-2012-08-26/vm/intranet.dsk: 7746 extents found
> snap-2012-08-27/vm/intranet.dsk: 8017 extents found
> snap-2012-08-28/vm/intranet.dsk: 8145 extents found
> snap-2012-08-29/vm/intranet.dsk: 8393 extents found
> snap-2012-08-30/vm/intranet.dsk: 8474 extents found
> snap-2012-08-31/vm/intranet.dsk: 9150 extents found
> snap-2012-09-01/vm/intranet.dsk: 8900 extents found
> snap-2012-09-02/vm/intranet.dsk: 9218 extents found
> snap-2012-09-03/vm/intranet.dsk: 9575 extents found
> snap-2012-09-04/vm/intranet.dsk: 9760 extents found
> snap-2012-09-05/vm/intranet.dsk: 9839 extents found
> snap-2012-09-06/vm/intranet.dsk: 9907 extents found
> snap-2012-09-07/vm/intranet.dsk: 10006 extents found
> snap-2012-09-08/vm/intranet.dsk: 10248 extents found
> snap-2012-09-09/vm/intranet.dsk: 10488 extents found
> 
> Without --inplace (prerequisite to use -S) however, it will recreate
> a file if it has been touched. While this easily avoids fragmentation
> (since it won't share any data blocks with the old one), it can take
> up more space with the big files.
> 
>> -ax --acls --xattrs --sparse --hard-links --del --delete-excluded --
> 
> I knew short options would be helpful here: -axAXSH
> (why don't they just become the standard... they are in like almost
> every other rsync invocation I ever had)
> 
>>       -S, --sparse
>>              Try to handle sparse files efficiently so they  take  up
>>              less space on the destination.  Conflicts with --inplace
>>              because it’s not possible to overwrite data in a  sparse
>>              fashion.
> 
> Oh and if anybody from the rsync camp reads it: with hole-punching
> now supported in Linux, there is no reason not to support "-S" with
> "--inplace", I think.

I sent a patch for this quite some time ago:

https://bugzilla.samba.org/show_bug.cgi?id=7194

Feel free to push it :)

-Arne

> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

