From: Ric Wheeler <rwheeler@redhat.com>
Subject: Re: Btrfs: broken file system design (was Unbound(?) internal fragmentation
 in Btrfs)
Date: Sat, 26 Jun 2010 07:55:48 -0400
Message-ID: <4C25EAC4.1040909@redhat.com>
References: <4C07C321.8010000@redhat.com><AANLkTilKw2onQkdNlZjg7WVnPu2dsNpDSvoxrO_FA2z_@mail.gmail.com><4C1B7560.1000806@gmail.com><AANLkTilQm8VGAvc1XNW4EaHd1FLd6dXIXwJ9-yT-joQ8@mail.gmail.com><4C1BA3E5.7020400@gmail.com><20100623234031.GF7058@shareable.org><469D2D911E4BF043BFC8AD32E8E30F5B24AEBA@wdscexbe07.sc.wdc.com> <AANLkTil5Gl0-rWClRsLZby_c37bQu5RB_tCgHsxTFshO@mail.gmail.com> <469D2D911E4BF043BFC8AD32E8E30F5B24AEBB@wdscexbe07.sc.wdc.com> <4C24FC71.6020001@redhat.com> <4C258D91.6010308@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Daniel Taylor <Daniel.Taylor@wdc.com>,
	Mike Fedyk <mfedyk@mikefedyk.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Mat <jackdachef@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
	linux-fsdevel@vger.kernel.org,
	Chris Mason <chris.mason@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	The development of BTRFS <linux-btrfs@vger.kernel.org>
To: Michael Tokarev <mjt@tls.msk.ru>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4C258D91.6010308@msgid.tls.msk.ru>
List-ID: <linux-btrfs.vger.kernel.org>

On 06/26/2010 01:18 AM, Michael Tokarev wrote:
> 25.06.2010 22:58, Ric Wheeler wrote:
>    
>> On 06/24/2010 06:06 PM, Daniel Taylor wrote:
>>      
> []
>    
>>>> On Wed, Jun 23, 2010 at 8:43 PM, Daniel Taylor
>>>> <Daniel.Taylor@wdc.com>   wrote:
>>>>
>>>>          
>>>>> Just an FYI reminder.  The original test (2K files) is utterly
>>>>> pathological for disk drives with 4K physical sectors, such as
>>>>> those now shipping from WD, Seagate, and others.  Some of the
>>>>> SSDs have larger (16K0 or smaller blocks (2K).  There is also
>>>>> the issue of btrfs over RAID (which I know is not entirely
>>>>> sensible, but which will happen).
>>>>>            
> Why it is not sensible to use btrfs on raid devices?
> Nowadays raid is just everywhere, from 'fakeraid' on AHCI to
> large external arrays on iSCSI-attached storage.  Sometimes
> it is nearly imposisble to _not_ use RAID, -- many servers
> comes with a built-in RAID card which can't be turned off or
> disabled.  And hardware raid is faster (at least in theory)
> at least because it puts less load on various system busses.
>
> To many "enterprise folks" a statement "we don't need hw raid,
> we have better solution" sounds like "we're just a toy, don't
> use".
>
> Hmm?  ;)
>
> /mjt, who always used and preferred _software_ raid due to
>   multiple reasons, and never used btrfs so far.
>    

Absolutely no reason that you would not use btrfs on hardware raid 
volumes (or software RAID for that matter).

Ric
