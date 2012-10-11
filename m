Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail.profihost.ag ([85.158.179.208]:56333 "EHLO
	mail.profihost.ag" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756148Ab2JKS4T (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 11 Oct 2012 14:56:19 -0400
Message-ID: <50771654.5020206@profihost.ag>
Date: Thu, 11 Oct 2012 20:56:20 +0200
From: Stefan Priebe <s.priebe@profihost.ag>
MIME-Version: 1.0
To: Josef Bacik <jbacik@fusionio.com>
CC: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: use_block_rsv problems with 3.6.1
References: <50771184.2060807@profihost.ag> <20121011185154.GA5755@localhost.localdomain>
In-Reply-To: <20121011185154.GA5755@localhost.localdomain>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Am 11.10.2012 20:51, schrieb Josef Bacik:
> On Thu, Oct 11, 2012 at 12:35:48PM -0600, Stefan Priebe wrote:
>> Hello,
>>
>> on i've seen the following backtrace a lot on 3.6.1:
>> [ 2231.644332] use_block_rsv: 1451 callbacks suppressed
>> [ 2231.645249] btrfs: block rsv returned -28
>
> Yeah this is the last deep dark corner of ENOSPC, we don't quite hold enough
> reserved to handle deleting lots of csums.  Technically this is supposed to be
> taken care of by ye olde global block rsv, but in some cases it's not enough.
> On the bright side if you are just seeing the warnings then we're able to find
> space somewhere and you are a-ok, but it is kind of annoying.  Once I finish my
> fsync stuff I'll go back to this problem and try and figure out a real solution.
> Thanks,

Pretty strange. As this is a freshly created btrfs - added 3 files and i 
was just:
- creating a read only snapshot
- cat file1 >file4
- creating a read only snapshot
- cat file2 >file5
- creating a read only snapshot
- cat file3 >file6
- creating a read only snapshot

nothing else.

Stefan
