Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from magic.merlins.org ([209.81.13.136]:48627 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753016AbdICObw (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sun, 3 Sep 2017 10:31:52 -0400
Date: Sun, 3 Sep 2017 07:31:42 -0700
From: Marc MERLIN <marc@merlins.org>
To: Josef Bacik <jbacik@fb.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Chris Murphy <lists@colorremedies.com>, Chris Mason <clm@fb.com>,
        "bo.li.liu@oracle.com" <bo.li.liu@oracle.com>,
        "fdmanana@suse.com" <fdmanana@suse.com>,
        David Sterba <dsterba@suse.cz>
Message-ID: <20170903143142.7thdjvkmkdekrzc5@merlins.org>
References: <20170831173607.GM15290@merlins.org>
 <5320FF2E-D183-4D2A-A155-49424E1CD60F@fb.com>
 <20170901204329.GH30689@merlins.org>
 <11510543-DAC5-400B-8204-C1FCC12CF335@fb.com>
 <20170902160942.imo2hotpur3pnops@merlins.org>
 <B8F93BCF-0976-4450-A58E-13F6A3C48573@fb.com>
 <20170902235344.sb55vzaloglmqaad@merlins.org>
 <73427BC6-B85B-422C-BCA0-778C7BA203A8@fb.com>
 <20170903010127.eafg2i7ry2tprro7@merlins.org>
 <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <5D0BC86A-D427-4529-A40E-492A98BA5D16@fb.com>
Subject: Re: BTRFS: error (device dm-2) in btrfs_run_delayed_refs:2960:
 errno=-17 Object already exists (since 3.4 / 2012)
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 03, 2017 at 03:26:34AM +0000, Josef Bacik wrote:
> I was looking through the code for other ways to cut down memory usage when I noticed we only catch improper re-allocations, not adding another ref for metadata which is what I suspect your problem is.  I added another patch and pushed it out, sorry for the churn.

Installed.

For now, I've seen this once, but otherwise no issues:
Dropping a ref for a root that doesn't have a ref on the block
Dumping block entry [26538725376 4096], num_refs 2, metadata 0, from disk 1
  Ref root 0, parent 29818880, owner 23608, offset 0, num_refs 18446744073709551615
  Ref root 0, parent 202129408, owner 23608, offset 0, num_refs 1
  Ref root 418, parent 0, owner 23608, offset 0, num_refs 1
  Root entry 418, num_refs 1
  Root entry 69809, num_refs 0
  Ref action 1, root 418, ref_root 0, parent 202129408, owner 23608, offset 0, num_refs 1
  No stacktrace support
  Ref action 2, root 69809, ref_root 0, parent 29818880, owner 23608, offset 0, num_refs 18446744073709551615
  No stacktrace support


I'm assuming this was done by your patch?
Should I worry about 'No stacktrace support' ?

Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
