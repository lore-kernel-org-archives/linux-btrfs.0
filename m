Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:58484 "EHLO mail.bouton.name"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751122AbdCQJdn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 05:33:43 -0400
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
 <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
 <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
Date: Fri, 17 Mar 2017 10:27:11 +0100
MIME-Version: 1.0
In-Reply-To: <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

Le 17/03/2017 à 09:43, Hans van Kranenburg a écrit :
> btrfs-debug-tree -b 3415463870464

Here is what it gives me back :

btrfs-debug-tree -b 3415463870464 /dev/sdb
btrfs-progs v4.6.1
checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
bytenr mismatch, want=3415463870464, have=72340172838076673
ERROR: failed to read 3415463870464

Is there a way to remove part of the tree and keep the rest ? It could
help minimize the time needed to restore data.

Lionel
