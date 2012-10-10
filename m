Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:47139 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab2JJR0X (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 10 Oct 2012 13:26:23 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so478838bkc.19
        for <linux-btrfs@vger.kernel.org>; Wed, 10 Oct 2012 10:26:20 -0700 (PDT)
Message-ID: <5075AFC9.4040109@gmail.com>
Date: Wed, 10 Oct 2012 19:26:33 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>
CC: linux-btrfs@vger.kernel.org, Bart Noordervliet <bart@noordervliet.net>,
        Chris Mason <chris.mason@fusionio.com>,
        Hugo Mills <hugo@carfax.org.uk>, Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com> <20121009135138.GP4405@twin.jikos.cz> <507467F7.1090907@gmail.com> <20121009221508.GX4405@twin.jikos.cz>
In-Reply-To: <20121009221508.GX4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/10/2012 12:15 AM, David Sterba wrote:
> On Tue, Oct 09, 2012 at 08:07:51PM +0200, Goffredo Baroncelli wrote:
[...]
>>> * show the byte units
>> At the beginning it was so. But the space required was greater than 80
>> columns. Moreover the allocation space is in multiply of 4KiB, so showing
>> the number in bytes doesn't add any information. The documentation clearly
>> stated that if -k is passed the units are KiB.
>
> Keeping the line at most 80 sounds reasonable, but if the overflow is
> only because of 4x ' ' or units, we can try to squeeze the empty space
> between columns.

There is no space:

A 64 bit number requires 20 characters;

   $ python -c "print len(str(2<<64))"
   20

The "Chunk_type" and Mode column require 12+8 = 20 characters. So

	20 + 		[Chunk_type+Mode]
	20 +		[Size_(disk)]
	20 +		[Size_(logical)]
	20 +		[Used]
          2 		[spaces between the columns Size(disk)
				<-> Size_(logical> <-> Used]

Requires more than 80 characters. This is the reason to switch to 1k 
unit. the "df" default is the same.

[...]

>>> * Chunk_type ->   Type ?
>> There was another person who made the same proposal. However I don't like
>> it: what mean "type" alone ? We are showing the chunk information.
>
> And the person said "what does chunk mean to the user? it's an
> internal detail." (IIRC). There's also 'type' for the raid profiles,
> ambiguity of the term 'type' will lead us to confusion when we'll talk
> to users. The term 'profile' is AFAIK widely used in the context of
> RAIDs.

Sorry I cannot understand your conclusion... I am not sure if you are 
suggesting to replace 'Mode' with 'Profile' ? Anyway I like it. With 
another ACK I will update it.
Regarding 'Chunk_type', I am open to change it, but I veto 'Type'. Some 
suggestions:
- Allocation_type
- Block_type
- Block
- Allocation_mode
- Area
- Area_type
- Area_mode

>
>>> * Size_(logical) is misaligned with the numbers underneath
>> It is not an error. I did so because the constraint of 80 column when the
>> unit is set to KiB. Otherwise I have to maintain two completely set of
>> printf depending by the unit used.
>> But I have to agree to the fact that it is not very pleasant to read.
>
> Let's fix it.

Fixed

>
>>> * Used (in the summary) is in logical units, I needed to hand calculate
> [snip]
>> I am not against to change but I would like to see other
>> people to support your suggestion.
>>
>>> * revert the order of Min and Max in Free_(Estimated)
> [snip]
>> What this the reasons ? I don't find Max..Min more (or less) reasonable than
>> Min..Max. Again, I am not against your request but I would like to see other
>> people support your suggestion.
>
> Seems that the only way I can get possitive/negative feedback on those
> suggestions is after I send a patch that implements them.

I cannot agree more :-)

>
[...]

>> I maintained df as per Chris request; originally I wanted to call it
>> disk-usage. I renamed the function disk_usage to disk_free as compromise. My
>> opinion is that df should renamed disk-free....
>
> Too long to type, this is a frequent command and part of people's habit,
> I'm completely with Chis here.

Even I was not convinced, I did accept Chris's  suggestion...
[...]

