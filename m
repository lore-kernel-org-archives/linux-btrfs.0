Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from ns.bouton.name ([109.74.195.142]:41338 "EHLO mail.bouton.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755075AbbLHPtc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 8 Dec 2015 10:49:32 -0500
Subject: Re: Scrub: no spae left on device
To: Marc MERLIN <marc@merlins.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <20151208150638.GL27889@merlins.org>
From: Lionel Bouton <lionel-subscription@bouton.name>
Message-ID: <5666F9CF.6050300@bouton.name>
Date: Tue, 8 Dec 2015 16:39:59 +0100
MIME-Version: 1.0
In-Reply-To: <20151208150638.GL27889@merlins.org>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 08/12/2015 16:06, Marc MERLIN a écrit :
> Howdy,
>
> Why would scrub need space and why would it cancel if there isn't enough of
> it?
> (kernel 4.3)
>
> /etc/cron.daily/btrfs-scrub:
> btrfs scrub start -Bd /dev/mapper/cryptroot
> scrub device /dev/mapper/cryptroot (id 1) done
> 	scrub started at Mon Dec  7 01:35:08 2015 and finished after 258 seconds
> 	total bytes scrubbed: 130.84GiB with 0 errors
> btrfs scrub start -Bd /dev/mapper/pool1
> ERROR: scrubbing /dev/mapper/pool1 failed for device id 1 (No space left on device)
> scrub device /dev/mapper/pool1 (id 1) canceled

I can't be sure (not-a-dev), but one possibility that comes to mind is
that if an error is detected writes must be done on the device. The
repair might not be done in-place but with CoW and even if the error is
not repaired by lack of redundancy IIRC each device tracks the number of
errors detected so I assume this is written somewhere (system or
metadata chunks most probably).

Best regards,

Lionel
