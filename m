Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from capsec.org ([46.4.123.73]:37712 "EHLO mail.capsec.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753300AbdBDBrT (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 3 Feb 2017 20:47:19 -0500
Mime-Version: 1.0
Date: Sat, 04 Feb 2017 01:47:46 +0000
Content-Type: text/plain; charset="utf-8"
Message-ID: <f9e2b226440e4f6e17e61ce86eecc7eb@88cbed2449cf>
From: "Jorg Bornschein" <jb@capsec.org>
Subject: Re: Very slow balance / btrfs-transaction
To: "Goldwyn Rodrigues" <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
In-Reply-To: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
References: <fce777cb-027f-532b-76ab-24a1e5c2cf7c@suse.de>
 <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
 <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
 <8999d95dac21ea8e2908c5012e50c59b@88cbed2449cf>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

February 4, 2017 1:07 AM, "Goldwyn Rodrigues" <rgoldwyn@suse.de> wrote:

> On 02/03/2017 06:30 PM, Jorg Bornschein wrote:
> 
>> February 3, 2017 11:26 PM, "Goldwyn Rodrigues" <rgoldwyn@suse.com> wrote:
>> 
>> Hi,
>> 
>> I'm currently running a balance (without any filters) on a 4 drives raid1 filesystem. The array
>> contains 3 3TB drives and one 6TB drive; I'm running the rebalance because the 6TB drive recently
>> replaced a 2TB drive.
>> 
>> I know that balance is not supposed to be a fast operation, but this one is now running for ~6 days
>> and it managed to balance ~18% (754 out of about 4250 chunks balanced (755 considered), 82% left)
>> -- so I expect it to take another ~4 weeks.
>> 
>> That seems excessively slow for ~8TiB of data.
>> 
>> Is this expected behavior? In case it's not: Is there anything I can do to help debug it?
>>> Do you have quotas enabled?
>> 
>> I might have activated it when playing with "snapper" -- I remember using some quota command
>> without knowing what it does.
>> 
>> How can I check its active? Shall I just disable it wit "btrfs quota disable"?
> 
> To check your quota limits:
> # btrfs qgroup show <mountpoint>
> 
> To disable
> # btrfs quota disable <mountpoint>
> 
> Yes, please check if disabling quotas makes a difference in execution
> time of btrfs balance.


Quata support was indeed active -- and it warned me that the qroup data was inconsistent. 

Disabling quotas had an immediate impact on balance throughput -- it's *much* faster now! 
>From a quick glance at iostat I would guess it's at least a factor 100 faster.


Should quota support generally be disabled during balances? Or did I somehow push my fs into a weired state where it triggered a slow-path?



Thanks!   
   
   j
