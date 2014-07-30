Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tetsuo.zabbo.net ([50.193.208.193]:39773 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479AbaG3Uvt (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 16:51:49 -0400
Date: Wed, 30 Jul 2014 13:51:48 -0700
From: Zach Brown <zab@zabbo.net>
To: Josef Bacik <jbacik@fb.com>
Cc: Nicholas Krause <xerofoify@gmail.com>, clm@fb.com,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Remove certain calls for releasing page cache
Message-ID: <20140730205148.GA25256@lenny.home.zabbo.net>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
 <53D959D0.1020303@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53D959D0.1020303@fb.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Jul 30, 2014 at 04:47:12PM -0400, Josef Bacik wrote:
> On 07/30/2014 04:42 PM, Nicholas Krause wrote:
> >This patch removes the lines for releasing the page cache in certain
> >files as this may aid in perfomance with writes in the compression
> >rountines of btrfs. Please note that this patch has not been tested
> >on my own hardware due to no compression based btrfs volumes of my
> >own.
> >
> 
> http://37.media.tumblr.com/tumblr_m44v95k9Y11qjhgo6o1_250.gif

https://www.youtube.com/watch?v=jVfkYZmXHAg

- z
