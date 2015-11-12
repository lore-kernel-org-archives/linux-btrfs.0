Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:44575
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbbKLNR5 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 12 Nov 2015 08:17:57 -0500
Subject: Re: Regression in btrfs: properly set the termination value of
 ctx->pos in readdir
To: dsterba@suse.cz, Stefan Priebe - Profihost AG <s.priebe@profihost.ag>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
References: <56432D2A.5040506@profihost.ag>
 <CAHji153qQPDyO+Ajv3O+FE991DjPG3y1t35091s8t9S4+w5k3g@mail.gmail.com>
 <20151112103523.GI6445@twin.jikos.cz> <20151112130901.GJ6445@suse.cz>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <56449183.6010003@googlemail.com>
Date: Thu, 12 Nov 2015 14:17:55 +0100
MIME-Version: 1.0
In-Reply-To: <20151112130901.GJ6445@suse.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 11/12/15 14:09, David Sterba wrote:
> On Thu, Nov 12, 2015 at 11:35:23AM +0100, David Sterba wrote:
>> On Wed, Nov 11, 2015 at 01:22:19PM +0100, Holger Hoffstätte wrote:
>>>> the patch btrfs: properly set the termination value of ctx->pos in
>>>> readdir introduces a regression to me.
>>>>
>>>> A lot of stuff runs in "endless" or long running loops.
>>>
>>> Just tested this and can confirm something is off.
>>> In a directory with several files, create a new directory and move all
>>> files into the new subdir.
>>>
>>> An immediately following ls will hang. The problem goes away after a
>>> manual sync.
>>
>> I can reproduce the hang, thanks.
> 
> The hang was triggered by use of trace_printk and I'm seeing several
> strange bugs caused by added debugging, so I can't say I can reproduce
> it yet.

Be that as it may, the procedure I described above immediately started to
work again when I backed out this patch. I also didn't noctice anything
wrong before Stefan's email, so it's apparently not easy to hit.

-h

