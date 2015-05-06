Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37295 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751345AbbEFD4j (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 5 May 2015 23:56:39 -0400
Received: by igblo3 with SMTP id lo3so6066782igb.0
        for <linux-btrfs@vger.kernel.org>; Tue, 05 May 2015 20:56:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAN05THQbAqQCqGcgNSx5f5h58LnX7z8XqB60434Eed+5gbFLHw@mail.gmail.com>
References: <5548F177.1040309@linuxmail.org>
	<pan.2015.05.05.17.03.19@googlemail.com>
	<55490697.8020702@linuxmail.org>
	<CAN05THQbAqQCqGcgNSx5f5h58LnX7z8XqB60434Eed+5gbFLHw@mail.gmail.com>
Date: Tue, 5 May 2015 21:56:38 -0600
Message-ID: <CAJCQCtR9XTdHZMfTrjZzinQxDjOqjXE8NB4+=ssQSfM6sXvC=g@mail.gmail.com>
Subject: Re: hard lockup while balance was running killed my raid5
From: Chris Murphy <lists@colorremedies.com>
To: ronnie sahlberg <ronniesahlberg@gmail.com>
Cc: Perry Gilfillan <perrye@linuxmail.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, May 5, 2015 at 9:46 PM, ronnie sahlberg
<ronniesahlberg@gmail.com> wrote:
> In my experience,
> parent transid verify failed on 27198603952128 wanted 291431 found 291859
>
> This probably means your filesystem is toast and you have total dataloss.

The generations aren't that far apart, there's a decent chance that
btrfs restore can work.

What we don't know is everything leading up to this point, because
obviously a btrfs raid6 should be mountable degraded in the face of a
single device failure.

-- 
Chris Murphy
