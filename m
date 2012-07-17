Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:39053 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab2GQMnM (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Jul 2012 08:43:12 -0400
Date: Tue, 17 Jul 2012 14:43:10 +0200
From: David Sterba <dave@jikos.cz>
To: Pierre Carrier <pierre@spotify.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/2] utils.c: fix sizes in B & malloc in pretty_sizes
Message-ID: <20120717124310.GD11226@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1341853347-11788-2-git-send-email-pierre@spotify.com>
 <1341854974-14502-1-git-send-email-pierre@spotify.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1341854974-14502-1-git-send-email-pierre@spotify.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 09, 2012 at 05:29:34PM +0000, Pierre Carrier wrote:
> Before, sizes below 1KB are still displayed in KB,
> but without a unit.

Does it matter when the only size below 1KB one can get is 0 ? Though
for sake of consistency the B unit could be there in that case as well.
