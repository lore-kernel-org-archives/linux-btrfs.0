Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:41512 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S934160AbdEOLa0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 15 May 2017 07:30:26 -0400
Subject: Re: balancing every night broke balancing so now I can't balance
 anymore?
To: Hugo Mills <hugo@carfax.org.uk>, Marc MERLIN <marc@merlins.org>,
        Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        linux-btrfs@vger.kernel.org
References: <20170513205431.lm6y5tcffr35gq4a@merlins.org>
 <95bffb8b-7e66-7d6b-2455-f7a025dbb96c@mendix.com>
 <20170514201508.bd3dshfymqt4swpb@merlins.org>
 <20170514212111.GL9701@carfax.org.uk>
 <20170514231652.sdpaci7e4oxs5gc3@merlins.org>
 <20170515081455.GM9701@carfax.org.uk>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <2549087f-42aa-9a8b-227d-a16cf2fd5b47@bouton.name>
Date: Mon, 15 May 2017 13:30:24 +0200
MIME-Version: 1.0
In-Reply-To: <20170515081455.GM9701@carfax.org.uk>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 15/05/2017 à 10:14, Hugo Mills a écrit :
> [...]
>> As for limit= I'm not sure if it would be helpful since I run this
>> nightly. Anything that doesn't get done tonight due to limit, would be
>> done tomorrow?
>    I'm suggesting limit= on its own. It's a fixed amount of work
> compared to usage=, which may not do anything at all. For example,
> it's perfectly possible to have a filesystem which is, say, 30% full,
> and yet is still fully-allocated filesystem with more than 20% of
> every chunk used. In that case your usage= wouldn't balance anything,
> and you'd still be left in the situation of risking ENOSPC from
> running out of metadata.

Hugo, as I don't have any feedback on my approach to address this
problem could you have a look at my script or simply the principle : is
there any drawback vs using limit in calling balance multiple times
raising usage (and using the same value for data and metadata) until you
get enough free space ?

For reference :

https://github.com/jtek/ceph-utils/blob/master/btrfs-auto-rebalance.rb


Lionel
