Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from static.68.134.40.188.clients.your-server.de ([188.40.134.68]:54421
	"EHLO mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540AbbIOTjd (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 15 Sep 2015 15:39:33 -0400
Subject: Re: [PATCH V2] Btrfs: keep dropped roots in cache until transaction
 commit
To: Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org
References: <1442326024-2536-1-git-send-email-jbacik@fb.com>
 <55F83E34.3090900@googlemail.com> <55F86CB1.5020503@googlemail.com>
 <55F86E63.8050300@fb.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <55F873F3.5040707@googlemail.com>
Date: Tue, 15 Sep 2015 21:39:31 +0200
MIME-Version: 1.0
In-Reply-To: <55F86E63.8050300@fb.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/15/15 21:15, Josef Bacik wrote:
> On 09/15/2015 03:08 PM, Holger Hoffstätte wrote:
>> On 09/15/15 17:50, Holger Hoffstätte wrote:
>>> This V2 does indeed seem to fix the issues I reported with snapshot
>>> deletion & concurrent sync. I've now created/filled/deleted countless
>>> snapshots while issuing sync(s) in parallel, and the problem that I
>>> saw fairly frequently with V1 no longer seems to occur here.
>>
>> Well..I may have spoken too soon:
> 
> Huh this doesn't seem related to my stuff. Can I have your script you
> are running to reproduce this? Thanks,

This was manual - deleted two large files, deleted two snapshots (one
from the modified subvolume and one sibling), let it sit in the background
while doing something else for a few seconds and found the messages.
Don't know how to reproduce this as it didn't show up previously.

-h

