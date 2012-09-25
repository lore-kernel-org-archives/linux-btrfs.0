Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:50592 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753304Ab2IYKOn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 06:14:43 -0400
Date: Tue, 25 Sep 2012 12:14:29 +0200
From: David Sterba <dave@jikos.cz>
To: zwu.kernel@gmail.com
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, dave@jikos.cz, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: Fix up memory leakage
Message-ID: <20120925101429.GR14582@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
 <1348538536-29838-3-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1348538536-29838-3-git-send-email-zwu.kernel@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Sep 25, 2012 at 10:02:16AM +0800, zwu.kernel@gmail.com wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
>   Some code pathes forget to free memory on exit.

Same as with the fd's, kernel will free all memory for us at exit().

If there's lots of memory allocated, it may be even faster to leave the
unallocation process to kernel as it will do it in one go, while the
application would unnecessarily free it chunk by chunk.

david
