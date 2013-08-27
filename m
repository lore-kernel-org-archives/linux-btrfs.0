Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:34816 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab3H0D4b (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 26 Aug 2013 23:56:31 -0400
Date: Tue, 27 Aug 2013 11:56:18 +0800
From: Tomasz Chmielewski <tch@virtall.com>
To: Hugo Mills <hugo@carfax.org.uk>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: failed to read log tree, open_ctree failed
Message-ID: <20130827115618.414ca040@virtall.com>
In-Reply-To: <20130826190146.GN3115@carfax.org.uk>
References: <20130827022509.57de1ab2@virtall.com>
	<20130826183419.GM3115@carfax.org.uk>
	<20130827024748.0da8cb46@virtall.com>
	<20130826190146.GN3115@carfax.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 26 Aug 2013 20:01:46 +0100
Hugo Mills <hugo@carfax.org.uk> wrote:

> > Anything else I can try?
> 
>    Oh, hang on... that's the log tree.
> 
>    btrfs-zero-log may help. If you can take a btrfs-image of the
> filesystem before running that, josef would like to see it.

btrfs-zero-log did the trick, thanks.

-- 
Tomasz Chmielewski
http://wpkg.org
