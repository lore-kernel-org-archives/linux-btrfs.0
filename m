Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:33480 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759222AbdENVDc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 14 May 2017 17:03:32 -0400
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
To: Marc MERLIN <marc@merlins.org>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
Cc: linux-btrfs@vger.kernel.org
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <cf73557f-65e9-f9be-f8d7-4ed0de066eaf@bouton.name>
Date: Sun, 14 May 2017 22:57:26 +0200
MIME-Version: 1.0
In-Reply-To: <20170514201508.bd3dshfymqt4swpb@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 14/05/2017 à 22:15, Marc MERLIN a écrit :
> On Sun, May 14, 2017 at 09:13:35PM +0200, Hans van Kranenburg wrote:
>> On 05/13/2017 10:54 PM, Marc MERLIN wrote:
>>> Kernel 4.11, btrfs-progs v4.7.3
>>>
>>> I run scrub and balance every night, been doing this for 1.5 years on this
>>> filesystem.
>> What are the exact commands you run every day?
>  
> http://marc.merlins.org/perso/btrfs/post_2014-03-19_Btrfs-Tips_-Btrfs-Scrub-and-Btrfs-Filesystem-Repair.html
> (at the bottom)
> every night:
> 1) scrub
> 2) balance -musage=0
> 3) balance -musage=20
> 4) balance -dusage=0
> 5) balance -dusage=20

usage=20 is pretty low: this means you don't try to reallocate and
regroup together block groups that are filled more than 20%.
Constantly using this settings has left lots of allocated block groups
that are mostly empty on your filesystem (a little more than 20% used).

The rebalance subject is a bit complex. With an empty filesystem you
almost don't need it as group creation is sparse and it's OK to have
mostly empty groups. When your filesystem begins to fill up you have to
raise the usage target to be able to reclaim space (as the fs fills up
most of your groups do too) so that new block creation can happen.

I've coded one Ruby script which tries to balance between the cost of
reallocating group and the need for it. The basic idea is that it tries
to keep the proportion of free space "wasted" by being allocated
although it isn't used below a threshold. It will bring this proportion
down enough through balance that minor reallocation won't trigger a new
balance right away. It should handle pathological conditions as well as
possible and it won't spend more than 2 hours working on a single
filesystem by default. We deploy this as a daily cron script through
Puppet on all our systems and it works very well (I didn't have to use
balance manually to manage free space since we did that).
Note that by default it sleeps a random amount of time to avoid IO
spikes on VMs running on the same host. You can either edit it or pass
it "0" which will be used for the max amount of time to sleep bypassing
this precaution.

Here is the latest version : https://pastebin.com/Rrw1GLtx
Given its current size, I should probably push it on github...

I've seen other maintenance scripts mentioned on this list so you might
something simpler or more targeted to your needs by browsing through the
list's history.

Best regards,

Lionel
