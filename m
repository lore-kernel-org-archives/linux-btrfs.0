Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail02.iobjects.de ([188.40.134.68]:55183 "EHLO
	mail02.iobjects.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752071AbcDHNKj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Fri, 8 Apr 2016 09:10:39 -0400
Subject: Re: WARN_ON in record_root_in_trans() when deleting freshly renamed
 subvolume
To: Filipe David Manana <fdmanana@gmail.com>
References: <57068E64.7000408@googlemail.com>
 <CAL3q7H6U8hDK7+BOqP-u3ogrJaKxED3U839kmT_PU6kbq9U1AA@mail.gmail.com>
 <57079B4D.8080304@googlemail.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>, Mark Fasheh <mfasheh@suse.de>,
        Qu Wenruo <quwenruo@cn.fujitsu.com>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?=
	<holger.hoffstaette@googlemail.com>
Message-ID: <5707ADCB.9090207@googlemail.com>
Date: Fri, 8 Apr 2016 15:10:35 +0200
MIME-Version: 1.0
In-Reply-To: <57079B4D.8080304@googlemail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[cc: Mark and Qu]

On 04/08/16 13:51, Holger Hoffstätte wrote:
> On 04/08/16 13:14, Filipe Manana wrote:
>> Using Chris' for-linus-4.6 branch, which is 4.5-rc6 + all 4.6 btrfs
>> patches, it didn't reproduce here:
> 
> Great, that's good to know (sort of :). Thanks also to Liu Bo.
> 
>> Are you sure that you are not using some patches not in 4.6?

We have a bingo!

Reverting "qgroup: Fix qgroup accounting when creating snapshot"
from last Wednesday immediately fixes the problem.

Was quite easy to find - the triggered WARN_ON was the second one that
complained about a mismatch between roots. The only patch that even
remotely did something in that area was said qgroup fix.

Looks like something is missing there. Suggestions welcome. :)

Holger

