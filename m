Return-Path: <SRS0=3TJ0=NH=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA617C46475
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 20:19:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FABD2085B
	for <linux-btrfs@archiver.kernel.org>; Sat, 27 Oct 2018 20:19:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5FABD2085B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=merlins.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726734AbeJ1FBm (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 28 Oct 2018 01:01:42 -0400
Received: from magic.merlins.org ([209.81.13.136]:52745 "EHLO
        mail1.merlins.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726488AbeJ1FBm (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 28 Oct 2018 01:01:42 -0400
Received: from [208.74.179.186] (port=48964 helo=legolas.merlins.org)
        by mail1.merlins.org with esmtpsa 
        (Cipher TLS1.2:DHE_RSA_AES_128_CBC_SHA1:128) (Exim 4.87 #1)
        id 1gGV3W-0003Zr-Dm by authid <merlins.org> with srv_auth_plain; Sat, 27 Oct 2018 13:19:34 -0700
Received: from merlin by legolas.merlins.org with local (Exim 4.80)
        (envelope-from <marc@merlins.org>)
        id 1gGV3V-0005aV-Qh; Sat, 27 Oct 2018 13:19:33 -0700
Date:   Sat, 27 Oct 2018 13:19:33 -0700
From:   Marc MERLIN <marc@merlins.org>
To:     Remi Gauvin <remi@georgianit.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Have 15GB missing in btrfs filesystem.
Message-ID: <20181027201933.wrquhmdrg3z2fa2o@merlins.org>
References: <20181024003613.q5bxmqm4hh5xbgmf@merlins.org>
 <a8500d2d-2747-f250-75a8-2ec4c0533c6c@gmx.com>
 <20181027174245.4isfcb6nv4pkklmd@merlins.org>
 <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d530a9d0-4cee-521b-6c95-ff56d0f7c130@georgianit.com>
X-Sysadmin: BOFH
X-URL:  http://marc.merlins.org/
User-Agent: NeoMutt/20160916 (1.7.0)
X-SA-No-Run: Yes
X-Broken-Reverse-DNS: no host name for IP address 208.74.179.186
X-SA-Exim-Connect-IP: 208.74.179.186
X-SA-Exim-Mail-From: marc@merlins.org
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sat, Oct 27, 2018 at 02:12:02PM -0400, Remi Gauvin wrote:
> On 2018-10-27 01:42 PM, Marc MERLIN wrote:
> 
> > 
> > I've been using btrfs for a long time now but I've never had a
> > filesystem where I had 15GB apparently unusable (7%) after a balance.
> > 
> 
> The space isn't unusable.  It's just allocated.. (It's used in the sense
> that it's reserved for data chunks.).  Start writing data to the drive,
> and the data will fill that space before more gets allocated.. (Unless
> you are using an older kernel and the filesystem gets mounted with ssd
> option, in which case, you'll want to add nossd option to prevent that
> behaviour.)
> 
> You can use btrfs fi usage to display that more clearly.
 
Got it. I have disk space free alerts based on df, which I know doesn't
mean that much on btrfs. Maybe I'll just need to change that alert code
to make it btrfs aware.
 
> > I can try a defrag next, but since I have COW for snapshots, it's not
> > going to help much, correct?
> 
> The defrag will end up using more space, as the fragmented parts of
> files will get duplicated.  That being said, if you have the luxury to
> defrag *before* taking new snapshots, that would be the time to do it.

Thanks for confirming. Because I always have snapshots for btrfs
send/receive, defrag will duplicate as you say, but once the older
snapshots get freed up, the duplicate blocks should go away, correct?

Back to usage, thanks for pointing out that command:
saruman:/mnt/btrfs_pool1# btrfs fi usage .
Overall:
    Device size:		 228.67GiB
    Device allocated:		 203.54GiB
    Device unallocated:		  25.13GiB
    Device missing:		     0.00B
    Used:			 192.01GiB
    Free (estimated):		  32.44GiB	(min: 19.88GiB)
    Data ratio:			      1.00
    Metadata ratio:		      2.00
    Global reserve:		 512.00MiB	(used: 0.00B)

Data,single: Size:192.48GiB, Used:185.16GiB
   /dev/mapper/pool1	 192.48GiB

Metadata,DUP: Size:5.50GiB, Used:3.42GiB
   /dev/mapper/pool1	  11.00GiB

System,DUP: Size:32.00MiB, Used:48.00KiB
   /dev/mapper/pool1	  64.00MiB

Unallocated:
   /dev/mapper/pool1	  25.13GiB


I'm still seing that I'm using 192GB, but 203GB allocated.
Do I have 25GB usable:
    Device unallocated:		  25.13GiB

Or 35GB usable?
    Device size:		 228.67GiB
      -
    Used:                        192.01GiB
      = 36GB ?    

Yes I know that I shouldn't get close to filling up the device, just
trying to clear up if I should stay below 25GB or below 35GB

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                       | PGP 7F55D5F27AAF9D08
