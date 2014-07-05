Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from 206-248-167-68.dsl.teksavvy.com ([206.248.167.68]:56180 "EHLO
	mail.isoar.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751241AbaGEPRa (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 5 Jul 2014 11:17:30 -0400
Received: from [172.16.0.130]
	by mail.isoar.ca with esmtpsa (TLSv1:DHE-RSA-AES128-SHA:128)
	(Exim 4.80.1 #2)
	id 1X3RiS-0004ov-LA
	for linux-btrfs@vger.kernel.org; Sat, 05 Jul 2014 11:17:28 -0400
Message-ID: <53B816FB.7080909@isoar.ca>
Date: Sat, 05 Jul 2014 11:17:15 -0400
From: "Andrew E. Mileski" <andrewm@isoar.ca>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: Is btrfs related to OOM death problems on my 8GB server with
 both 3.15.1 and 3.14?
References: <20140704011938.GO11539@merlins.org> <53B801DD.5040704@isoar.ca> <20140705144318.GT26932@merlins.org>
In-Reply-To: <20140705144318.GT26932@merlins.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-07-05 10:43 AM, Marc MERLIN wrote:
> On Sat, Jul 05, 2014 at 09:47:09AM -0400, Andrew E. Mileski wrote:
>> On 2014-07-03 9:19 PM, Marc MERLIN wrote:
>>> I upgraded my server from 3.14 to 3.15.1 last week, and since then it's been
>>> running out of memory and deadlocking (panic= doesn't even work).
>>> I downgraded back to 3.14, but I already had the problem once since then.
>>
>> I didn't see any mention of the btrfs utility version in this thread
>> (I may be blind though).
>>
>> My server was suffering from frequent panics upon scrub / defrag /
>> balance, until I updated the btrfs utility.  That resolved all my
>> issues.
>
> Really? The userland tool should only send ioctls to the kernel, I
> really can't see how it would cause the kernel code to panic or not.
>
> gargamel:~# btrfs --version
> Btrfs v3.14.1
> which is the latest in debian unstable.

It reached the point that I got so frustrated that I built the
utilities from git, as an up-to-date package wasn't available at the
time.  I'm currently using v3.14.2 but v3.14.1 was the version that
resolved my server's panics.

I've not looked into the code very deeply yet, so I can't theorize on
why it resolved my server's panics.  I can only state with complete
certainty that it did.  I too was somewhat surprised.

However, it seems we've probably now ruled it out in your case.

~~
Andrew E. Mileski
