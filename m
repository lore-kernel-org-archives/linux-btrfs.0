Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:51437 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755362Ab2FNJK7 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 14 Jun 2012 05:10:59 -0400
Message-ID: <4FD9AAA0.2040802@gmx.net>
Date: Thu, 14 Jun 2012 11:10:56 +0200
From: Arne Jansen <sensille@gmx.net>
MIME-Version: 1.0
To: Jordan Windsor <jordanw2@gmail.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: Question, Does BTRFS provide a read speed increase with RAID1
References: <CACCfv7q83FYmrcVO3TwMwX2HmNZpkdO=uJOTtR1X9E7_wUWz9w@mail.gmail.com>
In-Reply-To: <CACCfv7q83FYmrcVO3TwMwX2HmNZpkdO=uJOTtR1X9E7_wUWz9w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 14.06.2012 11:08, Jordan Windsor wrote:
> Hello,
> I was wondering if I setup a array via BTRFS as RAID1 will I get a
> read speed increase? (multiplied by the amount of harddrives)

Only if you read from multiple processes (or threads). Currently
the lowest-order bit of the pid is used to choose the mirror to
read from.

> Thanks.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

