Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:36253 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbcCHV21 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 16:28:27 -0500
Received: by mail-ig0-f179.google.com with SMTP id vs8so58252258igb.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Mar 2016 13:28:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160308195857.GB26981@localhost.localdomain>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
	<20160308195857.GB26981@localhost.localdomain>
Date: Tue, 8 Mar 2016 14:28:25 -0700
Message-ID: <CAJCQCtSp5B=nnpCs3zaCsMK+8qLNLzYQAqka5P1X+a+R4RzGOQ@mail.gmail.com>
Subject: Re: btrfs and containers
From: Chris Murphy <lists@colorremedies.com>
To: bo.li.liu@oracle.com
Cc: Chris Murphy <lists@colorremedies.com>,
        Tobias Hunger <tobias.hunger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 8, 2016 at 12:58 PM, Liu Bo <bo.li.liu@oracle.com> wrote:
> On Mon, Mar 07, 2016 at 04:45:09PM -0700, Chris Murphy wrote:
>> On Mon, Mar 7, 2016 at 3:55 PM, Tobias Hunger <tobias.hunger@gmail.com> wrote:
>> > Hi,
>> >
>> > I have been running systemd-nspawn containers on top of a btrfs
>> > filesystem for a while now.
>> >
>> > This works great: Snapshots are a huge help to manage containers!
>> >
>> > But today I ran btrfs subvol list . *inside* a container. To my
>> > surprise I got a list of *all* subvolumes on that drive. That is
>> > basically a complete list of containers running on the machine. I do
>> > not want to have that kind of information exposed to my containers.
>> >
>> > Is there a way to stop btrfs from listing subvolumes "above" the
>> > current location? So that "btrfs subvol list /" in a container will
>> > only show subvolumes that are set up in the container?
>
> That's a good question.
>
> Looks like that "btrfs subvolume list -o" match the needs here.
>
>>
>> I'm not sure whether this is something that goes in Btrfs proper,
>> since this is presumably a privileged container? The same thing
>> happens with Docker containers. One way to do this is if it's not
>> privileged, as non-root can't list subvolumes. I think some work is
>> needed to make it possible for users to list subvolumes they own.
>> Right now a user can create a subvolume but then now list or get
>> information on it. By default they can't delete it either unless a
>> special mount option is used. So I think there's work that's needed
>> one way or another, and maybe in more than one part.
>
> Unfortunately, btrfs subvolume list 's various usage is built on top of TREE_SEARCH ioctl
> which requires CAP_SYS_ADMIN.
>
> So what we need here might be to teach 'btrfs sub list' to recognize
> container's CAP_SYS_XXX (if this is possible).


Yes, it's a bit peculiar I can create subvolumes and snapshot them,
but can't 'btrfs sub list/show'

It's an open question why the user needs a subvolume, but I'm not
thinking of a human user necessarily but rather some service, maybe
it's httpd. Or maybe with the xdg-app stuff the Gnome folks are
working on it makes sense to encapsulate applications and their
updates in their own subvolume. *shrug*  I'm open to the idea that the
use case needs to be more compelling and detailed in order to get the
implementation right.


-- 
Chris Murphy
