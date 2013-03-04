Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52116 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932305Ab3CDWAk (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 4 Mar 2013 17:00:40 -0500
Received: from int-mx10.intmail.prod.int.phx2.redhat.com (int-mx10.intmail.prod.int.phx2.redhat.com [10.5.11.23])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r24M0dln016491
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-btrfs@vger.kernel.org>; Mon, 4 Mar 2013 17:00:39 -0500
Date: Mon, 4 Mar 2013 14:00:34 -0800
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 14/14] btrfs-progs: Error handling in
 scrub_progress_cycle() thread
Message-ID: <20130304220034.GC1658@lenny.home.zabbo.net>
References: <1362436804-16766-1-git-send-email-sandeen@redhat.com>
 <1362436804-16766-15-git-send-email-sandeen@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1362436804-16766-15-git-send-email-sandeen@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

> -	ret = pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
> +	ret = -pthread_setcanceltype(PTHREAD_CANCEL_ASYNCHRONOUS, &old);
>  	if (ret)
> -		return ERR_PTR(-ret);
> +		goto out;

Am I the only one who finds ret = -pthread_*() pretty odd? :)  (ret = -0
on success.. ok.. I guess..)

I'd have done something like

	err = pthread_*()
	if (err) {
		ret = -err;

so that it looks like the -1/errno pattern that our brains already have
to deal with.

- z
