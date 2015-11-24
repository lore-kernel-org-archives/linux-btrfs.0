Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753419AbbKXROh (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 24 Nov 2015 12:14:37 -0500
Subject: Re: shall distros run btrfsck on boot?
To: Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1448337754.14125.33.camel@scientia.net>
 <pan$32768$921cbe34$6a22269c$2c7db710@cox.net>
 <1448340211.14125.44.camel@scientia.net>
 <pan$c9010$71046470$f37154a0$cd8b55eb@cox.net>
 <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net>
From: Eric Sandeen <sandeen@redhat.com>
Message-ID: <56549AFB.3040904@redhat.com>
Date: Tue, 24 Nov 2015 11:14:35 -0600
MIME-Version: 1.0
In-Reply-To: <pan$d4967$d0c5632e$fa0a61b0$e3c076ef@cox.net>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/24/15 12:56 AM, Duncan wrote:
> Duncan posted on Tue, 24 Nov 2015 06:46:18 +0000 as excerpted:
> 
>> That wouldn't be entirely uncommon, because as Eric mentions, btrfs
>> check is intended to be thorough, where the kernel mount-time check is
>> intended to be fast.
>>
>> But of course, as Eric also mentions, that's yet another reason you
>> don't want btrfs check running at boot... it's *SSLLLOOWWWWW*, because
>> it's being thorough.
> 
> Oops!  Mis-attribution.  Qu not Eric.
> 
> (I had read both replies in my email but only saw Eric's on the list, 
> which I read in my news client via gmane's list2news service, when I 
> composed the above.  So I presumed the points I remembered being made 
> were from Eric's post, when it was Qu's.) 

Yeah, I don't think that being thorough requires being slow.  ;)

In a nutshell, though, I think a filesystem repair should be an admin-initiated
action, not something that surprises you on a boot, at least for a journaling
filesystem which is designed to maintain its integrity even in the face of
a power loss or crash.

-Eric

