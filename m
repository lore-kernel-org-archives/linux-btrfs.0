Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp209.alice.it ([82.57.200.105]:44983 "EHLO smtp209.alice.it"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480Ab2JCUx4 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 3 Oct 2012 16:53:56 -0400
Message-ID: <506CA5DD.9000808@inwind.it>
Date: Wed, 03 Oct 2012 22:53:49 +0200
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, Ilya Dryomov <idryomov@gmail.com>,
        linux-btrfs@vger.kernel.org, Roman Mamedov <rm@romanrm.ru>,
        =?ISO-8859-1?Q?S=E9bastien_Maury?= <sebastien.maury@inserm.fr>
Subject: Re: [PATCH 1/2] Update btrfs filesystem df command
References: <1349284952-6865-1-git-send-email-kreijack@inwind.com> <1349284952-6865-2-git-send-email-kreijack@inwind.com> <20121003203400.GD2890@zambezi.lan> <20121003203852.GE25498@carfax.org.uk>
In-Reply-To: <20121003203852.GE25498@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/03/2012 10:38 PM, Hugo Mills wrote:
>>> +	if( !(flags&  (DF_SHOW_SUMMARY|DF_SHOW_DETAIL)) ){
>>> >  >  +		fprintf(stderr, "btrfs filesystem df: it is not possible to specify -s AND -d\n");
>> >
>> >  This doesn't look right at all.  You are adding two switches and
>> >  specifying both of them is an error?  A little too much for a command
>> >  whose job is to do some basic math and pretty-print the result.
>> >
>> >  How about displaying just the summary by default and then adding a
>> >  *single*  switch (-v or whatever) for summary+details?
>     I'd prefer to see both sections by default. The reason for this is
> that without both sections, people tend to get confused because they
> don't know they're looking at half the story (e.g. some numbers change
> twice as fast as they think they should).

I agree with Hugo. As default both the section should be showed.

>     I think supplying both options should probably show both sections
> again, and make it not an error to do so, but I'm happy either way.

Because the default is to show both the sections, passing a switch means 
"hide the other section". So passing both the switches means: "hide both 
the sections"...

This is the reason of the check.

I am thinking to remove both the switches... But today is too late...
Now I am seeing a reply by Ilya which reached this same conclusion... 
But today is still to late. Tomorrow I will rearrange the patch...



>
>     Hugo.

Goffredp
