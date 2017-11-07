Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48322 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933304AbdKGUm2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 7 Nov 2017 15:42:28 -0500
Subject: Re: [PATCH] btrfs: Reduce scope of delayed_rsv->lock in
 may_commit_trans
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org, josef@toxicpanda.com
References: <1510046574-15541-1-git-send-email-nborisov@suse.com>
 <20171107201804.GD27557@twin.jikos.cz>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <c38c64d8-4b6b-4bd1-52a5-df9ee7b7cdd6@suse.com>
Date: Tue, 7 Nov 2017 22:42:26 +0200
MIME-Version: 1.0
In-Reply-To: <20171107201804.GD27557@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On  7.11.2017 22:18, David Sterba wrote:
> On Tue, Nov 07, 2017 at 11:22:54AM +0200, Nikolay Borisov wrote:
>> After commit ('btrfs: change how we decide to commit transactions during
> 
> 996478ca9c460886ac1

That commit is still not pulled by linus so is this id stable?
> 
>> flushing') there is no need to hold the delayed_rsv during the
>> percpu_counter_compare call since we get the byte's snapshot earlier. So hold
>> the lock only while reading delayed_rsv
>>
>> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> 
> Reviewed-by: David Sterba <dsterba@suse.com>
> 
