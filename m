Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:30906 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932711AbcECXb6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 3 May 2016 19:31:58 -0400
Subject: Re: [PATCH v2] btrfs: cleanup assigning next active device with a
 check
To: dsterba@suse.cz
References: <1460978752-27375-1-git-send-email-anand.jain@oracle.com>
 <1462143728-3000-1-git-send-email-anand.jain@oracle.com>
 <20160502152618.GK29353@suse.cz> <572876FB.4070208@oracle.com>
 <20160503174728.GM29353@twin.jikos.cz>
Cc: linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <572934EB.8030604@oracle.com>
Date: Wed, 4 May 2016 07:31:55 +0800
MIME-Version: 1.0
In-Reply-To: <20160503174728.GM29353@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>>    While here can also integrate this.
>>
>>    [PATCH 1/1] btrfs: fix lock dep warning move scratch super outside of
>> chunk_mutex
>
> That one has been in for-next for some time.

There is another patch which is similarly named (sorry about that),
I see that one but not this.

---------
git log -i --author=anand.jain@oracle.com --oneline  | egrep "btrfs: fix 
lock dep"
58681ad85b9f btrfs: fix lock dep warning, move scratch dev out of 
device_list_mutex and uuid_mutex

git status
On branch for-next
Your branch is up-to-date with 'origin/for-next'.
nothing to commit, working directory clean
----------

Thanks, Anand
