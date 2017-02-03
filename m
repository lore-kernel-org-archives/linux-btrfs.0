Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp2.provo.novell.com ([137.65.250.81]:57718 "EHLO
        smtp2.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753017AbdBCX0D (ORCPT
        <rfc822;groupwise-linux-btrfs@vger.kernel.org:0:0>);
        Fri, 3 Feb 2017 18:26:03 -0500
Subject: Re: Very slow balance / btrfs-transaction
To: jb@capsec.org, linux-btrfs@vger.kernel.org
References: <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
From: Goldwyn Rodrigues <rgoldwyn@suse.com>
Message-ID: <507c32d4-929c-b691-6196-103c8cb9addb@suse.com>
Date: Fri, 3 Feb 2017 17:25:58 -0600
MIME-Version: 1.0
In-Reply-To: <80d3e5ce55ddc7e454cce96e67e2ea64@88cbed2449cf>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/03/2017 04:13 PM, jb@capsec.org wrote:
> Hi, 
> 
> 
> I'm currently running a balance (without any filters) on a 4 drives raid1 filesystem. The array contains 3 3TB drives and one 6TB drive; I'm running the rebalance because the 6TB drive recently replaced a 2TB drive. 
> 
> 
> I know that balance is not supposed to be a fast operation, but this one is now running for ~6 days and it managed to balance ~18% (754 out of about 4250 chunks balanced (755 considered),  82% left) -- so I expect it to take another ~4 weeks. 
> 
> That seems excessively slow for ~8TiB of data.
> 
> 
> Is this expected behavior? In case it's not: Is there anything I can do to help debug it?

Do you have quotas enabled?

-- 
Goldwyn
