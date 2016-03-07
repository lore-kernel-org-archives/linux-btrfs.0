Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:36987 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932384AbcCGXpM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 7 Mar 2016 18:45:12 -0500
Received: by mail-ig0-f177.google.com with SMTP id z8so4514564ige.0
        for <linux-btrfs@vger.kernel.org>; Mon, 07 Mar 2016 15:45:11 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
Date: Mon, 7 Mar 2016 16:45:09 -0700
Message-ID: <CAJCQCtSPEY1c-=GTJwH3-qRNxGCEsd0bVu9A_srdFt03bX7BcQ@mail.gmail.com>
Subject: Re: btrfs and containers
From: Chris Murphy <lists@colorremedies.com>
To: Tobias Hunger <tobias.hunger@gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Mar 7, 2016 at 3:55 PM, Tobias Hunger <tobias.hunger@gmail.com> wrote:
> Hi,
>
> I have been running systemd-nspawn containers on top of a btrfs
> filesystem for a while now.
>
> This works great: Snapshots are a huge help to manage containers!
>
> But today I ran btrfs subvol list . *inside* a container. To my
> surprise I got a list of *all* subvolumes on that drive. That is
> basically a complete list of containers running on the machine. I do
> not want to have that kind of information exposed to my containers.
>
> Is there a way to stop btrfs from listing subvolumes "above" the
> current location? So that "btrfs subvol list /" in a container will
> only show subvolumes that are set up in the container?

I'm not sure whether this is something that goes in Btrfs proper,
since this is presumably a privileged container? The same thing
happens with Docker containers. One way to do this is if it's not
privileged, as non-root can't list subvolumes. I think some work is
needed to make it possible for users to list subvolumes they own.
Right now a user can create a subvolume but then now list or get
information on it. By default they can't delete it either unless a
special mount option is used. So I think there's work that's needed
one way or another, and maybe in more than one part.

-- 
Chris Murphy
