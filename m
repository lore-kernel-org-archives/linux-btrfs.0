Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f171.google.com ([209.85.223.171]:38836 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750929AbaKZBxh (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Nov 2014 20:53:37 -0500
Received: by mail-ie0-f171.google.com with SMTP id rl12so1789132iec.2
        for <linux-btrfs@vger.kernel.org>; Tue, 25 Nov 2014 17:53:37 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAJCQCtSYFBj=KLZpdB5J+mXZwE5SCAR-H9mz5BXpsukOOp8SZQ@mail.gmail.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<E47EA20E-375D-49A6-B4B0-C6594CE6A633@colorremedies.com>
	<546CB332.3080705@ubuntu.com>
	<CAJCQCtTfhxW2w+mT6rqyr+WwVdj8SAEAGV+LB8_S3mcw0agxaw@mail.gmail.com>
	<5474F5D1.2070908@ubuntu.com>
	<CAJCQCtSYFBj=KLZpdB5J+mXZwE5SCAR-H9mz5BXpsukOOp8SZQ@mail.gmail.com>
Date: Tue, 25 Nov 2014 20:53:37 -0500
Message-ID: <CAGfcS_=SAnwfTSVodAPjdwmL9PUijoK2gf7+X7MNpET+_-DXOA@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Rich Freeman <r-btrfs@thefreemanclan.net>
To: Chris Murphy <lists@colorremedies.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Nov 25, 2014 at 6:13 PM, Chris Murphy <lists@colorremedies.com> wrote:
> A few years ago companies including Western Digital started shipping
> large cheap drives, think of the "green" drives. These had very high
> TLER (Time Limited Error Recovery) settings, a.k.a. SCT ERC. Later
> they completely took out the ability to configure this error recovery
> timing so you only get the upward of 2 minutes to actually get a read
> error reported by the drive.

Why sell an $80 hard drive when you can change a few bytes in the
firmware and sell a crippled $80 drive and an otherwise-identical
non-crippled $130 drive?

--
Rich
