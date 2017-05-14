Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from [195.159.176.226] ([195.159.176.226]:51884 "EHLO
        blaine.gmane.org" rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org
        with ESMTP id S1759530AbdENVfK (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 17:35:10 -0400
Received: from list by blaine.gmane.org with local (Exim 4.84_2)
        (envelope-from <gcfb-btrfs-devel-moved1-2@m.gmane.org>)
        id 1dA1AM-00010Y-RO
        for linux-btrfs@vger.kernel.org; Sun, 14 May 2017 23:35:02 +0200
To: linux-btrfs@vger.kernel.org
From: Kai Krakow <hurikhan77@gmail.com>
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
Date: Sun, 14 May 2017 23:30:31 +0200
Message-ID: <20170514233031.6f4724a1@jupiter.sol.kaishome.de>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
        <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
        <20170514201508.bd3dshfymqt4swpb@merlins.org>
        <cf73557f-65e9-f9be-f8d7-4ed0de066eaf@bouton.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am Sun, 14 May 2017 22:57:26 +0200
schrieb Lionel Bouton <lionel-subscription@bouton.name>:

> I've coded one Ruby script which tries to balance between the cost of
> reallocating group and the need for it. The basic idea is that it
> tries to keep the proportion of free space "wasted" by being allocated
> although it isn't used below a threshold. It will bring this
> proportion down enough through balance that minor reallocation won't
> trigger a new balance right away. It should handle pathological
> conditions as well as possible and it won't spend more than 2 hours
> working on a single filesystem by default. We deploy this as a daily
> cron script through Puppet on all our systems and it works very well
> (I didn't have to use balance manually to manage free space since we
> did that). Note that by default it sleeps a random amount of time to
> avoid IO spikes on VMs running on the same host. You can either edit
> it or pass it "0" which will be used for the max amount of time to
> sleep bypassing this precaution.
> 
> Here is the latest version : https://pastebin.com/Rrw1GLtx
> Given its current size, I should probably push it on github...

Yes, please... ;-)

> I've seen other maintenance scripts mentioned on this list so you
> might something simpler or more targeted to your needs by browsing
> through the list's history.


-- 
Regards,
Kai

Replies to list-only preferred.

