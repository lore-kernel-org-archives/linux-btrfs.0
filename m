Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:55111 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751187AbaDYPAg (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 11:00:36 -0400
Message-ID: <535A78B2.2040702@fb.com>
Date: Fri, 25 Apr 2014 11:01:06 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: <dsterba@suse.cz>, Marc MERLIN <marc@merlins.org>,
        Justin Maggard <jmaggard10@gmail.com>,
        Daniel Lee <longinus00@gmail.com>, <linux-btrfs@vger.kernel.org>
Subject: Re: Which companies are using Btrfs in production?
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org> <535912E5.7080106@gmail.com> <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com> <20140424231456.GW26949@merlins.org> <20140425144704.GC5988@twin.jikos.cz>
In-Reply-To: <20140425144704.GC5988@twin.jikos.cz>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 04/25/2014 10:47 AM, David Sterba wrote:
> On Thu, Apr 24, 2014 at 04:14:56PM -0700, Marc MERLIN wrote:
>>>> Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
>>>> They apparently use Oracle's linux distro so I assume they're relying on
>>>> them to do most of the heavy lifting as far as support BTRFS and
>>>> backporting goes since they're still on 3.0! They also have raid5/6
>>>> support so they are probably running BTRFS on top of md.
>>>>
>>>
>>> Yes, and any contributions you see coming from me so far, come from
>>> NETGEAR.  I've been using my gmail account because I can't make our
>>
>> Thanks.
>> https://btrfs.wiki.kernel.org/index.php/Contributors
>> Updated :)
>
> There are lots of contributors with the same small amout of patches
> contributed and are not listed there.  This is first time I hear about
> Netgear being a contributor and it looks strange to see that name among
> the major contributors.
>
> If there's demand to list all the minor contributors, then let's add a
> separate section, otherwise I'm going to remove the entry.
>
> This is a sensitive PR topic that I'm normally avoiding, but in this
> case I don't see the amount of contributions that would qualify to the
> "hall of fame".
>

I'm always amazed when I count up the number of people and companies 
sending code in.  There really are too many to list, but every talk I 
give includes a slide trying to give credit the community.

I'd be happy to see people add themselves to a "we're contributors" 
section if they have been part of progs or kernel releases for a year.

Code review, patch submission, and helping users on the list/irc all count.

-chris
