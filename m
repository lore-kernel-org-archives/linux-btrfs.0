Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:27152 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750919AbaG3XSP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 30 Jul 2014 19:18:15 -0400
From: Josef Bacik <jbacik@fb.com>
To: Nick Krause <xerofoify@gmail.com>
CC: Zach Brown <zab@zabbo.net>, Chris Mason <clm@fb.com>,
        "linux-btrfs@vger.kernel.org SYSTEM list:BTRFS FILE"
	<linux-btrfs@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Remove certain calls for releasing page cache
Date: Wed, 30 Jul 2014 23:18:10 +0000
Message-ID: <se1kwwn8cwmosqn1karyfwfv.1406762043976@email.android.com>
References: <1406752954-26158-1-git-send-email-xerofoify@gmail.com>
	<53D959D0.1020303@fb.com>
	<20140730205148.GA25256@lenny.home.zabbo.net>,<CAPDOMVhWmOYNG=WTwXL5V9-t_rAj-eDPB3WQf7Qj4yjcw7v=0Q@mail.gmail.com>
In-Reply-To: <CAPDOMVhWmOYNG=WTwXL5V9-t_rAj-eDPB3WQf7Qj4yjcw7v=0Q@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

So I'm going to list all the things that are wrong with this in the off chance that you will actually improve and then go back to ignoring your emails.

1) You test your patches before you send them.  Xfstests is how you test.

2) You seem to think page_cache_release releases the page cache.  It doesn't, it releases a ref on the page, we take a ref while we are doing IO and then drop it when we are done.  It is not evicted from cache until the VM decides to do it at some point in the future, so all your patch does is make us leak page cache.

3) You don't free the compressed pages.  This leaks memory.  These pages are only used for writing out, there is absolutely no reason to keep them around after the IO is complete, we have the actual page with the real data still in cache.

4) You also made it so we don't free the the struct we use to track the compressed IO, which is just as useless as the compressed pages now, causing another memory leak.

Had you tested this patch it would have killed the box pretty quickly and you would have known all of this.  But you didn't, and wasted a lot of much smarter peoples time.  This is not OK, this gets you ignored.  Do not do it again.  Thanks,

Josef

Nick Krause <xerofoify@gmail.com> wrote:


On Wed, Jul 30, 2014 at 4:51 PM, Zach Brown <zab@zabbo.net> wrote:
> On Wed, Jul 30, 2014 at 04:47:12PM -0400, Josef Bacik wrote:
>> On 07/30/2014 04:42 PM, Nicholas Krause wrote:
>> >This patch removes the lines for releasing the page cache in certain
>> >files as this may aid in perfomance with writes in the compression
>> >rountines of btrfs. Please note that this patch has not been tested
>> >on my own hardware due to no compression based btrfs volumes of my
>> >own.
>> >
>>
>> https://urldefense.proofpoint.com/v1/url?u=http://37.media.tumblr.com/tumblr_m44v95k9Y11qjhgo6o1_250.gif&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=epKcfiwbd4AA3VbfORegZjsqgl8dEZjg%2B3XKikkWVBM%3D%0A&s=5dd9a127c17ca09d584d86694d71f37cd336eab3f17658f8c0dccbfe2a53e2d8
>
> https://urldefense.proofpoint.com/v1/url?u=https://www.youtube.com/watch?v%3DjVfkYZmXHAg&k=ZVNjlDMF0FElm4dQtryO4A%3D%3D%0A&r=cKCbChRKsMpTX8ybrSkonQ%3D%3D%0A&m=epKcfiwbd4AA3VbfORegZjsqgl8dEZjg%2B3XKikkWVBM%3D%0A&s=5402110ffa4beccf257af0fc266e8cab20264119fe9bdb2e4734c8ba3e49a211
>
> - z


Zach,
Is there a reason for freeing the page cache as I seem to be missing why?
Regards Nick
