Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zaphod.cobb.me.uk ([213.138.97.131]:58850 "EHLO
        zaphod.cobb.me.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752903AbcJMKdC (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 13 Oct 2016 06:33:02 -0400
Received: from black.home.cobb.me.uk (unknown [192.168.0.205])
        by zaphod.cobb.me.uk (Postfix) with ESMTP id EBDEA9B8EB
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 11:07:34 +0100 (BST)
Received: from [192.168.0.211] (novatech.home.cobb.me.uk [192.168.0.211])
        by black.home.cobb.me.uk (Postfix) with ESMTPS id 83B835FBB4
        for <linux-btrfs@vger.kernel.org>; Thu, 13 Oct 2016 11:07:34 +0100 (BST)
Subject: Re: Incremental send robustness question
To: Btrfs List <linux-btrfs@vger.kernel.org>
References: <20161012222955.GB2412@fox.home>
 <1bfe5018-3540-319d-813f-32a0571b57d1@mendix.com>
 <20161012234743.GA5000@fox.home>
From: Graham Cobb <g.btrfs@cobb.uk.net>
Message-ID: <e5f0faf2-110b-7e5a-2fc4-1f60c46c9525@cobb.uk.net>
Date: Thu, 13 Oct 2016 11:07:34 +0100
MIME-Version: 1.0
In-Reply-To: <20161012234743.GA5000@fox.home>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 13/10/16 00:47, Sean Greenslade wrote:
> I may just end up doing that. Hugo's responce gave me some crazy ideas
> involving a custom build of split that waits for a command after each
> output file fills, which would of course require an equally weird build
> of cat that would stall the pipe indefinitely until all the files showed
> up. Driving the HDD over would probably be a little simpler. =P

I am sure it is, if that is an option.  I had considered doing something
similar: doing an initial send to a big file on a spare disk, then
sending the disk to Amazon to import using their Import/Export Disk
service, then creating a server and a filesystem in AWS and doing a
btrfs receive from the imported file. The plan would then be to do
incremental sends over my home broadband line for subsequent backups.

>>> And while we're at it, what are the failure modes for incremental sends?
>>> Will it throw an error if the parents don't match, or will there just be
>>> silent failures?
>>
>> Create a list of possibilities, create some test filesystems, try it.
> 
> I may just do that, presuming I can find the spare time. Given that I'm
> building a backup solution around this tech, it would definitely bolster
> my confidence in it if I knew what its failure modes looked like.

That's a good idea.  In the end I decided that relying on btrfs send for
my offsite cold storage backups was probably not a good idea.  Btrfs is
great, and I heavily use snapshotting and send/receive locally. But
there is always a small nagging fear that a btrfs bug could introduce
some problem which can survive send/receive and mean the backup was
corrupted as well (or that an incremental won't load for some reason).
For that reason I decided to deliberately use a different technology for
backups.  I now use dar to create backups and then upload the files to a
cloud cold storage service for safekeeping.

There are other reasons as well: encryption is easier to handle, cold
storage for files is cheaper than having disk images which need to be
online to load the incrementals, no need for a virtual server, handling
security for backups from different servers with different levels of
risk is easier, etc. There are also downsides: verifying the backups are
readable/restorable is harder, bandwidth usage is less efficient (dar
sends more data than btrfs send would as it is working at the file
level, not the extent level).

By the way, to test out your various failure modes I recommend creating
some small btrfs filesystems on loop devices -- just be careful to make
sure you create each one from scratch and do not copy disk images (so
that they all have unique UIDs).



