Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ig0-f169.google.com ([209.85.213.169]:34344 "EHLO
	mail-ig0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbbLPM65 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Dec 2015 07:58:57 -0500
Received: by mail-ig0-f169.google.com with SMTP id sf7so20875096igc.1
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Dec 2015 04:58:57 -0800 (PST)
Subject: Re: [PATCH v3] btrfs: Introduce new mount option to disable tree log
 replay
To: Christoph Anton Mitterer <calestyo@scientia.net>,
        Duncan <1i5t5.duncan@cox.net>, linux-btrfs@vger.kernel.org
References: <1449714846-18174-1-git-send-email-quwenruo@cn.fujitsu.com>
 <20151214173200.GO4227@twin.jikos.cz> <5670C017.5010104@cn.fujitsu.com>
 <pan$ecec5$9f9ca76c$f1c4eebd$1e31c111@cox.net> <56715518.8080808@gmail.com>
 <1450269296.6259.27.camel@scientia.net>
From: "Austin S. Hemmelgarn" <ahferroin7@gmail.com>
Message-ID: <56715FBF.9090808@gmail.com>
Date: Wed, 16 Dec 2015 07:57:35 -0500
MIME-Version: 1.0
In-Reply-To: <1450269296.6259.27.camel@scientia.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-12-16 07:34, Christoph Anton Mitterer wrote:
> On Wed, 2015-12-16 at 07:12 -0500, Austin S. Hemmelgarn wrote:
>> I kind of agree with Christoph here.  I don't think that noload
>> should
>> be the what we actually use, although I do think having it as an
>> alias
>> for whatever name we end up using would be a good thing.
> No, because people would start using it, getting used to it, and in 4
> years we could never change it again,... which may be necessary...
>
No, because we should ease the transition from other filesystems to the 
greatest extent reasonably possible.  It should be clearly documented as 
an alias for compatibility with ext{3,4}, and that it might go away in 
the future.

