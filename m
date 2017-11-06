Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.17.12]:57049 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752261AbdKFPIX (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 6 Nov 2017 10:08:23 -0500
Subject: Re: [PATCH] btrfs/volumes: Improve unlocking of a mutex in
 __btrfs_balance()
To: linux-btrfs@vger.kernel.org, David Sterba <dsterba@suse.com>
References: <d7bcebed-b68f-6137-24df-9332ef1de802@users.sourceforge.net>
 <20171106142450.GF28789@twin.jikos.cz>
Cc: dsterba@suse.cz, Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-fsdevel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
From: SF Markus Elfring <elfring@users.sourceforge.net>
Message-ID: <26ba6f26-7132-282b-7b90-3b691a704e4c@users.sourceforge.net>
Date: Mon, 6 Nov 2017 16:08:08 +0100
MIME-Version: 1.0
In-Reply-To: <20171106142450.GF28789@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

>> @@ -3682,7 +3678,7 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>>  		counting = false;
>>  		goto again;
>>  	}
>> -error:
>> +free_path:
>>  	btrfs_free_path(path);
>>  	if (enospc_errors) {
>>  		btrfs_info(fs_info, "%d enospc errors during balance",
>> @@ -3692,6 +3688,10 @@ static int __btrfs_balance(struct btrfs_fs_info *fs_info)
>>  	}
>>  
>>  	return ret;
>> +
>> +unlock:
>> +	mutex_unlock(&fs_info->delete_unused_bgs_mutex);
>> +	goto free_path;
>>  }
> 
> This is also an anti-pattern,

I got an other software development opinion for this use case.


> the label followed by a goto jumping back to the exit/cleanup block,
> right at the end of a function.

I find that this way can be useful for efficient exception handling.


> I've sent some patches in the past to clean that up

Interesting …


> and don't want to reintroduce it.

Would you like to reconsider this view if the object code size
could be reduced a bit for the affected function implementation?

Regards,
Markus
