From: Andrew Guertin <andrew.guertin@uvm.edu>
Subject: Re: Applications using fsync cause hangs for several seconds every
 few minutes
Date: Sat, 20 Aug 2011 13:18:29 -0400
Message-ID: <4E4FEC65.2070903@uvm.edu>
References: <4E41A6A4.9070702@uvm.edu> <4E447E2E.2070502@uvm.edu> <1313678278-sup-1155@shiny>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1313678278-sup-1155@shiny>
List-ID: <linux-btrfs.vger.kernel.org>

On 08/18/2011 10:38 AM, Chris Mason wrote:
> Excerpts from Andrew Guertin's message of 2011-08-11 21:13:18 -0400:
>> On 08/09/2011 05:29 PM, Andrew Guertin wrote:
>>> I have not tried 3.1-rc1, but plan to soon.
>>
>> I've tested now, this does still occur in 3.1-rc1.
>
> Ok, I had high hopes that the btrfs changes in rc1 would fix this.
>
> Could you please try with the deadline elevator instead of the cfq
> default?

The deadline elevator does not fix it (tested with 3.1-rc2)

Sorry for taking a long time with this.

--Andrew
