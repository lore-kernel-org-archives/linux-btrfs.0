Return-Path: <SRS0=ivmk=AC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8C36C433DF
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 05:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A928524820
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 05:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729268AbgFUFuD (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 01:50:03 -0400
Received: from smtp01.belwue.de ([129.143.71.86]:47629 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726354AbgFUFuD (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jun 2020 01:50:03 -0400
X-Greylist: delayed 440 seconds by postgrey-1.27 at vger.kernel.org; Sun, 21 Jun 2020 01:50:02 EDT
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 9E1FF6197
        for <linux-btrfs@vger.kernel.org>; Sun, 21 Jun 2020 07:42:40 +0200 (MEST)
Date:   Sun, 21 Jun 2020 07:42:40 +0200
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: weekly fstrim (still) necessary?
Message-ID: <20200621054240.GA25387@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On SLES a weekly fstrim is done via a btrfsmaintenance script, which is
missing on Ubuntu.

For ext4 filesystem an explicite fstrim call is no longer neccessary, what
about btrfs?
Shall I call fstrim via /etc/cron.weekly ?



-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20200621054240.GA25387@tik.uni-stuttgart.de>
