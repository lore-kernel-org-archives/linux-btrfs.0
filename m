Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:43255 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab2IYABO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 24 Sep 2012 20:01:14 -0400
Received: by padhz1 with SMTP id hz1so1248166pad.19
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Sep 2012 17:01:14 -0700 (PDT)
Message-ID: <5060F43D.3000801@gmail.com>
Date: Tue, 25 Sep 2012 08:01:01 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org, trivial@kernel.org
Subject: Re: [PATCH 4/4] Btrfs: tivial cleanup: add space between = and the
 rest code
References: <505FADA5.3070500@gmail.com> <20120924131531.GE14582@twin.jikos.cz>
In-Reply-To: <20120924131531.GE14582@twin.jikos.cz>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2012年09月24日 21:15, David Sterba wrote:
> On Mon, Sep 24, 2012 at 08:47:33AM +0800, Wang Sheng-Hui wrote:
>> trivial code cleanup.
> 
>> -			ret =btrfs_drop_snapshot(root, NULL, 1, 0);
>> +			ret = btrfs_drop_snapshot(root, NULL, 1, 0);
> 
> Sorry but this is too trivial.
> 
> Unless it really bugs you when you're going through code, I don't think
> that cleanups at this level are necessary. Reading through commit
> history of some code via 'git blame' and seeing such cleanups is not
> welcome.
> 

Got it. Thanks,

> I have a patchet in testing that updates a few things around snapshot
> cleaning and this line will get fixed, so it'll not stay forever.
> 
> david

