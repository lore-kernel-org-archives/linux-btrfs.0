Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from vs2.lukas-pirl.de ([5.45.100.90]:44190 "EHLO pim.lukas-pirl.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751302AbbK0IK7 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 27 Nov 2015 03:10:59 -0500
Subject: Re: How to detect / notify when a raid drive fails?
To: Ian Kelling <ian@iankelling.org>
References: <1448601297.4093478.451242913.1CEE0D6D@webmail.messagingengine.com>
 <pan$2baa9$6d4c6e73$140f6177$488caa5a@cox.net>
 <1448610141.801244.451299857.5EBE7B93@webmail.messagingengine.com>
Cc: linux-btrfs@vger.kernel.org, 1i5t5.duncan@cox.net
From: Lukas Pirl <btrfs@lukas-pirl.de>
Message-ID: <5658100A.4020401@lukas-pirl.de>
Date: Fri, 27 Nov 2015 21:10:50 +1300
MIME-Version: 1.0
In-Reply-To: <1448610141.801244.451299857.5EBE7B93@webmail.messagingengine.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi Ian,

On 11/27/2015 08:42 PM, Ian Kelling wrote as excerpted:
> Great info, thanks. Just trying to write a file, sync and read it
> sounds like the easiest test for now, especially since I don't
> know what the write fail log entries will look like. And setting
> up SMART notifications.

SMART notifications e.g. from smartmontools are definitively useful.

Also, as Duncan wrote, errors are likely to pile up in your kernel log
if SATA/BTRFS/… errors occur.
Regarding those, tools such as logcheck can be useful that email you if
they think they found something interesting in the logs.
Depending on the verbosity you can withstand, logcheck can be a bit
work in order to configure it in a way that it does not flood your
inbox with useless emails. However, logcheck usually ships with
reasonable defaults.

Best,

Lukas
