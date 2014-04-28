Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44406 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756348AbaD1PBV (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 28 Apr 2014 11:01:21 -0400
Message-ID: <535E6D2C.5080404@redhat.com>
Date: Mon, 28 Apr 2014 10:01:00 -0500
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>, dsterba@suse.cz,
        Justin Maggard <jmaggard10@gmail.com>,
        Daniel Lee <longinus00@gmail.com>, linux-btrfs@vger.kernel.org,
        clm@fb.com
Subject: Re: Which companies are using Btrfs in production?
References: <20140424011834.GN26949@merlins.org> <20140424011952.GO26949@merlins.org> <535912E5.7080106@gmail.com> <CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com> <20140424231456.GW26949@merlins.org> <20140425144704.GC5988@twin.jikos.cz> <20140425152045.GK13819@merlins.org>
In-Reply-To: <20140425152045.GK13819@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 4/25/14, 10:20 AM, Marc MERLIN wrote:
> On Fri, Apr 25, 2014 at 04:47:04PM +0200, David Sterba wrote:
>> On Thu, Apr 24, 2014 at 04:14:56PM -0700, Marc MERLIN wrote:
>>>>> Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
>>>>> They apparently use Oracle's linux distro so I assume they're relying on
>>>>> them to do most of the heavy lifting as far as support BTRFS and
>>>>> backporting goes since they're still on 3.0! They also have raid5/6
>>>>> support so they are probably running BTRFS on top of md.
>>>>>
>>>>
>>>> Yes, and any contributions you see coming from me so far, come from
>>>> NETGEAR.  I've been using my gmail account because I can't make our
>>>
>>> Thanks. 
>>> https://btrfs.wiki.kernel.org/index.php/Contributors
>>> Updated :)
>>
>> There are lots of contributors with the same small amout of patches
>> contributed and are not listed there.  This is first time I hear about
>> Netgear being a contributor and it looks strange to see that name among
>> the major contributors.
>>
>> If there's demand to list all the minor contributors, then let's add a
>> separate section, otherwise I'm going to remove the entry.
> 
> Mmmh. So I'm not Jon Corbet who has all those fancy honed scripts + non
> trivial time he spends doing this by hand.
> 
> That said, my goal was not to say which company gave the most
> contributions and try and rank them.
> Honestly, right now any company that is using btrfs and contributing to
> it is a great thing in my book.
> I'm not even a fan of counting number of lines or frequency of patches.
> How do you compare someone sending easy cleanup patches vs someone who
> spent a month tracking down a file corruption problem no one could find
> nor fix, and sends a 3 line patch to fix it in the end?

Just for the record, I certainly didn't mean that my git patch-counting
example was the be-all and end-all of "contribution accounting" - it's
just one metric of many; not meant to be inclusive, but might help to avoid
missing people or companies who have contributed in this particular way.

-Eric

