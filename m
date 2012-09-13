Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:43157 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754448Ab2IMQRv (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Sep 2012 12:17:51 -0400
Date: Thu, 13 Sep 2012 18:17:49 +0200
From: David Sterba <dave@jikos.cz>
To: Sonu <p10sonu@yahoo.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: do_sync_write and do_sync_read
Message-ID: <20120913161749.GD17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1347552515.49957.YahooMailNeo@web190105.mail.sg3.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1347552515.49957.YahooMailNeo@web190105.mail.sg3.yahoo.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 12:08:35AM +0800, Sonu wrote:
> trying to locate do_sync_read (write) any idea where are they ?

fs/read_write.c
