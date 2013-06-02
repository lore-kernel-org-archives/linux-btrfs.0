Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [212.13.216.74] ([212.13.216.74]:44934 "EHLO mail.39.gs"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754282Ab3FBQwk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 2 Jun 2013 12:52:40 -0400
Received: from mail.39.gs (localhost [127.0.0.1])
	by mail.39.gs (Postfix) with ESMTPA id 4DF2288841
	for <linux-btrfs@vger.kernel.org>; Sun,  2 Jun 2013 17:52:38 +0100 (BST)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Sun, 02 Jun 2013 17:52:38 +0100
From: Tim Eggleston <lists@timeggleston.co.uk>
To: linux-btrfs@vger.kernel.org
Subject: Re: RAID10 total capacity incorrect
In-Reply-To: <20130602163015.GG20133@carfax.org.uk>
References: <7b97469e82e675814317efef48cc3d71@mail.39.gs>
 <20130602163015.GG20133@carfax.org.uk>
Message-ID: <4cd17d2ff5a252261c4ab2f3800207b5@mail.39.gs>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Hugo,

Thanks for your reply, good to know it's not an error as such (just me 
being an idiot!).

> Additional space will be allocated from the available unallocated
> space as the FS needs it.

So I guess my question becomes, how much of that available unallocated 
space do I have? Instinctively the btrfs df output feels like it's 
missing an equivalent to the "size" column from vanilla df.

Is there a method of getting this in a RAID situation? I understand that 
btrfs RAID is more complicated than md RAID, so it's ok if the answer at 
this point is "no"...

Thanks again,

  ---tim

