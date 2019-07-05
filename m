Return-Path: <SRS0=//O4=VC=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA04C46499
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 19:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AACB721852
	for <linux-btrfs@archiver.kernel.org>; Fri,  5 Jul 2019 19:47:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727984AbfGETrX (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Fri, 5 Jul 2019 15:47:23 -0400
Received: from smtp02.belwue.de ([129.143.71.87]:48862 "EHLO smtp02.belwue.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726794AbfGETrX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 5 Jul 2019 15:47:23 -0400
Received: from fex.rus.uni-stuttgart.de (fex.rus.uni-stuttgart.de [129.69.1.129])
        by smtp02.belwue.de (Postfix) with SMTP id 9C993836B
        for <linux-btrfs@vger.kernel.org>; Fri,  5 Jul 2019 21:47:20 +0200 (MEST)
Date:   Fri, 5 Jul 2019 21:47:20 +0200
From:   Ulli Horlacher <framstag@rus.uni-stuttgart.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: delete recursivly subvolumes?
Message-ID: <20190705194720.GC23600@tik.uni-stuttgart.de>
Mail-Followup-To: linux-btrfs@vger.kernel.org
References: <20190705193945.GB23600@tik.uni-stuttgart.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705193945.GB23600@tik.uni-stuttgart.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Fri 2019-07-05 (21:39), Ulli Horlacher wrote:

> Is there a command/script/whatever to remove subvolume which contains
> (somewhere) other subvolumes?

ADONN QUESTION! :-)

Is there a command/script/whatever to snapshot (copy) a subvolume which
contains (somewhere) other subvolumes?

Example:

root@xerus:/test# btrfs_subvolume_list /test/ | grep /tmp
/test/tmp
/test/tmp/xx/ss1
/test/tmp/xx/ss2
/test/tmp/xx/ss3

I want to have (with one command):

/test/tmp --> /test/tmp2
/test/tmp/xx/ss1 --> /test/tmp2/xx/ss1
/test/tmp/xx/ss2 --> /test/tmp2/xx/ss2
/test/tmp/xx/ss3 --> /test/tmp2/xx/ss3

-- 
Ullrich Horlacher              Server und Virtualisierung
Rechenzentrum TIK         
Universitaet Stuttgart         E-Mail: horlacher@tik.uni-stuttgart.de
Allmandring 30a                Tel:    ++49-711-68565868
70569 Stuttgart (Germany)      WWW:    http://www.tik.uni-stuttgart.de/
REF:<20190705193945.GB23600@tik.uni-stuttgart.de>
