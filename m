Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from syrinx.knorrie.org ([82.94.188.77]:36342 "EHLO
        syrinx.knorrie.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751566AbdBXAkt (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 23 Feb 2017 19:40:49 -0500
Subject: Re: Subvolume corruption after restart on Raid1 array
To: Kenneth Bogert <kbogert@unca.edu>, linux-btrfs@vger.kernel.org
References: <FD81BC09-DB74-45F5-87AD-574E98C80374@unca.edu>
 <C6BE2251-0151-4818-866D-46D68C657DCB@unca.edu>
 <36F10428-FA2D-42F2-9065-8AFD7B6AF902@unca.edu>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d6787fb0-3bfc-987c-bdd8-33c154faa443@mendix.com>
Date: Fri, 24 Feb 2017 01:15:54 +0100
MIME-Version: 1.0
In-Reply-To: <36F10428-FA2D-42F2-9065-8AFD7B6AF902@unca.edu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 02/23/2017 05:42 PM, Kenneth Bogert wrote:
> 
>> On Feb 17, 2017, at 1:39 PM, Kenneth Bogert <kbogert@unca.edu> wrote:
>>
>> On Feb 11, 2017, at 12:34 PM, Kenneth Bogert <kbogert@unca.edu> wrote:
>>>
>>> kernel: BTRFS error (device sdb): parent transid verify failed on 1721409388544 wanted 19188 found 83121
>>> [...]
> 
> Is anyone interested in this problem?  If not, I’m planning on rebuilding this filesystem this weekend.

Only this: "kernel: BTRFS error (device sdb): parent transid verify
failed on 1721409388544 wanted 19188 found 83121" already makes me think
there's something gone horribly wrong here. And, my guess is that it
more likely has to do something with hardware than the btrfs program code.

If there's one bit that flipped it might be possible to rescue a
filesystem manually, but these transid mismatches sound like the
filesystem is encountering whole blocks of data that should never been
there in the first place. A whole bunch of writes never ended up on
disk, while a disk controller assured they would etc.

The lack of response should probably not be interpreted as "not caring",
but more like "I really don't know" and just like not mailing a whole
list with a "me too!" post, people won't mail "I don't know, dude, let's
go bowling" too much. Or, it might be possible, but only realistically
done when travelling to you, getting to work with your computer and then
spending hours to find out what to do.

-- 
Hans van Kranenburg
