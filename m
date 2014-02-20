Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:47594 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754596AbaBTQnu (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 20 Feb 2014 11:43:50 -0500
Message-ID: <530630C0.20208@redhat.com>
Date: Thu, 20 Feb 2014 10:43:44 -0600
From: Eric Sandeen <sandeen@redhat.com>
MIME-Version: 1.0
To: Wang Shilong <wangsl.fnst@cn.fujitsu.com>
CC: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 1/4] Btrfs-progs: new helper to parse string to u64
 for btrfs
References: <1392859852-15829-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1392859852-15829-2-git-send-email-wangsl.fnst@cn.fujitsu.com> <53055CEB.5000808@redhat.com> <53055DA5.6080604@cn.fujitsu.com>
In-Reply-To: <53055DA5.6080604@cn.fujitsu.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2/19/14, 7:43 PM, Wang Shilong wrote:
> On 02/20/2014 09:39 AM, Eric Sandeen wrote:
>> On 2/19/14, 7:30 PM, Wang Shilong wrote:

...

>>> +    /*
>>> +     * if we pass a negative number to strtoull,
>>> +     * it will return an unexpected number to us,
>>> +     * so let's do the check ourselves firstly.
>>> +     */
>>> +    if (str[0] == '-') {
>>> +        fprintf(stderr, "ERROR: %s may be negative value.\n", str);
>> well, it _is_ a negative value right?  (vs. "may be")
>>
>> So perhaps:
>>
>> fprintf(stderr, "ERROR: %s: negative value is invalid.\n", str);
> I use "may be" because the following case:
> 
> -123xxxx, -abcd..... something like these, these string are invalid,
> but they are not negative number...So i have not thought a better idea
> to tell user what is wrong with input.:-)

Ok; well, sorry for being nitpicky.  :)  But user error messages probably
should be very clear and unambiguous; we may as well do this right.

So what about this:

Do strtoull first, and *if* it passes numeric parsing, but str[0] == '-',
*then* say "ERROR: %s: negative value is invalid."

-Eric


