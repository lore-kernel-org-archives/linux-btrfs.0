Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp65.iad3a.emailsrvr.com ([173.203.187.65]:39202 "EHLO
        smtp65.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752482AbdKGE4h (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 23:56:37 -0500
Date: Tue, 07 Nov 2017 07:56:24 +0300
In-Reply-To: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
References: <CAJCQCtSY+nso=URaU+2-qN2EWrxA7m1djcWhUAJTmjxW0yGa8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Subject: Re: Should cp default to reflink?
To: Chris Murphy <lists@colorremedies.com>,
        Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <83650C67-4053-450C-90BB-BC4D1599636C@rqc.ru>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Obviously (for me) yes, but who will decide? There should be --no-reflink for people trying to defragment something.

>Seems to me any request to duplicate should be optimized by default
>with an auto reflink when possible, and require an explicit option to
>inhibit.

Key word is "any". I much more often use rsync than cp within the same volume. 
-- 

With Best Regards,
Marat Khalili
