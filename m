Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ve0-f180.google.com ([209.85.128.180]:39147 "EHLO
	mail-ve0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157AbaBJSg2 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 10 Feb 2014 13:36:28 -0500
Received: by mail-ve0-f180.google.com with SMTP id db12so5135623veb.25
        for <linux-btrfs@vger.kernel.org>; Mon, 10 Feb 2014 10:36:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <52F91A4A.4080807@fb.com>
References: <52F9014F.6070901@fb.com>
	<20140210170606.GK6490@carfax.org.uk>
	<CAE5mzvgFLfQoaNx1eWB2z_kJW-pe1bFY_3LxDMV9XbtKApo=xw@mail.gmail.com>
	<52F91A4A.4080807@fb.com>
Date: Mon, 10 Feb 2014 12:36:27 -0600
Message-ID: <CAE5mzvhc0FCL81=ajAFyzHK6L1vP2uuQrjf6UfMX-vDxH+-pKQ@mail.gmail.com>
Subject: Re: What to do about df and btrfs fi df
From: cwillu <cwillu@cwillu.com>
To: Josef Bacik <jbacik@fb.com>
Cc: Hugo Mills <hugo@carfax.org.uk>,
        "lin >> linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

IMO, used should definitely include metadata, especially given that we
inline small files.

I can convince myself both that this implies that we should roll it
into b_avail, and that we should go the other way and only report the
actual used number for metadata as well, so I might just plead
insanity here.

On Mon, Feb 10, 2014 at 12:28 PM, Josef Bacik <jbacik@fb.com> wrote:
>
>
> On 02/10/2014 01:24 PM, cwillu wrote:
>>
>> I concur.
>>
>> The regular df data used number should be the amount of space required
>> to hold a backup of that content (assuming that the backup maintains
>> reflinks and compression and so forth).
>>
>> There's no good answer for available space; the statfs syscall isn't
>> rich enough to cover all the bases even in the face of dup metadata
>> and single data (i.e., the common case), and a truly conservative
>> estimate (report based on the highest-usage raid level in use) would
>> report space/2 on that same common case.  "Highest-usage data raid
>> level in use" is probably the best compromise, with a big warning that
>> that many large numbers of small files will not actually fit, posted
>> in some mythical place that users look.
>>
>> I would like to see the information from btrfs fi df and btrfs fi show
>> summarized somewhere (ideally as a new btrfs fi df output), as both
>> sets of numbers are really necessary, or at least have btrfs fi df
>> include the amount of space not allocated to a block group.
>>
>> Re regular df: are we adding space allocated to a block group (raid1,
>> say) but not in actual use in a file as the N/2 space available in the
>> block group, or the N space it takes up on disk?  This probably
>> matters a bit less than it used to, but if it's N/2, that leaves us
>> open to "empty filesystem, 100GB free, write a 80GB file and then
>> delete it, wtf, only 60GB free now?" reporting issues.
>>
>
> The only case we add the actual allocated chunk space is for metadata, for
> data we only add the actual used number.  So say say you write 80gb file and
> then delete it but during the writing we allocated a 1 gig chunk for
> metadata you'll see only 99gb free, make sense?  We could (should?) roll
> this into the b_avail magic and make "used" really only reflect data usage,
> opinions on this?  Thanks,
>
> Josef
