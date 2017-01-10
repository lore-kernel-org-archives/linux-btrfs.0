Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53901 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935492AbdAJQFB (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 10 Jan 2017 11:05:01 -0500
Subject: Re: [RFC] Converging userspace and kernel code
To: Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        Jeff Mahoney <jeffm@suse.com>, David Sterba <dsterba@suse.com>
References: <512c15bf-3c4b-3b88-1106-a7d43386400f@suse.de>
 <1b68f099-53e8-1bc8-5ffc-2dd0b21a32ae@oracle.com>
 <09ea1fbd-74a1-d9f5-ba86-bc7c9118d49f@suse.de>
 <d0a11a09-322d-89bc-1a15-598f6a14e6be@oracle.com>
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Message-ID: <d0c2e05d-0b7a-a782-80b8-e1776e7b6fdb@suse.de>
Date: Tue, 10 Jan 2017 10:04:56 -0600
MIME-Version: 1.0
In-Reply-To: <d0a11a09-322d-89bc-1a15-598f6a14e6be@oracle.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 01/10/2017 09:20 AM, Anand Jain wrote:
> 
> 
> On 01/10/17 20:14, Goldwyn Rodrigues wrote:
>>
>>
>> On 01/09/2017 09:28 PM, Anand Jain wrote:
>>>
>>> Goldwyn,
>>>
>>>  Could you add a list what functionality in btrfs-progs will
>>>  be using the 'core'. ?
>>
>>
>> There are too many to list. It would contain the algorithmic functions
>> of btrfs which would be able to interact with both kernel and
>> btrfs-progs.
> 
>  I am getting confused. How about a few from the btrfs-progs ?
> 
> 

Functions such as open_ctree(), or the set/get functions. The idea is to
keep the codebase of this core component the same in btrfs-progs and kernel.

As an example, see how XFS have done using libxfs. Something around the
same lines.

-- 
Goldwyn
