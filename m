Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:60405 "EHLO
        smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751773AbdIEOBW (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 5 Sep 2017 10:01:22 -0400
Subject: Re: Is autodefrag recommended? -- re-duplication???
From: Marat Khalili <mkh@rqc.ru>
To: linux-btrfs@vger.kernel.org
References: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Cc: Henk Slager <eye1tm@gmail.com>, Duncan <1i5t5.duncan@cox.net>,
        Hugo Mills <hugo@carfax.org.uk>,
        "Austin S. Hemmelgarn" <ahferroin7@gmail.com>,
        Henk Slager <eye1tm@gmail.com>, A L <crimsoncottage@gmail.com>
Message-ID: <82e453bf-ff11-a911-c432-3e0173b223b2@rqc.ru>
Date: Tue, 5 Sep 2017 17:01:10 +0300
MIME-Version: 1.0
In-Reply-To: <710ec5d1-adbf-4ce5-50a5-8b8266ccb672@rqc.ru>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Dear experts,

At first reaction to just switching autodefrag on was positive, but 
mentions of re-duplication are very scary. Main use of BTRFS here is 
backup snapshots, so re-duplication would be disastrous.

In order to stick to concrete example, let there be two files, 4KB and 
4GB in size, referenced in read-only snapshots 100 times each, and some 
4KB of both files are rewritten each night and then another snapshot is 
created (let's ignore snapshots deletion here). AFAIU 8KB of additional 
space (+metadata) will be allocated each night without autodefrag. With 
autodefrag will it be perhaps 4KB+128KB or something much worse?

--

With Best Regards,
Marat Khalili

