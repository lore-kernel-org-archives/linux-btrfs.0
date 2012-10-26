Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-da0-f46.google.com ([209.85.210.46]:61340 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932921Ab2JZNlL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 26 Oct 2012 09:41:11 -0400
Message-ID: <508A92DF.6000003@gmail.com>
Date: Fri, 26 Oct 2012 19:10:47 +0530
From: Abhijit Pawar <abhi.c.pawar@gmail.com>
MIME-Version: 1.0
To: linux-fsdevel@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: [RESEND PATCH] fs/super.c set_anon_super calling optimization
References: <CA+kxV1F5VxBGawhkV=02LcgHNWiKF-H_k6N-d1TEYNeFAScezg@mail.gmail.com> <508924AB.4060902@gmail.com> <20121026131441.GA22256@andromeda.usersys.redhat.com>
In-Reply-To: <20121026131441.GA22256@andromeda.usersys.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/26/2012 06:44 PM, Carlos Maiolino wrote:
> Hi,
>
> On Thu, Oct 25, 2012 at 05:08:19PM +0530, Abhijit Pawar wrote:
>> Hi,
>> set_anon_super is called by many filesystems. Some call directly and
>> some call through the wrapper. Many of them in the wrapper's call to
>> this function are passing the second argument to this function which
>> is not used anywhere.
>>
>> This patch replaces the second variable with NULL.
>>
>
> If the variable isn't used anymore, why don't just get rid of it, instead of
> call the function passing a NULL pointer on it?
At the moment its a callback function with two params so that 
filesystems are free to override it while mounting. This is to support 
filesystem specific information at mount time.

nfs uses it to get its server specific information. btrfs uses it to 
populate its filesystem information. So the signature can not be changed 
without affecting these filesystems.

sysfs, ceph, 9p will also be affected if we are to change the signature.

>


-- 
-
Abhijit
