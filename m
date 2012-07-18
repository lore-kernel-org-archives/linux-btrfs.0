Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:55498 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751853Ab2GRL5v (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Jul 2012 07:57:51 -0400
Date: Wed, 18 Jul 2012 13:57:35 +0200
From: David Sterba <dave@jikos.cz>
To: Liu Bo <liubo2009@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org, chris.mason@fusionio.com, JBacik@fusionio.com
Subject: Re: [PATCH v3] Btrfs: improve multi-thread buffer read
Message-ID: <20120718115735.GI11226@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1342461925-22495-1-git-send-email-liubo2009@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 16, 2012 at 02:05:25PM -0400, Liu Bo wrote:
> v2->v3: adopt kernel native pagevec instead of kmalloc.

Do we really use the pagevec features here? It looks more like a fancy
way to employ a simple array ...

And with a simple array we could use 16 page pointers covering 16 * 4k =
64k bytes which looks more friendly than 14 * 4K = 56K (available in a
pagevec). This may have a negative effect on the troughput, but I
haven't measured that. Can you please benchmark it against pagevec?


david
