Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:52762
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679AbbL0OsI (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 27 Dec 2015 09:48:08 -0500
Subject: Re: How to change BTRFS filesystem UUID
To: Jiri Kanicky <j@ganomi.com>, linux-btrfs@vger.kernel.org
References: <567FF63E.3010106@ganomi.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <567FFA26.9070101@googlemail.com>
Date: Sun, 27 Dec 2015 15:48:06 +0100
MIME-Version: 1.0
In-Reply-To: <567FF63E.3010106@ganomi.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/27/15 15:31, Jiri Kanicky wrote:
> Is there a way to change the BTRFS ID (generate new one) that I can
> differentiate between the two disks on one host?

btrfstune:

    -u
       Change fsid to a randomly generated UUID or continue previous
       fsid change operation in case it was interrupted.

should do what you need.

-h
