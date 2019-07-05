Return-Path: <SRS0=//O4=VC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05442C4649B
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 10:45:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D44E32133F
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 10:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728572AbfGEKpE (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jul 2019 06:45:04 -0400
Received: from smtp02.belwue.de ([129.143.71.87]:39931 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726523AbfGEKpD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jul 2019 06:45:03 -0400
X-Greylist: delayed 397 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Jul 2019 06:45:02 EDT
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id B8901A2A9
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2019 12:38:23 +0200 (MEST)
Date:   Fri, 5 Jul 2019 12:38:23 +0200
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: snapshot rollback
Message-ID: <20190705103823.GA13281@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org


This is a conceptual btrfs question :-)

I have this btrfs filesystem:

root@xerus:~# mount | grep /test
/dev/sdd4 on /test type btrfs (rw,relatime,space_cache,user_subvol_rm_allowed,subvolid=5,subvol=/)

with some snapshots:

root@xerus:~# btrfs subvolume list /test
ID 736 gen 9722 top level 5 path .snapshot/2018-12-02_1215.test
ID 737 gen 9722 top level 5 path .snapshot/2018-12-02_1216.test
ID 738 gen 9722 top level 5 path .snapshot/2018-12-02_1217.test

I now want to do a rollback to .snapshot/2018-12-02_1217.test
I can do it with:

mount -t btrfs -o subvol=.snapshot/2018-12-02_1217.test /dev/sdd4 /test

But (how) can I delete the original root subvol to free disk space?

  
-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20190705103823.GA13281@tik.uni-stuttgart.de>
