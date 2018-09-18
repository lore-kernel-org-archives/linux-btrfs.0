Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-eopbgr00075.outbound.protection.outlook.com ([40.107.0.75]:52304
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729782AbeISAHq (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 18 Sep 2018 20:07:46 -0400
Subject: Re: Move data and mount point to subvolume
To: Marc Joliet <marcec@gmx.de>, linux-btrfs@vger.kernel.org
References: <20180916111445.lqwjqvq4aeiwglmm@campbell-lange.net>
 <b6d821fb-334f-8145-27e3-28a8cfa99940@mendix.com>
 <7fade1e9-7eb2-d416-6a3d-452cbca3bbe5@mendix.com>
 <2062209.NsJ275U7B3@thetick>
From: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Message-ID: <d12b86dd-3307-3b79-a02c-93c914959d71@mendix.com>
Date: Tue, 18 Sep 2018 20:33:45 +0200
MIME-Version: 1.0
In-Reply-To: <2062209.NsJ275U7B3@thetick>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 09/18/2018 08:10 PM, Marc Joliet wrote:
> Am Sonntag, 16. September 2018, 14:50:04 CEST schrieb Hans van Kranenburg:
>> The last example, where you make a subvolume and move everything into
>> it, will not do what you want. Since a subvolume is a separate new
>> directoty/file hierarchy, mv will turn into a cp and rm operation
>> (without warning you) probably destroying information about data shared
>> between files.
> 
> I thought that wasn't true anymore.  The NEWS file to coreutils contains this 
> (for version 8.24):
> 
>   mv will try a reflink before falling back to a standard copy, which is
>   more efficient when moving files across BTRFS subvolume boundaries.

I was wrong when saying that mv will copy/rm between subvolumes indeed,
because you can reflink files between subvolumes, as long as they're
under the same mount point. (You still can NOT between mount points
iirc, even when they are mounts from the same btrfs.)

But still, mv silently does one or the other, which is also confusing,
because if it starts copying/removing things while that was not your
intention, at first you're like "hm, takes longer than I tought" and
then "oh wait, noooo", and then it's too late already.

-- 
Hans van Kranenburg
