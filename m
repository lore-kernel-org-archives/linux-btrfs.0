Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42505 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751462Ab3IRPbV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 18 Sep 2013 11:31:21 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so7184796pbb.33
        for <linux-btrfs@vger.kernel.org>; Wed, 18 Sep 2013 08:31:21 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH 4/4] Btrfs-progs: add super-recover to recover bad supers
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20130918151304.GD6810@twin.jikos.cz>
Date: Wed, 18 Sep 2013 23:31:16 +0800
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <936776EC-7D7D-458F-960E-E1CB56F9B4BA@gmail.com>
References: <1379492856-30639-1-git-send-email-wangsl.fnst@cn.fujitsu.com> <1379492856-30639-5-git-send-email-wangsl.fnst@cn.fujitsu.com> <20130918151304.GD6810@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hello David,

> On Wed, Sep 18, 2013 at 04:27:36PM +0800, Wang Shilong wrote:
>> --- a/disk-io.c
>> +++ b/disk-io.c
>> @@ -982,7 +982,8 @@ int btrfs_setup_chunk_tree_and_device_map(struct btrfs_fs_info *fs_info)
>> static struct btrfs_fs_info *__open_ctree_fd(int fp, const char *path,
>> 					     u64 sb_bytenr,
>> 					     u64 root_tree_bytenr, int writes,
>> -					     int partial, int restore)
>> +					     int partial, int restore,
>> +					     int run_ioctl)
> 
> Yet another parameter to __open_ctree_fd, this really needs a cleanup.
> (Later is fine.)

I have considered about this, __open_ctree_fd() is a *static* helper, if i don't
add another parameter to it. I have to move out of __open_ctree_fd()  into
open_ctree_with_broken_super() which also seems  not good!


> 
>> +	root = open_ctree_with_broken_super(record->device_name,
>> +					record->bytenr, O_RDWR);
> 
> The last parameter is 'writes', I think it's 0/1, not the open() flags.

Yeah,  will fix it.

> 
>> +	BUG_ON(!root);
> 
> Is it a fatal error to BUG_ON here? Please add proper error handling.

Yes, BUG_ON() is not really friendly, let me see if i can handle it more gracefully.

Thanks,
Wang
> 
> thanks,
> david
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

