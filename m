Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ob0-f180.google.com ([209.85.214.180]:38180 "EHLO
	mail-ob0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755607Ab3KFAU7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Nov 2013 19:20:59 -0500
Received: by mail-ob0-f180.google.com with SMTP id wo20so9451194obc.11
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Nov 2013 16:20:58 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20131105143438.GM14405@carfax.org.uk>
References: <201311051224.44255.russell@coker.com.au>
	<CAD_cGvE-FtFxZerOKN7T11-L=cEgh_8i-=YcgwG+g1aye6Zn6w@mail.gmail.com>
	<201311052316.34979.russell@coker.com.au>
	<49B5E6AD-795D-4839-A360-7F3782ED7F2F@colorremedies.com>
	<20131105143438.GM14405@carfax.org.uk>
Date: Tue, 5 Nov 2013 16:20:58 -0800
Message-ID: <CAJBj3veWmB4m+pR2SdZ=y4pRVXfR5aGpfjH2HhoFXbARcZy34w@mail.gmail.com>
Subject: Re: csum failure messages
From: John Williams <jwilliams4200@gmail.com>
To: Hugo Mills <hugo@carfax.org.uk>, Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 5, 2013 at 6:34 AM, Hugo Mills <hugo@carfax.org.uk> wrote:
> On Tue, Nov 05, 2013 at 07:26:54AM -0700, Chris Murphy wrote:
>>
>> On Nov 5, 2013, at 5:16 AM, Russell Coker <russell@coker.com.au> wrote:
>> >
>> > I presume that my filesystem is still corrupt.
>>
>> I'm the original reporter of the bug. The file system itself isn't corrupt, but the affected files probably are. In my case, systemd journal files were reported as corrupt by systemd following a balance, as well as btrfs scrub. Upon scrub, dmesg contains a path for each affected file. Upon deleting those files, subsequent scrubs come up clean.
>>
>> Fedora merged the fix for this bug with: 3.11.5-302.fc20, 3.11.6-200.fc19, 3.11.6-101.fc18. I thought for sure it was marked for stable to go into mainline 3.11.6, so somehow it's been missed.
>
>    Someone else tripped over it on IRC last night, and I was surprised
> to discover it hadn't made it upstream yet. :(

Is there now a verification test that could detect an issue like this?
It seems like the sort of thing that needs to be added to automated
testing.
