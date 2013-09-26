Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:34846 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775Ab3IZOQK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 26 Sep 2013 10:16:10 -0400
Date: Thu, 26 Sep 2013 16:16:06 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Josef Bacik <jbacik@fusionio.com>
Cc: linux-btrfs@vger.kernel.org, walken@google.com,
        linux-kernel@vger.kernel.org, peter@hurleysoftware.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] rwsem: add rwsem_is_contended V3
Message-ID: <20130926141606.GA32444@gmail.com>
References: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1380201996-17445-1-git-send-email-jbacik@fusionio.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


* Josef Bacik <jbacik@fusionio.com> wrote:

> Btrfs needs a simple way to know if it needs to let go of it's read lock on a
> rwsem.  Introduce rwsem_is_contended to check to see if there are any waiters on
> this rwsem currently.  This is just a hueristic, it is meant to be light and not
> 100% accurate and called by somebody already holding on to the rwsem in either
> read or write.  Thanks,
> 
> Signed-off-by: Josef Bacik <jbacik@fusionio.com>

Acked-by: Ingo Molnar <mingo@kernel.org>

Thanks,

	Ingo
