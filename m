Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from dkim1.fusionio.com ([66.114.96.53]:50241 "EHLO
	dkim1.fusionio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755328Ab3ETROJ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 20 May 2013 13:14:09 -0400
Received: from mx2.fusionio.com (unknown [10.101.1.160])
	by dkim1.fusionio.com (Postfix) with ESMTP id 3FAD47C042D
	for <linux-btrfs@vger.kernel.org>; Mon, 20 May 2013 11:14:08 -0600 (MDT)
Date: Mon, 20 May 2013 13:14:05 -0400
From: Josef Bacik <jbacik@fusionio.com>
To: Wang Shilong <wangshilong1991@gmail.com>
CC: Josef Bacik <JBacik@fusionio.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH] Btrfs: fix estale with btrfs send
Message-ID: <20130520171405.GK1765@localhost.localdomain>
References: <b187dmcaigs812gqdmx0i9qh.1369064934798@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <b187dmcaigs812gqdmx0i9qh.1369064934798@email.android.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, May 20, 2013 at 09:48:54AM -0600, Wang Shilong wrote:
> Hello Josef,
> It seems you missed Reported-by in changelog~_~
> 

Yup I'll fix it up in my tree, thanks,

Josef
