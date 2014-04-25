Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:48939 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419AbaDYPcO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 25 Apr 2014 11:32:14 -0400
Received: by mail-pd0-f170.google.com with SMTP id v10so3270616pde.29
        for <linux-btrfs@vger.kernel.org>; Fri, 25 Apr 2014 08:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20140425152045.GK13819@merlins.org>
References: <20140424011834.GN26949@merlins.org>
	<20140424011952.GO26949@merlins.org>
	<535912E5.7080106@gmail.com>
	<CAKgsxVQcNGUU2Jt3PefwwTodVdy-QzujO69Nrby-BnkYzASY4A@mail.gmail.com>
	<20140424231456.GW26949@merlins.org>
	<20140425144704.GC5988@twin.jikos.cz>
	<20140425152045.GK13819@merlins.org>
Date: Fri, 25 Apr 2014 08:32:13 -0700
Message-ID: <CAN05THQ=X4JdaP+_zP_2UXLCOrZtZgxdxORB+zERS=5qtY5JAQ@mail.gmail.com>
Subject: Re: Which companies are using Btrfs in production?
From: ronnie sahlberg <ronniesahlberg@gmail.com>
To: Marc MERLIN <marc@merlins.org>
Cc: dsterba@suse.cz, Justin Maggard <jmaggard10@gmail.com>,
        Daniel Lee <longinus00@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>, Chris Mason <clm@fb.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 25, 2014 at 8:20 AM, Marc MERLIN <marc@merlins.org> wrote:
> On Fri, Apr 25, 2014 at 04:47:04PM +0200, David Sterba wrote:
>> On Thu, Apr 24, 2014 at 04:14:56PM -0700, Marc MERLIN wrote:
>> > > > Netgear uses BTRFS as the filesystem in their refreshed ReadyNAS line.
>> > > > They apparently use Oracle's linux distro so I assume they're relying on
>> > > > them to do most of the heavy lifting as far as support BTRFS and
>> > > > backporting goes since they're still on 3.0! They also have raid5/6
>> > > > support so they are probably running BTRFS on top of md.
>> > > >
>> > >
>> > > Yes, and any contributions you see coming from me so far, come from
>> > > NETGEAR.  I've been using my gmail account because I can't make our
>> >
>> > Thanks.
>> > https://btrfs.wiki.kernel.org/index.php/Contributors
>> > Updated :)
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
>

+1

For such a small community I think it would be a mistake to have
arbitrary quality or quantity
thresholds for "who deserves to be on the list".

I think you should list everyone. Even if they only sent a single
patch to fix a typo in a comment.
If they sent a patch, then it means they care about the code base and
then they should be on the list.


> But eh, I'm just one guy and and it's just my opinion :)

Me too.



>
> How about we leave that decision with Chris Mason?
>
> Marc
> --
> "A mouse is a device used to point at the xterm you want to type in" - A.S.R.
> Microsoft is to operating systems ....
>                                       .... what McDonalds is to gourmet cooking
> Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
