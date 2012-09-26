Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38221 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751359Ab2IZC62 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Sep 2012 22:58:28 -0400
MIME-Version: 1.0
In-Reply-To: <5061E676.8080203@libero.it>
References: <1348538536-29838-1-git-send-email-zwu.kernel@gmail.com>
	<1348538536-29838-3-git-send-email-zwu.kernel@gmail.com>
	<20120925101429.GR14582@twin.jikos.cz>
	<5061E676.8080203@libero.it>
Date: Wed, 26 Sep 2012 10:58:26 +0800
Message-ID: <CAEH94LirayD_NB2KW5q5KSZ3nVTJLYpi23D_ioGwcKmn0WyDVw@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] btrfs-progs: Fix up memory leakage
From: Zhi Yong Wu <zwu.kernel@gmail.com>
To: kreijack@inwind.it
Cc: linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        jbacik@fusionio.com, dave@jikos.cz, linuxram@linux.vnet.ibm.com,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Sep 26, 2012 at 1:14 AM, Goffredo Baroncelli <kreijack@libero.it> wrote:
> On 09/25/2012 12:14 PM, David Sterba wrote:
>>
>> On Tue, Sep 25, 2012 at 10:02:16AM +0800, zwu.kernel@gmail.com wrote:
>>>
>>> From: Zhi Yong Wu<wuzhy@linux.vnet.ibm.com>
>>>
>>>    Some code pathes forget to free memory on exit.
>>
>>
>> Same as with the fd's, kernel will free all memory for us at exit().
>
>
> I strongly disagree with this approach. The callee often don't know what
> happen after and before the call. The same is true for the programmer,
> because the code is quite often updated by several people. A clean exit() is
> the right thing to do as general rule. I don't see any valid reason (in the
> btrfs context) to do otherwise.
>
> Relying on the exit() for a proper clean-up increase the likelihood of bug
> when the code evolves (see my patch   [RESPOST][BTRFS-PROGS][PATCH]
> btrfs_read_dev_super(): uninitialized variable for an example of what means
> an incorrect deallocation of resource).
>
>
>> If there's lots of memory allocated, it may be even faster to leave the
>> unallocation process to kernel as it will do it in one go, while the
>> application would unnecessarily free it chunk by chunk.
>
>
> May be I am wrong, but I don't think that the increase of speed of the btrfs
> "command" is even measurable relying on exit instead of free()-ing each
> chunk of memory one at time.... The same should be true for the
> open()/close()

I fully agree with you. In one same function, i find that some code
path free system sources,
while other code path doesn't. This is one nice way.

>
> My 2¢
>
> BR
> G.Baroncelli
>
>>
>> david
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
>>
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> .
>>
>



-- 
Regards,

Zhi Yong Wu
