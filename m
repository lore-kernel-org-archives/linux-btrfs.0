Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f45.google.com ([209.85.215.45]:36175 "EHLO
        mail-lf0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751350AbdIEMgN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 Sep 2017 08:36:13 -0400
Received: by mail-lf0-f45.google.com with SMTP id m199so10328744lfe.3
        for <linux-btrfs@vger.kernel.org>; Tue, 05 Sep 2017 05:36:12 -0700 (PDT)
Received: from m176-71-216-251.cust.tele2.se ([2a00:801:210:fb6:6464:df0e:ccb4:edb0])
        by smtp.googlemail.com with ESMTPSA id h100sm118494lji.58.2017.09.05.05.36.09
        for <linux-btrfs@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256/256);
        Tue, 05 Sep 2017 05:36:10 -0700 (PDT)
Date: Tue, 5 Sep 2017 14:36:06 +0200 (GMT+02:00)
From: A L <crimsoncottage@gmail.com>
To: linux-btrfs@vger.kernel.org
Message-ID: <967c296.1c5a576e.15e520a6623@gmail.com>
In-Reply-To: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Subject: Re: Is autodefrag recommended?
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

There is a drawback in that defragmentation re-dups data that is previously deduped or shared in snapshots/subvolumes.

---- From: Marat Khalili <mkh@rqc.ru> -- Sent: 2017-09-04 - 11:31 ----

> Hello list,
> good time of the day,
> 
> More than once I see mentioned in this list that autodefrag option 
> solves problems with no apparent drawbacks, but it's not the default. 
> Can you recommend to just switch it on indiscriminately on all 
> installations?
> 
> I'm currently on kernel 4.4, can switch to 4.10 if necessary (it's 
> Ubuntu that gives us this strange choice, no idea why it's not 4.9). 
> Only spinning rust here, no SSDs.
> 
> --
> 
> With Best Regards,
> Marat Khalili
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


