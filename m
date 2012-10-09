Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:36010 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2JISHl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 9 Oct 2012 14:07:41 -0400
Received: by mail-bk0-f46.google.com with SMTP id jk13so2824781bkc.19
        for <linux-btrfs@vger.kernel.org>; Tue, 09 Oct 2012 11:07:40 -0700 (PDT)
Message-ID: <507467F7.1090907@gmail.com>
Date: Tue, 09 Oct 2012 20:07:51 +0200
From: Goffredo Baroncelli <kreijack@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, Bart Noordervliet <bart@noordervliet.net>
CC: Chris Mason <chris.mason@fusionio.com>, Hugo Mills <hugo@carfax.org.uk>,
        Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>,
        Ilya Dryomov <idryomov@gmail.com>
Subject: Re: [PATCH][BTRFS-PROGS][V3] btrfs filesystem df
References: <1349371679-10775-1-git-send-email-kreijack@inwind.com> <20121009135138.GP4405@twin.jikos.cz>
In-Reply-To: <20121009135138.GP4405@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi David,

On 10/09/2012 03:51 PM, David Sterba wrote:
> Hi,
>
> I hope I'm not late to the bikeshedding party, I've tried to use the
> proposed version and here are my observations/wishes, and also issues,
> pointed out in the threads, that were not addressed:
>
> * I'd like to re-add the -s -d options in some way that I can choose
>    which sections I'll see; the previous output matches the 'details'
>    section and contains the valuable information for me
>    More flexibility via options will satisfy more users, currently I have
>    no choice than only ignore the summary section, not to say that this
>    consumes half of my terminal


There was several emails about this topic. At the end we find more 
logical to avoid the options. See the thread "[PATCH][BTRFS-PROGS][V3] 
btrfs filesystem df" for the reasons.

> UI details (that make human-parsing of the output more pleasant experience):
>
> * the 'Path' should contain full path, not just the argument that was
>    given (otherwise it's useless)
The reason to put the path in the output is to disambiguation of the 
sections when multiple paths are passed. It was not intended to identify 
the absolute path of an argument.

> * I'm with Hugo that there should be space between numbers and units
I already replayed to Hugo about that: this issue is note related to my 
patches. I used the function "pretty_sizes()", which was made at the 
beginning of the btrfs-progs. I don't want to address your concerns 
(which are  be valid) in this set of patches.

Also because the question is not so simple: Bart suggested to used the 
the SI units (pow of ten) instead the IEC unit (pow of 2); or better we 
could let the user to select different unit....

> * show the byte units
At the beginning it was so. But the space required was greater than 80 
columns. Moreover the allocation space is in multiply of 4KiB, so 
showing the number in bytes doesn't add any information. The 
documentation clearly stated that if -k is passed the units are KiB.

> * the short form for metadata in --mixed filesystem
>    current:  Data+M.data
>    proposed: Data+Meta
I like your proposal, but at this point I don't want to add another 
iteration on this topic until other people ack your proposal.

> * Chunk_type ->  Type ?
There was another person who made the same proposal. However I don't 
like it: what mean "type" alone ? We are showing the chunk information.

> * Size_(logical) is misaligned with the numbers underneath
It is not an error. I did so because the constraint of 80 column when 
the unit is set to KiB. Otherwise I have to maintain two completely set 
of printf depending by the unit used.
But I have to agree to the fact that it is not very pleasant to read.

> * Used (in the summary) is in logical units, I needed to hand calculate
>    the number to find this out -- any idea how to make it more clear?
>    like Used_(logical) similar to size
To me it is natural to evaluate Used against its previous values. To me 
it is logical that the units are the same, but I am sure that it is a 
subjective matter; I am not against to change but I would like to see 
other people to support your suggestion.

> * revert the order of Min and Max in Free_(Estimated)
What this the reasons ? I don't find Max..Min more (or less) reasonable 
than Min..Max. Again, I am not against your request but I would like to 
see other people support your suggestion.

> * in code: function is still named cmd_disk_free
This was already discussed. The reason behind that was that this 
function is not an update of the old one, but a new one. Then the diff 
program collapse the two changes (removing the old one and adding the 
new one). There is no reason to maintain the same name. Several commands 
also have a name different from "its cmd-line name".

I maintained df as per Chris request; originally I wanted to call it 
disk-usage. I renamed the function disk_usage to disk_free as 
compromise. My opinion is that df should renamed disk-free....

> * in code: although you've removed -s -d the getopt string still
>    contains them (but this is not an objection because I want them back :)

This was definitely a my BUG :-)

> Also, I've noticed that you refuse to fix minor things in code that
> you're not touching directly for 'df', but this renders the (much
> needed!) updates to df as only half-finished (IMHO).

Frankly speaking it is a bit un-polite to declare our work (the my one 
and the the ones of the reviewers) to be "half finished". Moreover you 
raised a lot of requests with very few explanations.

I can live with the fact that you don't like my work, but if you want to 
improve the situation you should justify your requests for respect of 
other peoples.

Pay attention that every loop requires time (which is not infinite) so 
at the end we should balance the needing of improvement (everything 
could be improved) with the needing of the patch.

> It's fine to add a
> separate patch to fix up the non-df things. Let's fix it in one go :)
On the basis of my previous reply, I will try to address only the 
getopt() bug, and the alignment of the "Size_(logical)". Due to my time 
limits I will need some day to issue this new patch...

> thanks,
> david
>
> [Sample output for quick reference]
>> $ ./btrfs filesystem df /
>> Path: /
>> Summary:
>>    Disk_size:                 72.57GB
>>    Disk_allocated:            25.10GB
>>    Disk_unallocated:          47.48GB
>>    Logical_size:              23.06GB
>>    Used:                      11.01GB
>>    Free_(Estimated):          55.66GB    (Max: 59.52GB, Min: 35.78GB)
>>    Data_to_disk_ratio:           92 %
>>
>> Details:
>>    Chunk_type  Mode     Size_(disk) Size_(logical)     Used
>>    Data        Single       21.01GB      21.01GB     10.34GB
>>    System      DUP          80.00MB      40.00MB      4.00KB
>>    System      Single        4.00MB       4.00MB        0.00
>>    Metadata    DUP           4.00GB       2.00GB    686.93MB
>>    Metadata    Single        8.00MB       8.00MB        0.00
>>
>> Where:
>>          Disk_size                       ->  sum of sizes of teh disks
>>          Disk_allocated                  ->  sum of chunk sizes
>>          Disk_unallocated                ->  Disk_size - Disk_allocated
>>          Logical_size                    ->  sum of logical area sizes
>>          Used                            ->  logical area used
>>          Free_(Estimated)                ->  on the basis of allocated
>>                                             chunk, an estrapolation of
>>                                             the free space
>>          Data_to_disk_ratio              ->  ration between the space occuped
>>                                             by a chunk and the real space
>>                                             available ( due to duplication
>>                                             and/or RAID level)
>>          Chunk_type                      ->  kind of chunk
>>          Mode                            ->  allocation policy of a chunk
>>          Size_(disk)                     ->  area of disk(s) occuped by the
>>                                             chunk (see it as raw space used)
>>          Size_(logical)                  ->  logical area size of the chunk
>>          Used                            ->  portion of the logical area
>>                                             used by the filesystem
>

