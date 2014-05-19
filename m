Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([59.151.112.132]:62511 "EHLO
	heian.cn.fujitsu.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752431AbaESBdG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 18 May 2014 21:33:06 -0400
Message-ID: <537951B4.2060407@cn.fujitsu.com>
Date: Mon, 19 May 2014 08:35:00 +0800
From: Qu Wenruo <quwenruo@cn.fujitsu.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, <dsterba@suse.cz>,
        <linux-btrfs@vger.kernel.org>, <clm@fb.com>
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
 page for each btrfs subcommand.
References: <1396427378-10487-1-git-send-email-quwenruo@cn.fujitsu.com> <20140416171219.GC29256@twin.jikos.cz> <20140517174315.GC2537@carfax.org.uk> <20140517182236.GD2537@carfax.org.uk> <53785B81.1080901@cn.fujitsu.com> <20140518120514.GB5783@carfax.org.uk>
In-Reply-To: <20140518120514.GB5783@carfax.org.uk>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


-------- Original Message --------
Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and 
man page for each btrfs subcommand.
From: Hugo Mills <hugo@carfax.org.uk>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Date: 2014年05月18日 20:05
> On Sun, May 18, 2014 at 03:04:33PM +0800, Qu Wenruo wrote:
>> -------- Original Message --------
>> Subject: Re: [PATCH 00/27] Replace the old man page with asciidoc and man
>> page for each btrfs subcommand.
>> From: Hugo Mills <hugo@carfax.org.uk>
>> To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
>> linux-btrfs@vger.kernel.org, clm@fb.com
>> Date: 2014年05月18日 02:22
>>> On Sat, May 17, 2014 at 06:43:15PM +0100, Hugo Mills wrote:
>>>> On Wed, Apr 16, 2014 at 07:12:19PM +0200, David Sterba wrote:
>>>>> On Wed, Apr 02, 2014 at 04:29:11PM +0800, Qu Wenruo wrote:
>>>>>> Convert the old btrfs man pages to new asciidoc and split the huge
>>>>>> btrfs man page into subcommand man page.
>>>>> I'm merging this patchset into the base series of integration because
>>>>> several patches need to update the docs and it's no longer feasible to
>>>>> keep it in a separate branch from the patches.
>>>>     I've just been poking around in the docs for a completely different
>>>> reason, and I think there's a fairly serious problem (well, as serious
>>>> as problems get with documentation).
>>>>
>>>>     Take, for example, the format for btrfs fi resize:
>>>>
>>>> 'resize' [devid:][+/-]<size>[gkm]|[devid:]max <path>::
>>>>
>>>>     Now, this has just thrown away all of the useful markup which
>>>> indicates the semantics of the command. The asciidoc renders all of
>>>> that text literally and unformatted, making alphasymbolic(*) soup of
>>>> the docs. Compare this to the old roff man page:
>>>>
>>>> \fBbtrfs\fP \fBfilesystem resize\fP [\fIdevid\fP:][+/\-]\fI<size>\fP[gkm]|[\fIdevid\fP:]\fImax <path>\fP
>>>>
>>>>     This isn't perfect -- we're missing a \fB around the "max" -- but
>>>> it has text in bold(⁑) and italics(⁂) and neither(☃). I've just looked
>>>> at some of the other pages, and they've also got similar typographical
>>>> problems. This is a lot of fiddly tedious work to get it right, and if
>>>> it doesn't get done now in the initial commit, then we're going to end
>>>> up with poor examples copied for every new feature or docs update,
>>>> making the problem worse before anyone does the work to make it
>>>> better.
>>>     Oh, and asciidoc appears to be the most horrible capricious
>>> inconsistent parser in existence. I've just spent 5 minutes getting
>>> this one line of text to do what I want it to:
>>>
>>> =====
>>> __N__**c**[\[_Mmin_**-**]__Mmax__**s**[_P_**p**]]
>>> =====
>>>
>>>     I had to run through the list of block quote operators one at a
>>> time in order to find the one I needed for this (the =====); it's
>>> still not indenting it correctly on the resulting man page.
>>>
>>>     Note also the fun things like the fact that [[]] is special, so you
>>> have to quote the opening part of it -- but if you try quoting the
>>> first [ with a \ you get a literal \[ in the output. You get the right
>>> output from quoting the *second* [ only.
>> I have already encountered problems like that, especially when convert
>> 'btrfs-resize' related things.
>>
>> But wait for a minute, do we really need the *fascinating* highlight things
>> in a user documentation?
>     Yes, absolutely. The formatting is a part of the _meaning_ of the
> documentation. Otherwise you're left guessing as to which pieces of
> the string of characters are meant to be there literally, and which
> pieces have to be replaced by suitable text, and which pieces are
> optional.
>
>> The most important thing is the content not the format.
>     My point is that in this case the formatting _is_ a part of the
> content.
>
>> I choose asciidoc to make developers take less effort on the format things,
>> not the opposite.
>> In this point of view, I think asciidoc does things considerately well.
>>
>> Although the problem you mentioned is true, but it only affects a small part
>> of the documentation,
>> compared to the overall benefits, I still consider converting to asciidoc is
>> worthy.
>     I'm finding it almost impossible to make it do what I want. I think
> in some cases it actually _is_ impossible. This is a truly frustrating
> tool that is really not making things simpler, and I can see is going
> to lead to even more badly marked up documentation -- simply because
> it's too difficult and frustrating to get it right.
>
>>>     The Nc can only be italicised and emboldened properly with __ and
>>> ** because _ and * require whitespace around them in order to work
>>> (seriously, WTF?). However, we can't be consistent with that in the
>>> _Mmin_**-** because the quoted \[ appears to count as whitespace, so
>>> using __Mmin__ gives us a leading literal _. The closing __ appears to
>>> close the single opening _ correctly in that case, though.
>>>
>>>     Seriously, this is meant to be _easy_ to use? I think I'd rather
>>> type docbook by hand that have to struggle with this. Even the troff
>>> macros for man pages are simpler to get right.
>>  From the purpose of documentation and the above explaination, I think the
>> answer is *Yes*.
>     Only if you don't care about the typography of the resulting document.
Since you seems really unhappy with the git documentation style, I have 
nothing else to say.
I recommended you to send your opinion to git mail list and see what 
they respond.

I think it is now upon David to make the decision.

Thanks,
Qu.
>
>> If you really think there is a better choice, I will be very happy
>> to listen, but please consider what I mentioned above and the
>> privious mail first.
>     I don't have any real suggestions for alternatives coming from my
> experience, other than "not this". I've used docbook for man pages
> briefly, many years ago. Looking around on the web, reStructuredText
> might be a good option. Personally, I'd like to write docs in LaTeX,
> but I'm not sure how easy it is to convert that to man pages.
>
>     Hugo.
>

