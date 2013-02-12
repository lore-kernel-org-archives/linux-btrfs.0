Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.schleiser.de ([188.40.153.226]:43403 "EHLO
	mail.schleiser.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758485Ab3BLPYl (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 12 Feb 2013 10:24:41 -0500
Message-ID: <511A5CE1.60309@schleiser.de>
Date: Tue, 12 Feb 2013 16:16:49 +0100
From: Kaspar Schleiser <kaspar@schleiser.de>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Chris Mason <chris.mason@fusionio.com>
Subject: Re: experimental raid5/6 code in git
References: <20130202160212.GB4694@shiny>
In-Reply-To: <20130202160212.GB4694@shiny>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

On 02/02/2013 05:02 PM, Chris Mason wrote:
> Btrfs -- 604MB/s
> MD    -- 162MB/s
> 
> 
> MD -- 800MB/s very little system time
> Btrfs -- 3.8GB/s one CPU mostly pegged

> Btrfs -- 380MB/s seen by fio
> MD    -- 174MB/s seen by fio

> Creating 12 million files on Btrfs raid5 took 226 seconds, vs 485
> seconds on MD.

Do I read these numbers incorrectly, or does even this first iteration
of btrfs' raid5/6 code run circles around MD?

Thanks for all the work!

Kaspar
