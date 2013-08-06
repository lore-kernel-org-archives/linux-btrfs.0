Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:13785 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753940Ab3HFD6D (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Aug 2013 23:58:03 -0400
Date: Mon, 5 Aug 2013 20:57:57 -0700
From: Zach Brown <zab@redhat.com>
To: Eric Sandeen <sandeen@redhat.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Miao Xie <miaox@cn.fujitsu.com>
Subject: Re: [PATCH] btrfs-progs: don't overrun "answer" array in cmds-chunk.c
Message-ID: <20130806035757.GL12314@lenny.home.zabbo.net>
References: <52006509.1060207@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <52006509.1060207@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 05, 2013 at 09:52:57PM -0500, Eric Sandeen wrote:
> If an array is 5 chars in size:
> 
>        char answer[5];
> 
> and we write the 6th char (counting from 0)...
> 
>        answer[5] = '\0';

*high fives*

> -	answer[5] = '\0';
> +	answer[4] = '\0';

I went to see which way of avoiding another magical raw constant would
be best and did a bit of a double take.

If you're in here, want to reimplement this thing in a few lines of
scanf(%s) and strcasecmp()?  I can give it a go if you don't want to.

- z
