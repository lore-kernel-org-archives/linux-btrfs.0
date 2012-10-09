Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.fusionio.com ([66.114.96.30]:44841 "EHLO mx1.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754275Ab2JINjN (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 9 Oct 2012 09:39:13 -0400
Date: Tue, 9 Oct 2012 09:39:10 -0400
From: Chris Mason <chris.mason@fusionio.com>
To: Wang Sheng-Hui <shhuiw@gmail.com>
CC: Chris Mason <clmason@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: remove repeated eb->pages check in,
 disk-io.c/csum_dirty_buffer
Message-ID: <20121009133910.GA9275@shiny>
References: <5072D477.3070303@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <5072D477.3070303@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Oct 08, 2012 at 07:26:15AM -0600, Wang Sheng-Hui wrote:
> In csum_dirty_buffer, we first get eb from page->private.
> Then we check if the page is the first page of eb. Later
> we check it again. Remove the repeated check here.

You had the right idea here, two checks and one has a warning, so you
kept the warning.  But when the metadata block size is bigger than a
page, the WARN_ON triggers for any page that isn't the first one in the
extent buffer.

I kept this commit but removed the WARN_ON(1)

-chris
