Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:58176 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759661Ab3BZIy0 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 26 Feb 2013 03:54:26 -0500
Received: from m1.gw.fujitsu.co.jp (unknown [10.0.50.71])
	by fgwmail5.fujitsu.co.jp (Postfix) with ESMTP id A06943EE0BD
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 17:54:24 +0900 (JST)
Received: from smail (m1 [127.0.0.1])
	by outgoing.m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 8AF2B45DE59
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 17:54:24 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (s1.gw.fujitsu.co.jp [10.0.50.91])
	by m1.gw.fujitsu.co.jp (Postfix) with ESMTP id 72CFA45DE56
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 17:54:24 +0900 (JST)
Received: from s1.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 63CDF1DB804E
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 17:54:24 +0900 (JST)
Received: from m1001.s.css.fujitsu.com (m1001.s.css.fujitsu.com [10.240.81.139])
	by s1.gw.fujitsu.co.jp (Postfix) with ESMTP id 196F11DB804C
	for <linux-btrfs@vger.kernel.org>; Tue, 26 Feb 2013 17:54:24 +0900 (JST)
Message-ID: <512C781D.1090309@jp.fujitsu.com>
Date: Tue, 26 Feb 2013 17:53:49 +0900
From: Tsutomu Itoh <t-itoh@jp.fujitsu.com>
MIME-Version: 1.0
To: Dave Chinner <david@fromorbit.com>
CC: Eric Sandeen <sandeen@redhat.com>, chris.mason@fusionio.com,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        Stefan Behrens <sbehrens@giantdisaster.de>,
        David Sterba <dsterba@suse.cz>
Subject: Re: [PATCH, RFC] btrfs-progs: require mkfs -f force option to overwrite
 filesystem or partition table
References: <511D2D2B.8040804@redhat.com> <5124EDAB.5020003@giantdisaster.de> <512BF648.1090602@jp.fujitsu.com> <512BFCD1.3030709@redhat.com> <512C3230.8020305@jp.fujitsu.com> <512C34CC.3070904@redhat.com> <512C3927.2080708@jp.fujitsu.com> <20130226070525.GP5551@dastard>
In-Reply-To: <20130226070525.GP5551@dastard>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2013/02/26 16:05, Dave Chinner wrote:
> On Tue, Feb 26, 2013 at 01:25:11PM +0900, Tsutomu Itoh wrote:
>> On 2013/02/26 13:06, Eric Sandeen wrote:
>>> On 2/25/13 9:55 PM, Tsutomu Itoh wrote:
>>>> EXPERIMENTAL... It's certainly so.
>>>> However, I think that we should not add the option that it troubles
>>>> a lot of people.
>>>
>>> Well, I sent it as an RFC.  Chris merged it; I'll defer to his judgement.
>>
>> Agreed. So, I sent revert request to Chris :)
>
> Where? I want to NACK the revert - this is not a matter to joke
> about.

I apologize for my childish expression.
I'll also defer to Chris's judgement.

Thanks,
Tsutomu

>
> You're all smart enough to know how to use shell aliases and script
> variables, so this "need to type -f all the time" argument holds
> absolutely no weight at all. Further, most of the time you're
> working on systems that donMy childish expression is mistaken. 't hold any data you care about and so
> the consequences of a mistake are very minor.
>
> However, users often make mistakes and we have to take that into
> account when deciding on the default behaviour of our tools.
> Tools that destroy data *must* err on the side of conservative
> default behaviour simply because of the fact that destroying the
> wrong data can have catastrophic consequences. It's not your data
> that is being destroyed, but it is data that you have a
> *responsibility to safeguard* as a filesystem developer.
>
> Think about it this way: how happy would an important customer be if
> they decided that *you* were directly responsible for a major data
> loss incident because they found it would have been prevented by the
> "-f" patch? I don't think that the explanation of "it was
> inconvenient to me" would be an acceptable answer.....
>
> Cheers,
>
> Dave.
>


