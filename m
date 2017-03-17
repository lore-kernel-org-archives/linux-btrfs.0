Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from len.romanrm.net ([195.154.117.182]:53134 "EHLO len.romanrm.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751021AbdCQJvI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 17 Mar 2017 05:51:08 -0400
Date: Fri, 17 Mar 2017 14:51:07 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Lionel Bouton <lionel-subscription@bouton.name>
Cc: Hans van Kranenburg <hans.van.kranenburg@mendix.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: help : "bad tree block start" -> btrfs forced readonly
Message-ID: <20170317145107.21bb9b45@natsu>
In-Reply-To: <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
References: <0ec911af-2932-72df-d9b3-bd27616e101e@bouton.name>
        <c704f24e-4ea2-43fe-909e-92ad98bf6d28@bouton.name>
        <4866fa5d-d9bc-653a-17d8-b555fc55491e@mendix.com>
        <2994d13d-c65c-0794-8a83-a68ff258f109@bouton.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, 17 Mar 2017 10:27:11 +0100
Lionel Bouton <lionel-subscription@bouton.name> wrote:

> Hi,
> 
> Le 17/03/2017 à 09:43, Hans van Kranenburg a écrit :
> > btrfs-debug-tree -b 3415463870464
> 
> Here is what it gives me back :
> 
> btrfs-debug-tree -b 3415463870464 /dev/sdb
> btrfs-progs v4.6.1
> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
> checksum verify failed on 3415463870464 found A85405B7 wanted 01010101
> bytenr mismatch, want=3415463870464, have=72340172838076673
> ERROR: failed to read 3415463870464
> 
> Is there a way to remove part of the tree and keep the rest ? It could
> help minimize the time needed to restore data.

If you are able to experiment with writable snapshots, you could try using
"btrfs-corrupt-block" to kill the bad block, and see what btrfsck makes out of
the rest. In a similar case I got little to no damage to the overall FS.
http://www.spinics.net/lists/linux-btrfs/msg53061.html

-- 
With respect,
Roman
