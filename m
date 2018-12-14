Return-Path: <SRS0=3GAk=OX=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5AC6C43387
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 15:26:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3051206C2
	for <linux-btrfs@archiver.kernel.org>; Fri, 14 Dec 2018 15:26:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729974AbeLNP01 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 14 Dec 2018 10:26:27 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:42230 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726344AbeLNP01 (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 14 Dec 2018 10:26:27 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gXpM9-0005jr-8V
        for linux-btrfs@vger.kernel.org; Fri, 14 Dec 2018 16:26:25 +0100
Date:   Fri, 14 Dec 2018 16:26:25 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     linux-btrfs@vger.kernel.org
Subject: Re: SATA/SAS mixed pool
Message-ID: <20181214152625.64relajmkufr66ql@angband.pl>
References: <CAEEhgEtryrEBv-PgZ5VkXEUcmXhx7JCoRrDhyLK5zP0-zOsESw@mail.gmail.com>
 <20181213072905.ac352nclowixfhpt@angband.pl>
 <pan$a6302$5fc2e266$9dae146a$696f7df5@cox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <pan$a6302$5fc2e266$9dae146a$696f7df5@cox.net>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri, Dec 14, 2018 at 05:14:37AM +0000, Duncan wrote:
> Adam Borowski posted on Thu, 13 Dec 2018 08:29:05 +0100 as excerpted:
> > On Wed, Dec 12, 2018 at 09:31:02PM -0600, Nathan Dehnel wrote:
> >> Is it possible/safe to replace a SATA drive in a btrfs RAID10 pool with
> >> an SAS drive?
> > 
> > For btrfs, a block device is a block device, it's not "racist".
> > You can freely mix and/or replace.  If you want to, say, extend a SD
> > card with NBD to remote spinning rust, it works well -- tested :p
> 
> FWIW (mostly for other readers not so much this particular case) the 
> known exception/caveat to that is USB block devices, which do tend to 
> have problems, tho some hardware is fine.

Yeah, but the problem doesn't come from btrfs not supporting or ill
supporting USB, just from the devices themselves being flaky.  If they
supported the spec correctly, all would be ok.

An example might be NBD from one of my machines that has an incredibly bad
network driver -- it drops packets whenever there's even a bit of memory
pressure.  That's ok on RX (no different from packet being dropped on the
wire, the sender will retransmit) but unacceptable on TX -- it should have
slept instead; NBD (reasonably) can't handle this and destroys the block
device.  Yet btrfs can handle such an unexpected but clean disconnect just
fine -- not even a reboot is needed, I need to unmount, restart NBD then
remount.  From the filesystem's point of view this is exactly equivalent
to a power loss -- that the in-memory copy tried to do some writes
afterwards doesn't matter.

So it's not just whether the device fails, it's about _how_ it fails.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
