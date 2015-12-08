Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:48722
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933441AbbLHQYT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 8 Dec 2015 11:24:19 -0500
Subject: Re: Scrub: no spae left on device
To: Marc MERLIN <marc@merlins.org>,
        Lionel Bouton <lionel-subscription@bouton.name>
References: <20151208150638.GL27889@merlins.org>
 <5666F947.5010902@googlemail.com> <5666FB58.2040900@bouton.name>
 <20151208160615.GO27889@merlins.org>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56670430.4070907@googlemail.com>
Date: Tue, 8 Dec 2015 17:24:16 +0100
MIME-Version: 1.0
In-Reply-To: <20151208160615.GO27889@merlins.org>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 12/08/15 17:06, Marc MERLIN wrote:
> Label: 'btrfs_pool1'  uuid: 5ee24229-2431-448a-868e-2c325d10bfa7
> 	Total devices 1 FS bytes used 524.26GiB
> 	devid    1 size 615.01GiB used 614.94GiB path /dev/mapper/pool1
                        ^^^^^^^^^^^^^^^^^^^^^^^^
This is what I was alluding to. You could have started a -dusage balance
*before* the scrub so that one or several data chunks get freed.
Balancing metadata when you're out of space accomplishes nothing and only
will very likely fail, just as you saw. You have ~90GB usable space, but
that space is spread over chunks with low utilisation.

-h

