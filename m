Return-Path: <SRS0=ivmk=AC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 278CFC433E0
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 23:52:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 021C4252F1
	for <linux-btrfs@archiver.kernel.org>; Sun, 21 Jun 2020 23:52:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730925AbgFUXwG (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 21 Jun 2020 19:52:06 -0400
Received: from smtp01.belwue.de ([129.143.71.86]:41498 "EHLO smtp01.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbgFUXwG (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 21 Jun 2020 19:52:06 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp01.belwue.de (Postfix) with SMTP id 20749621D
        for <linux-btrfs@vger.kernel.org>; Mon, 22 Jun 2020 01:52:03 +0200 (MEST)
Date:   Mon, 22 Jun 2020 01:52:02 +0200
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: weekly fstrim (still) necessary?
Message-ID: <20200621235202.GA16871@tik.uni-stuttgart.de>
Mail-Followup-To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
References: <20200621054240.GA25387@tik.uni-stuttgart.de>
 <CAJCQCtSbCid6OzvjK9fxXZosS_PAk2Lr7=VTpNijuuZXmRVVEg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJCQCtSbCid6OzvjK9fxXZosS_PAk2Lr7=VTpNijuuZXmRVVEg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Sun 2020-06-21 (13:39), Chris Murphy wrote:

> > Shall I call fstrim via /etc/cron.weekly ?
> 
> util-linux provides fstrim.service and fstrim.timer for a while now.
> fstrim.timer runs on Monday at 00:00 local time. The upstream default
> is disabled, some distributions enable it by default.

On Ubuntu 18.04 and RHEL 7.8 "systemctl is-enabled fstrim" returns
"static"


This means: an extra fstrim (via btrfsmaintenance script, etc) is
unnecessary? 


-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<CAJCQCtSbCid6OzvjK9fxXZosS_PAk2Lr7=VTpNijuuZXmRVVEg@mail.gmail.com>
