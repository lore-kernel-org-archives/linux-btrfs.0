Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f178.google.com ([209.85.213.178]:35013 "EHLO
	mail-ig0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932504AbcCIVV1 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 9 Mar 2016 16:21:27 -0500
Received: by mail-ig0-f178.google.com with SMTP id vf5so2340140igb.0
        for <linux-btrfs@vger.kernel.org>; Wed, 09 Mar 2016 13:21:27 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20160309211004.GK27437@merlins.org>
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
	<20160309211004.GK27437@merlins.org>
Date: Wed, 9 Mar 2016 14:21:26 -0700
Message-ID: <CAJCQCtRDGvxgktjQ8zduHAxh=6TvNsnEa9tz75NUvsj-SwsJ9A@mail.gmail.com>
Subject: Re: btrfs and containers
From: Chris Murphy <lists@colorremedies.com>
To: Marc MERLIN <marc@merlins.org>
Cc: Tobias Hunger <tobias.hunger@gmail.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 9, 2016 at 2:10 PM, Marc MERLIN <marc@merlins.org> wrote:
> On Mon, Mar 07, 2016 at 11:55:47PM +0100, Tobias Hunger wrote:
>> Hi,
>>
>> I have been running systemd-nspawn containers on top of a btrfs
>> filesystem for a while now.
>>
>> This works great: Snapshots are a huge help to manage containers!
>>
>> But today I ran btrfs subvol list . *inside* a container. To my
>> surprise I got a list of *all* subvolumes on that drive. That is
>> basically a complete list of containers running on the machine. I do
>> not want to have that kind of information exposed to my containers.
>
> I have a very stripped down docker image that actually mounts portion of
> of my root filesystem read only.
> While it's running out of a btrfs filesystem, you can't run btrfs
> commands against it:
> 05233e5c91f0:/# btrfs fi show
> 05233e5c91f0:/# btrfs subvol list /
> ERROR: can't perform the search - Operation not permitted
> 05233e5c91f0:/# btrfs subvol list .
> ERROR: can't perform the search - Operation not permitted
>
> I didn't do anything special, it's just working that way.

Yep, you're not using --privileged in which case you can't list
things. But I'm not sure what the equivalent is off hand with
systemd-nspawn containers, I think those may always be privileged?


-- 
Chris Murphy
