Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from srv1.host37.de ([176.28.54.59]:50208 "EHLO srv1.host37.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757308AbbBELE1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 5 Feb 2015 06:04:27 -0500
Received: from [172.18.1.5] (pc3.gatrobe.uni-hannover.de [130.75.178.3])
	(using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by srv1.host37.de (Postfix) with ESMTPSA id 53FF11116
	for <linux-btrfs@vger.kernel.org>; Thu,  5 Feb 2015 11:41:19 +0100 (CET)
Content-Type: text/plain; charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 8.1 \(1993\))
Subject: Re: Deadlock on 3.18.5
From: Juergen Fitschen <me@jue.yt>
In-Reply-To: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt>
Date: Thu, 5 Feb 2015 12:04:25 +0100
Message-Id: <C90D8017-3361-4B95-99E8-859958AF5D28@jue.yt>
References: <2BFED81A-1A34-4A4B-800A-A4B6286B74C7@jue.yt>
To: linux-btrfs@vger.kernel.org
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey,

It’s me again.
First of all: Thanks for the reply, Duncan :)

After detecting the deadlock und posting the stack trace yesterday evening, I left the machine alone and didn’t rebooted it. The monitoring told me that the whole server (including the hypervisor) became unreachable a few minutes after I fetched the stack trace from syslog.

But now - as I just realised - the server is back alive, the process finished successfully and the volume is accessible. So the deadlock was not a real deadlock or resolved itself magically without me doing anything. The syslog reports several stack traces from kworker for about 2 hours (the time the server was not reachable). Within the first hour syslog was completely silent. Within the second hour the kernel complains about that rcu_sched dected stalls on the CPU in an interval of 3 minutes.

What do you think?

Regards,
  Juergen

