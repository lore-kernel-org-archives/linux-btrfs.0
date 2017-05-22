Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from washoe.dartmouth.edu ([129.170.30.229]:37986 "EHLO
        smtp.onerussian.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757547AbdEVNIH (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 22 May 2017 09:08:07 -0400
Received: from c-76-24-253-1.hsd1.nh.comcast.net ([76.24.253.1] helo=localhost)
        by smtp.onerussian.com with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <yoh@onerussian.com>)
        id 1dCn49-0006oO-2Q
        for linux-btrfs@vger.kernel.org; Mon, 22 May 2017 09:08:06 -0400
Date: Mon, 22 May 2017 09:07:59 -0400
From: Yaroslav Halchenko <yoh@onerussian.com>
To: linux-btrfs <linux-btrfs@vger.kernel.org>
Message-ID: <20170522130759.mnstg6g2srfb6glz@hopa.kiewit.dartmouth.edu>
References: <20170518134135.sk6dha6kayv6tar3@hopa.kiewit.dartmouth.edu>
 <CAEtw4r1ibfLpNgmtti6pTDUOmA=+kOCemg7=ykneKDaJMpx59Q@mail.gmail.com>
 <CAEtw4r1YSqvGCg_7R3yJY+EMZBO2FNjLDuxppLDQtb0qMKvwTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CAEtw4r1YSqvGCg_7R3yJY+EMZBO2FNjLDuxppLDQtb0qMKvwTQ@mail.gmail.com>
Subject: Re: Fwd: confusing "no space left" -- how to troubleshoot and "be
 prepared"?
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


On Thu, 18 May 2017, Peter Becker wrote:

> I'm not sure if this would be helpfull but can you post the output
> from this script?

> cd /tmp
> wget https://raw.githubusercontent.com/kdave/btrfs-progs/master/btrfs-debugfs
> chmod +x btrfs-debugfs
> stats=$(sudo ./btrfs-debugfs -b /)
> ...

Thank you Peter

I guess I will use on the next occasion like that.  This time I just
removed some snapshots/subvolumes (and docker images) to free up some
space, rebooted and using the system again.  I guess it would make
little sense to share that info ATM.

With best regards,
-- 
Yaroslav O. Halchenko
Center for Open Neuroscience     http://centerforopenneuroscience.org
Dartmouth College, 419 Moore Hall, Hinman Box 6207, Hanover, NH 03755
Phone: +1 (603) 646-9834                       Fax: +1 (603) 646-1419
WWW:   http://www.linkedin.com/in/yarik        
