Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:40051 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205AbcCBJJY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Wed, 2 Mar 2016 04:09:24 -0500
Subject: Re: [RFC] Experimental btrfs encryption
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
References: <1456848492-4814-1-git-send-email-anand.jain@oracle.com>
 <56D63CB1.5070202@cn.fujitsu.com>
Cc: clm@fb.com, dsterba@suse.cz
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <56D6ADB6.7020701@oracle.com>
Date: Wed, 2 Mar 2016 17:09:10 +0800
MIME-Version: 1.0
In-Reply-To: <56D63CB1.5070202@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

> Not only move, but also reflink/inband dedup.

  oh yes thanks. I shall add those.

> Yes, but in fact, you can use another method, just like in-band de-dup,
> by adding new hook into async_cow_start() and async_cow_end(), allowing
> compression and encryption can be done at the same time.
> (We are already testing the patch to allow dedup to cooperate with
> compression)
>
> So no need to find a encryption with can compress.
> (Never mix 2 different work together)

  I am not too sure about this. But logically if one encoding engine
  can do both that seems to be better than using two separate encoding
  engines.

> And maybe I just missed something, but the filename seems not touched,
> meaning it will leak a lot of information.
> Just like default eCryptfs behavior.
 >
> I understand that's an easy design and it's not a high priority thing,
> but I hope we can encrypt the subvolume tree blocks too, if using
> per-subvolume policy.
> To provide a feature near block-level encryption.

  No you didn't miss about filename, its not there yet. Will add more
  depth, as I obtain feedback/confirmed on the approach concerns if any.

Thanks, Anand
