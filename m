Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52606 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753996Ab2K3FkR (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 30 Nov 2012 00:40:17 -0500
Message-ID: <50B846B2.9040700@gmail.com>
Date: Fri, 30 Nov 2012 11:10:02 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
MIME-Version: 1.0
To: Al Viro <viro@ZenIV.linux.org.uk>
CC: Abhijit Pawar <abhi.c.pawar@gmail.com>, linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RESEND PATCH] fs/super.c set_anon_super calling optimization
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com> <508924AB.4060902@gmail.com> <20121026131441.GA22256@andromeda.usersys.redhat.com> <20121130040556.GD4939@ZenIV.linux.org.uk>
In-Reply-To: <20121130040556.GD4939@ZenIV.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/30/2012 09:35 AM, Al Viro wrote:
> On Fri, Oct 26, 2012 at 11:14:41AM -0200, Carlos Maiolino wrote:
>> Hi,
>>
>> On Thu, Oct 25, 2012 at 05:08:19PM +0530, Abhijit Pawar wrote:
>>> Hi,
>>> set_anon_super is called by many filesystems. Some call directly and
>>> some call through the wrapper. Many of them in the wrapper's call to
>>> this function are passing the second argument to this function which
>>> is not used anywhere.
>>>
>>> This patch replaces the second variable with NULL.
>>>
>>
>> If the variable isn't used anymore, why don't just get rid of it, instead of
>> call the function passing a NULL pointer on it?
> 
> 	Because we want it to be a valid sget() callback.  I doubt that this
> optimization is worth doing, though - might even micro-pessimize the things
> on architectures where all arguments are passed in registers.
> 
Al,
Yes. it will be helpful in registers case.

-- 
-
Abhijit
