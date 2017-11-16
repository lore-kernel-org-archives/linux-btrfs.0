Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-lf0-f53.google.com ([209.85.215.53]:43555 "EHLO
        mail-lf0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934705AbdKPMwB (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 16 Nov 2017 07:52:01 -0500
Received: by mail-lf0-f53.google.com with SMTP id x68so6034003lff.0
        for <linux-btrfs@vger.kernel.org>; Thu, 16 Nov 2017 04:52:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <37eb6ee9-2f7e-de42-3f7c-32db11d7648a@gmail.com>
References: <CAK5rZE51onZEE_f2xg4nxPriU9YQq5AARDLs-BTZL2RaGSCTXA@mail.gmail.com>
 <43412efa-ff56-9682-c8f7-a5966b87b10e@lukas-pirl.de> <CAK5rZE7rLToV7t+6pZhTbN2+JQj=W67Y5mESNhpaF0ehZzObOA@mail.gmail.com>
 <361d92ee-9aee-35e1-024d-45ec5b79902b@gmail.com> <pan$c02ea$c0c093a$d0320b0d$d9d43196@cox.net>
 <37eb6ee9-2f7e-de42-3f7c-32db11d7648a@gmail.com>
From: Imran Geriskovan <imran.geriskovan@gmail.com>
Date: Thu, 16 Nov 2017 14:51:59 +0200
Message-ID: <CAK5rZE5+6Mx1LJURkX3utQjQdAEu4fPMuWRi8kTwcrFwrmPc6Q@mail.gmail.com>
Subject: Re: zstd compression
To: linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/16/17, Austin S. Hemmelgarn <ahferroin7@gmail.com> wrote:
> I'm pretty sure defrag is equivalent to 'compress-force', not
> 'compress', but I may be wrong.

Are there any devs to confirm this?
