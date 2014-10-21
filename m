Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from zlom.siedziba.pl ([83.144.122.22]:55143 "EHLO zlom.siedziba.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932500AbaJUUVE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 21 Oct 2014 16:21:04 -0400
Message-ID: <5446BEC0.8070009@siedziba.pl>
Date: Tue, 21 Oct 2014 22:14:56 +0200
From: =?UTF-8?B?UGlvdHIgUGF3xYJvdw==?= <pp@siedziba.pl>
MIME-Version: 1.0
To: Tomasz Chmielewski <tch@virtall.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: device balance times
References: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
In-Reply-To: <845c0ca8cc78ed97da487bf7f4b7b122@admin.virtall.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 21.10.2014 20:59, Tomasz Chmielewski wrote:
> FYI - after a failed disk and replacing it I've run a balance; it took 
> almost 3 weeks to complete, for 120 GBs of data:

Looks normal to me. Last time I started a balance after adding 6th 
device to my FS, it took 4 days to move 25GBs of data. Some chunks took 
20 hours to move. I currently have 156 snapshots on this FS (nightly 
rsync backups).

I think it is so slow, because it's disassembling chunks piece by piece 
and stuffing these pieces elsewhere, instead of moving chunks as a 
whole. If you have a lot of little pieces (as I do), it will take a while...

