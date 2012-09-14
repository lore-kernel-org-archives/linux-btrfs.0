Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:58060 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751213Ab2INNbh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 14 Sep 2012 09:31:37 -0400
Date: Fri, 14 Sep 2012 15:31:17 +0200
From: David Sterba <dave@jikos.cz>
To: Wei Yongjun <weiyj.lk@gmail.com>
Cc: chris.mason@fusionio.com, yongjun_wei@trendmicro.com.cn,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs: using for_each_set_bit_from to simplify the code
Message-ID: <20120914133117.GL17430@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAPgLHd_pvtMjXoJWaOSGG-DprQVECpWtYc9SoTAXYcyX4wiq7A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAPgLHd_pvtMjXoJWaOSGG-DprQVECpWtYc9SoTAXYcyX4wiq7A@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 14, 2012 at 10:29:02AM +0800, Wei Yongjun wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> 
> Using for_each_set_bit_from() to simplify the code.
> 
> spatch with a semantic match is used to found this.
> (http://coccinelle.lip6.fr/)
> 
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
Reviewed-by: David Sterba <dsterba@suse.cz>
