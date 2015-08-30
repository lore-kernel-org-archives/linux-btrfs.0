Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail1.trendhosting.net ([195.8.117.5]:57957 "EHLO
	mail1.trendhosting.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324AbbH3Mbl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 30 Aug 2015 08:31:41 -0400
Message-ID: <55E2F791.80008@pocock.pro>
Date: Sun, 30 Aug 2015 14:31:13 +0200
From: Daniel Pocock <daniel@pocock.pro>
MIME-Version: 1.0
To: "Kok, Auke-jan H" <auke-jan.h.kok@intel.com>
CC: Hugo Mills <hugo@carfax.org.uk>, cwillu <cwillu@cwillu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: (renamed thread) btrfs metrics, free space reporting
References: <4F01BF5D.2070801@pocock.com.au>	<CAE5mzviX5kJ70nG3bLPwE7E3ZjmdQvsKNUbs6XXqVhs+MEeSXw@mail.gmail.com>	<4F01C6DC.3040609@pocock.com.au>	<20120102151422.GA27122@carfax.org.uk>	<4F01DA85.4050107@pocock.com.au>	<20120102163944.GB27122@carfax.org.uk>	<4F043C75.1080204@pocock.com.au> <CABsxX9+J9XvBzV8OEHfKJSaYtB8RziysW4JDtYW75Qje7tt4vQ@mail.gmail.com> <4F0576C3.90502@pocock.com.au>
In-Reply-To: <4F0576C3.90502@pocock.com.au>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 05/01/12 11:09, Daniel Pocock wrote:
> 
>>
>> From there on, one could potentially create a matrix: (proportional
>> font art, apologies):
>>
>>           | subvol1  | subvol2  | subvol3  |
>> ----------+----------+----------+----------+
>>  subvol1  |   200M   |     20M  |     50M  |
>> ----------+----------+----------+----------+
>>  subvol2  |    20M   |    350M  |     22M  |
>> ----------+----------+----------+----------+
>>  subvol3  |    50M   |     22M  |    634M  |
>> ----------+----------+----------+----------+
>>
>> The diagonal obviously shows the "unique" blocks, subvol2 and subvol1
>> share 20M data, etc. Missing from this plot would be "how much is
>> shared between subvol1, subvol2, and subvol3" together, but it's a
>> start and not something that hard to understand. One might add a
>> column for "total size" of each subvol, which may obviously not be an
>> addition of the rest of the columns in this diagram.
>>
>> Anyway, something like this would be high on my list of `df` numbers
>> I'd like to see - since I think they are useful numbers.
>>
> 
> This is an interesting way to look at it
> 
> Ganglia typically records time series data, it is quite conceivable to
> create a metric for every permutation in each and store that in rrdtool
> 
> The challenge would then be in reporting on the data: the rrdtool graphs
> use time as an X-axis, and then it can display multiple Y values
> 
> However, now that I've started thinking about the type of data generated
> from btrfs, I was wondering if some kind of rr3dtool is needed - a 3D
> graphing solution - or potentially making graphs that do not include
> time on any axis?
> 
> Has anyone seen anything similar for administering ZFS, for example?
> 


I just wanted to follow up on this and see if anybody had any more
comments or if the situation has changed?

One other thing that came to mind for me is the idea of letting the
local system administrator define views (similar to views in SQL) and
also nominate which of the views should be used to return values for the
standard df command.

This would allow existing monitoring tools and scripts to continue
getting some data that is considered sensible for a specific context.
