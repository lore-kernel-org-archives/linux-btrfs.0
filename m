Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:39804 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751181AbeDGKlV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Sat, 7 Apr 2018 06:41:21 -0400
Subject: Re: [PATCH 07/16] btrfs: add proper safety check before resuming
 dev-replace
From: Anand Jain <anand.jain@oracle.com>
To: David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org
References: <cover.1522780026.git.dsterba@suse.com>
 <23d9506da78be87309480cd39e884242ef2ff42f.1522780026.git.dsterba@suse.com>
 <2e3e3ca8-a1c4-19c3-6b85-7a4e1d30c6e9@oracle.com>
Message-ID: <9b0db829-f84f-845d-128d-b12b00b01849@oracle.com>
Date: Sat, 7 Apr 2018 18:43:19 +0800
MIME-Version: 1.0
In-Reply-To: <2e3e3ca8-a1c4-19c3-6b85-7a4e1d30c6e9@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 04/07/2018 02:42 PM, Anand Jain wrote:
> 
> 
> On 04/04/2018 02:34 AM, David Sterba wrote:
>> The device replace is paused by unmount or read only remount, and
>> resumed on next mount or write remount.
>>
>> The exclusive status should be checked properly as it's a global
>> invariant and we must not allow 2 operations run. In this case, the
>> balance can be also paused and resumed under same conditions. It's
>> always checked first so dev-replace could see the EXCL_OP already taken,
>> BUT, the ioctl would never let start both at the same time.
>>
>> Replace the WARN_ON with message and return 0, indicating no error as
>> this is purely theoretical and the user will be informed. Resolving that
>> manually should be possible by waiting for the other operation to finish
>> or cancel the paused state.
> 
>   So if there is a paused balance and replace is triggered, a write
>   remount will reverse the process? 

  Ok, I am answering my own question:
  Even if the balance is paused that's considered as an exclusive
  operation in progress and does not let replace to start. So there
  is no scenario where paused-balance and replace could co-exist.

  So an asset will be better insted of return 0.

+	if (test_and_set_bit(BTRFS_FS_EXCL_OP, &fs_info->flags)) {
+		btrfs_info(fs_info,
+		"cannot resume dev-replace, other exclusive operation running");
+		return 0;
+	}


Thanks, Anand

> that is balance will start and
>   replace will hit EXCL_OP and thus canceled? How does it work in
>   this case?
> 
> Thanks, Anand
> -- 
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
