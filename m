From: Andrew Dunn <andrew.g.dunn.dod@gmail.com>
Subject: Re: Updating RAID[56] support
Date: Tue, 4 May 2010 10:55:20 -0400
Message-ID: <j2wbfcaab951005040755h1542ad66x757e426b058e0466@mail.gmail.com>
References: <1272564366.3367.4143.camel@macbook.infradead.org>
	 <28824133.321.1272655413702.JavaMail.root@zimbra>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: David Woodhouse <dwmw2@infradead.org>, linux-btrfs@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <28824133.321.1272655413702.JavaMail.root@zimbra>
List-ID: <linux-btrfs.vger.kernel.org>

I am very interested in support for this functionality. I have been
using mdadm for all of my redundant file systems, but it requires I
have homogeneous partitions/drives for a volume. I would very much
like to use a heterogeneous drive structure for a large redundant
volume and have been waiting in anticipation for btrfs to come forth
with this functionality.

On Fri, Apr 30, 2010 at 3:23 PM, Roy Sigurd Karlsbakk <roy@karlsbakk.ne=
t> wrote:
> ----- "David Woodhouse" <dwmw2@infradead.org> skrev:
>
>> I've been looking again at the RAID5/RAID6 support, and updated the
>> tree
>> at git://git.infradead.org/users/dwmw2/btrfs-raid56.git#merged
>>
>> At the moment, we limit writes to a single disk's worth at a time,
>> which
>> means we _always_ do the read-calculateparity-write cycle and suffer
>> the
>> traditional RAID 'write hole' problem.
>
> Out of curiosity, will Btrfs allow for variable block sizes such as w=
ith ZFS?
>
> roy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs=
" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
