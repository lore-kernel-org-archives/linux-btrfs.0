Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2120.oracle.com ([156.151.31.85]:39168 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752425AbdLHAvO (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Thu, 7 Dec 2017 19:51:14 -0500
Subject: Re: [PATCH v5 0/3] Add cli and ioctl to deregister devices
To: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>, linux-btrfs@vger.kernel.org
References: <20171207143623.26710-1-anand.jain@oracle.com>
 <2ff368d4-a38a-59c9-565a-8c55702217ae@gmail.com>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <2eb9cb20-e972-f642-d116-2d7dc4417fe8@oracle.com>
Date: Fri, 8 Dec 2017 08:51:43 +0800
MIME-Version: 1.0
In-Reply-To: <2ff368d4-a38a-59c9-565a-8c55702217ae@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 12/07/2017 10:52 PM, Austin S. Hemmelgarn wrote:
> On 2017-12-07 09:36, Anand Jain wrote:
>> Add ability to deregister a or all devices. I have named this sub cmd
>> as deregister, but I am open to your suggestions.
> Being a bit picky here, but from the perspective of a native speaker of 
> American English, I would say that 'deregister' sounds rather synthetic 
> and somewhat harsh and alien.
> 
> Given that, as odd as it sounds, I think 'ignore' might be a more user 
> friendly name for the sub-command.  It accurately describes what the 
> command is doing (telling the kernel to ignore the device), and it's a 
> lot less alien sounding than 'deregister'.
> 
> If you're set on having it be based on the word 'register', I would 
> suggest changing it to 'unregister', as I think that sounds more natural 
> than 'deregister'.
> 
> Additionally, if you do continue with 'deregister' or go with 
> 'unregister' as the name though, I would suggest adding 'register' as a 
> synonym for the 'scan' sub-command to keep things reasonably symmetrical.

  A look up on unregister lead me to use deregister as more appropriate.
  Anyway I won't bother much, I will be go be suggestions, and how
  about unscan, since scan is already there. OR how about purge.

Thanks, Anand.

