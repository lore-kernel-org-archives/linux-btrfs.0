Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from okda.pipebreaker.pl ([176.56.236.173]:57242 "EHLO
        okda.pipebreaker.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751809AbdBHSoo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 8 Feb 2017 13:44:44 -0500
Received: from 185-6-29-55-rev.logitus.pl ([185.6.29.55] helo=mother.pipebreaker.pl)
        by okda.pipebreaker.pl with esmtps (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.87_1)
        (envelope-from <zdzichu@mother.pipebreaker.pl>)
        id 1cbSb6-000bz5-Bn
        for linux-btrfs@vger.kernel.org; Wed, 08 Feb 2017 14:47:48 +0100
Date: Wed, 8 Feb 2017 14:46:47 +0100
From: Tomasz Torcz <tomek@pipebreaker.pl>
To: linux-btrfs@vger.kernel.org
Subject: Re: raid1: cannot add disk to replace faulty because can only mount
 fs as read-only.
Message-ID: <20170208134647.GA86702@mother.pipebreaker.pl>
References: <YAvBcoM9EImXYYAvCcegSf@videotron.ca>
 <a5262907-06f2-2c6f-d23a-2703b10429b7@deragon.biz>
 <pan$be2e$8a233bb0$f63eb0cb$d3413db@cox.net>
 <20170201115530.l2ce5afcqld2kzi4@angband.pl>
 <pan$27de1$6045e2b1$7cc1684e$e9aac1ad@cox.net>
 <7cb699fd-44a7-d8eb-e492-c448f67b0eac@gmail.com>
 <20170202142521.nfiy73ye6bi5smjv@angband.pl>
 <ZIyPcL4cW36fIZIyQcB9Hs@videotron.ca>
 <6e26ee22-3d67-d2aa-22b7-c03f9ffc18f2@deragon.biz>
 <6e4b9b4f-d4df-5679-5645-a52dbc15b424@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <6e4b9b4f-d4df-5679-5645-a52dbc15b424@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Feb 08, 2017 at 07:50:22AM -0500, Austin S. Hemmelgarn wrote:
>  It is exponentially safer in BTRFS
> to run single data single metadata than half raid1 data half raid1 metadata.

  Why?
 
> To convert to profiles _designed_ for a single device and then convert back
> to raid1 when I got another disk.  The issue you've stumbled across is only
> partial motivation for this, the bigger motivation is that running half a 2
> disk array is more risky than running a single disk by itself.

  Again, why?  What's the difference?  What causes increased risk?

-- 
Tomasz Torcz                Only gods can safely risk perfection,
xmpp: zdzichubg@chrome.pl     it's a dangerous thing for a man.  -- Alia

