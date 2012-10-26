Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58101 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758660Ab2JZNOs (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 09:14:48 -0400
Date: Fri, 26 Oct 2012 11:14:41 -0200
From: Carlos Maiolino <cmaiolino@redhat.com>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RESEND PATCH] fs/super.c set_anon_super calling optimization
Message-ID: <20121026131441.GA22256@andromeda.usersys.redhat.com>
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com>
 <508924AB.4060902@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <508924AB.4060902@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

On Thu, Oct 25, 2012 at 05:08:19PM +0530, Abhijit Pawar wrote:
> Hi,
> set_anon_super is called by many filesystems. Some call directly and
> some call through the wrapper. Many of them in the wrapper's call to
> this function are passing the second argument to this function which
> is not used anywhere.
> 
> This patch replaces the second variable with NULL.
> 

If the variable isn't used anymore, why don't just get rid of it, instead of
call the function passing a NULL pointer on it?

-- 
--Carlos
