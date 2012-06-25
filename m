Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:44899 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753488Ab2FYOpF (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 25 Jun 2012 10:45:05 -0400
Message-ID: <4FE8796E.9030300@profihost.ag>
Date: Mon, 25 Jun 2012 16:45:02 +0200
From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs deadlock in 3.5-rc3
References: <4FE58366.8000302@profihost.ag> <4FE862D7.3060005@fusionio.com> <4FE870DF.90308@profihost.ag> <20120625142048.GB7404@localhost.localdomain>
In-Reply-To: <20120625142048.GB7404@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>
> Thats weird, sysrq+w should have a bunch of stacktraces but it's empty, so
> unless theres a bug theres nothing blocked.  Is the box actually hung or is it
> just taking forever?  Maybe try sysrq+w again to see if the one you pasted was
> just a fluke?  Thanks,

This one looks better:
http://pastebin.com/raw.php?i=R4pztDRt

Sorry.

Stefan
