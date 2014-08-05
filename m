Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.virtall.com ([178.63.195.102]:42051 "EHLO mail.virtall.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753939AbaHEXj0 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 5 Aug 2014 19:39:26 -0400
To: "G. Richard Bellamy" <rbellamy@pteradigm.com>
Subject: Re: btrfs and iostat - how do I measure the live performance of my  btrsf =?UTF-8?Q?filesystems=3F?=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 06 Aug 2014 01:39:22 +0200
From: Tomasz Chmielewski <mangoo@wpkg.org>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
In-Reply-To: <CADw2B2MgvUt_bL11ZOAZjyk+R2pmM5JbLVjmgqoXBHSTEypMqw@mail.gmail.com>
References: <e464a0229fbd354aea0d15d8342330b1@admin.virtall.com>
 <CADw2B2MgvUt_bL11ZOAZjyk+R2pmM5JbLVjmgqoXBHSTEypMqw@mail.gmail.com>
Message-ID: <40ee87d5d8b24230774bf28018ceb289@admin.virtall.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2014-08-06 00:06, G. Richard Bellamy wrote:
> On Tue, Aug 5, 2014 at 7:14 AM, Tomasz Chmielewski <mangoo@wpkg.org> 
> wrote:
>> Simple iostat won't give you meaningful live performance stats.
>> 
>> You can combine it i.e. like below:
>> 
>> iostat -x 1
>> iostat -mx 1
>> iostat -m 1
> 
> Thanks for the pointer about viewing the extended stats, and showing
> them in MB rather than kB.
> 
> Maybe I'm missing something here. I'm failing to see how adding those
> additional stats helps me get meaningful throughput information for a
> multi-device btrfs volume.

Well you won't see an aggregate, but you will see individual device 
statistics with "1" at the end of iostat arguments (meaning, dump the 
stats every second).


-- 
Tomasz Chmielewski
http://www.sslrack.com

