Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx4-phx2.redhat.com ([209.132.183.25]:44943 "EHLO
	mx4-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750991AbaHLAHS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 11 Aug 2014 20:07:18 -0400
Content-Type: text/plain;
	charset=us-ascii
Subject: Re: [PATCH 1/3] btrfs-progs: random fixes of btrfs-filesystem documentation
References: <53E888C3.70807@jp.fujitsu.com> <53E8F7F0.3060300@redhat.com> <53E95703.9050705@jp.fujitsu.com>
From: Eric Sandeen <esandeen@redhat.com>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
In-Reply-To: <53E95703.9050705@jp.fujitsu.com>
Message-Id: <6DC8BDFA-32FF-4EB4-87D4-AB09F7A5A9FE@redhat.com>
Date: Mon, 11 Aug 2014 20:07:15 -0400 (EDT)
Cc: Eric Sandeen <sandeen@redhat.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
MIME-Version: 1.0
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



> On Aug 11, 2014, at 4:51 PM, Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com> wrote:
> 
> Hi Eric,
> 
...
> 
> 
> OK, I'll fix my patch based on your comment.
> # Of course, I'll replace "(btrfs?)" with something proper words.

I assumed it only scans btrfs but didn't know for sure :)

> Can I add your "Signed-off-by" to my v2 patch?

Oh, sure, if you use my text, that makes sense.

thanks,
-Eric


>> 
>> (What seems to be missing, though, is why would the user ever choose to use '-d?')
> 
> I'm not sure. I guess, for example, in large systems, -d takes too
> many times for scanning all devices under /dev or something?
> 
> Thank you for your comments!
> 
> Satoru
> 
>> 
>> -Eric
> 
