Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f173.google.com ([209.85.220.173]:34249 "EHLO
	mail-qk0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932068AbcCHMM4 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Mar 2016 07:12:56 -0500
Received: by mail-qk0-f173.google.com with SMTP id x1so4687802qkc.1
        for <linux-btrfs@vger.kernel.org>; Tue, 08 Mar 2016 04:12:56 -0800 (PST)
Subject: Re: btrfs and containers
To: Tobias Hunger <tobias.hunger@gmail.com>, linux-btrfs@vger.kernel.org
References: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56DEC1BE.6040005@gmail.com>
Date: Tue, 8 Mar 2016 07:12:46 -0500
MIME-Version: 1.0
In-Reply-To: <CAMdWP3G9uaTcbDWE68LYd17sf8-j11Aqo+ACRrZFFGdB995gSQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-03-07 17:55, Tobias Hunger wrote:
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
>
There is not currently a way to do this.  My personal recommendation 
until there is would be to use LVM or something similar and have each 
container on it's own FS (this has other advantages too, like being able 
to use seed devices to quickly spin up containers in a known state.

Ideally though, we should be checking the current root directory when in 
a mount namespace, and not list subvolumes outside that tree.

