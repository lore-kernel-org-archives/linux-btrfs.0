Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:65297 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753280AbaDXMda (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 24 Apr 2014 08:33:30 -0400
Message-ID: <535904BB.1090307@fb.com>
Date: Thu, 24 Apr 2014 08:34:03 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Marc MERLIN <marc@merlins.org>,
        =?UTF-8?B?0J/Qu9Cw0LzQtdC9INCf0LXRgtGA?= =?UTF-8?B?0L7Qsg==?=
	<plamen@petrovi.no-ip.info>
CC: <linux-btrfs@vger.kernel.org>
Subject: Re: Can anyone boot a system using btrfs root with linux 3.14 or
 newer?
References: <000001cf5f19$ac92b2b0$05b81810$@petrovi.no-ip.info> <20140423185413.GF26949@merlins.org> <001401cf5f27$17cae590$4760b0b0$@petrovi.no-ip.info> <20140423191546.GG26949@merlins.org> <002401cf5f2b$7f8d41b0$7ea7c510$@petrovi.no-ip.info> <20140423205819.GH26949@merlins.org>
In-Reply-To: <20140423205819.GH26949@merlins.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/23/2014 04:58 PM, Marc MERLIN wrote:
> On Wed, Apr 23, 2014 at 10:37:44PM +0300, Пламен Петров wrote:
>>> So now, we're kind of guessing. To save us all time, could you capture a serial
>>> console boot from the running 3.13 and then the failing 3.14.
>>
>> Well, for the details - see for example here:
>> https://bugzilla.kernel.org/attachment.cgi?id=133111
>> how does a 3.14.1 built the way described earlier fails.
>
> Thanks, that helps.
> Except, now I'm perplexed.
>
> It indeed shows btrfs loaded and your block device being detected.
> However it does not show a btrfs mount error.

The mount error is popping up after the printk about not being able to 
find root.  Add rootwait to the command line.

-chris
