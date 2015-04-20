Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from www.humilis.net ([80.100.93.5]:38340 "EHLO panda.humilis.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750797AbbDTOHu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 Apr 2015 10:07:50 -0400
Date: Mon, 20 Apr 2015 16:07:48 +0200
From: Sander <sander@humilis.net>
To: Miguel =?iso-8859-1?Q?Negr=E3o?=
	<miguel.negrao-lists@friendlyvirus.org>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: corruption in USB harddrive - backup via send/receive - question
Message-ID: <20150420140748.GA26890@panda>
Reply-To: sander@humilis.net
References: <loom.20150416T202016-456@post.gmane.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <loom.20150416T202016-456@post.gmane.org>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Miguel Negrão wrote (ao):
>  - Given that I'm running a laptop and comunicating with the harddrives via
> USB, is it expected that I will get some corruption from time to time or is
> this abnormal

Abnormal. I have three Intel ssd's usb connected to an Arndale. Two of
them have luks and btrfs raid0 on top, and is used as a home server. The
third ssd is plain btrfs, and used for backup archives.

	Sander
