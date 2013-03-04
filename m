Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:23775 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932373Ab3CDXMn (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 18:12:43 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24NChht019284
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 18:12:43 -0500
Date: Mon, 4 Mar 2013 15:12:42 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/14 V2] btrfs-progs: Error handling in
 scrub_progress_cycle() thread
Message-ID: <20130304231242.GE1658@lenny.home.zabbo.net>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
 <1362436804-16766-15-git-send-email-sandeen@redhat.com>
 <51352411.7080601@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <51352411.7080601@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> +	perr = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	if (perr)
> +		goto out;
>  

> +out:
> +	if (peer_fd != -1)
> +		close(peer_fd);
> +	if (perr)
> +		ret = -perr;
> +	return ERR_PTR(ret);
>  }

Great, that's a lot clearer.  Thanks.

- z
