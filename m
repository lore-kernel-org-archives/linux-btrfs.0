Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B61ABC46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 17:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB412085B
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 17:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6EB412085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=merlins.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729031AbeJ1CYb (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sat, 27 Oct 2018 22:24:31 -0400
Received: from magic.merlins.org ([209.81.13.136]:50171 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728805AbeJ1CYb (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sat, 27 Oct 2018 22:24:31 -0400
Received: from [172.58.91.170] (port=53892 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1gGSbn-0006iE-1l by authid <merlins.org> with srv_auth_plain; Sat, 27 Oct 2018 10:42:47 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1gGSbl-00069T-Pq; Sat, 27 Oct 2018 10:42:45 -0700
Date:   Sat, 27 Oct 2018 10:42:45 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     linux-btrfs@vger.kernel.org
Subject: Re: Have 15GB missing in btrfs filesystem.
Message-ID: <20181027174245.4isfcb6nv4pkklmd@merlins.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: NeoMutt/20160916 (1.7.0)
X-SA-No-Run: Yes
X-Broken-Reverse-DNS: no host name for IP address 172.58.91.170
X-SA-Exim-Connect-IP: 172.58.91.170
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Oct 24, 2018 at 01:07:25PM +0800, Qu Wenruo wrote:
> > saruman:/mnt/btrfs_pool1# btrfs balance start -musage=80 -v .
> > Dumping filters: flags 0x6, state 0x0, force is off
> >   METADATA (flags 0x2): balancing, usage=80
> >   SYSTEM (flags 0x2): balancing, usage=80
> > Done, had to relocate 5 out of 202 chunks
> > saruman:/mnt/btrfs_pool1# btrfs fi show .
> > Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
> > 	Total devices 1 FS bytes used 188.24GiB
> > 	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1
> > 
> > and it's back to 15GB :-/
> > 
> > How can I get 188.24 and 203.54 to converge further? Where is all that
> > space gone?
> 
> Your original chunks are already pretty compact.
> Thus really no need to do extra balance.
> 
> You may get some extra space by doing full system balance (no usage=
> filter), but that's really not worthy in my opinion.
> 
> Maybe you could try defrag to free some space wasted by CoW instead?
> (If you're not using many snapshots)

Thanks for the reply.

So right now, I have:
saruman:~# btrfs fi show /mnt/btrfs_pool1/
Label: 'btrfs_pool1'  uuid: fda628bc-1ca4-49c5-91c2-4260fe967a23
	Total devices 1 FS bytes used 188.25GiB
	devid    1 size 228.67GiB used 203.54GiB path /dev/mapper/pool1

saruman:~# btrfs fi df /mnt/btrfs_pool1/
Data, single: total=192.48GiB, used=184.87GiB
System, DUP: total=32.00MiB, used=48.00KiB
Metadata, DUP: total=5.50GiB, used=3.38GiB
GlobalReserve, single: total=512.00MiB, used=0.00B

I've been using btrfs for a long time now but I've never had a
filesystem where I had 15GB apparently unusable (7%) after a balance.

I can't drop all the snapshots since at least two is used for btrfs
send/receive backups.
However, if I delete more snapshots, and do a full balance, you think
it'll free up more space?
I can try a defrag next, but since I have COW for snapshots, it's not
going to help much, correct?

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
