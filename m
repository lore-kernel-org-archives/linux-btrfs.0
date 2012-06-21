Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from lulu.zabbo.net ([69.168.54.52]:56297 "EHLO lulu.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760295Ab2FUVKM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 21 Jun 2012 17:10:12 -0400
Received: from [192.168.242.10] (50-193-208-193-static.hfc.comcastbusiness.net [50.193.208.193])
	(using TLSv1 with cipher DHE-RSA-CAMELLIA256-SHA (256/256 bits))
	(No client certificate requested)
	by lulu.zabbo.net (Postfix) with ESMTPSA id F28942216DB
	for <linux-btrfs@vger.kernel.org>; Thu, 21 Jun 2012 14:10:11 -0700 (PDT)
Message-ID: <4FE38DB3.2090306@zabbo.net>
Date: Thu, 21 Jun 2012 14:10:11 -0700
From: Zach Brown <zab@zabbo.net>
MIME-Version: 1.0
To: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: flush delayed inodes if we're short on space
References: <1340304875-8111-1-git-send-email-jbacik@fusionio.com> <4FE376F3.5030609@zabbo.net> <4FE37F3C.2020102@fusionio.com>
In-Reply-To: <4FE37F3C.2020102@fusionio.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Ugh sorry I just dug this patch out from last week and forgot I had just
> picked an arbitrary number to make sure it was working. You are correct,
> what I _meant_ to do (and will do after I respond) was calculate how
> much we wanted to flush and then divide that by how much the delayed
> inodes reserve and then multiply it by 2 for good measure.

I guess that's as good a place as any to start :)

It'd be nice to see some data on how often this actually stops the full
run.  If it doesn't, just pitch the whole _NR path entirely?

- z
