Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:40338 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab3LQPD2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 17 Dec 2013 10:03:28 -0500
Received: by mail-pa0-f52.google.com with SMTP id ld10so4562031pab.25
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 07:03:28 -0800 (PST)
Content-Type: text/plain; charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Subject: Re: [PATCH] btrfs-progs: fix btrfstune silence on failure
From: Wang Shilong <wangshilong1991@gmail.com>
In-Reply-To: <20131217143545.GO6498@twin.jikos.cz>
Date: Tue, 17 Dec 2013 23:03:22 +0800
Cc: Gui Hecheng <guihc.fnst@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
Message-Id: <E49208AC-15A8-468F-85DD-30EF354D9FE4@gmail.com>
References: <1386928786-4976-1-git-send-email-guihc.fnst@cn.fujitsu.com> <20131217143545.GO6498@twin.jikos.cz>
To: dsterba@suse.cz
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi dave,

> On Fri, Dec 13, 2013 at 05:59:46PM +0800, Gui Hecheng wrote:
>> Originally, btrfstune will fail without any options and just exit
>> with no failure prompt.
> 
> Works for me:
> 
> $ ./btrfstune
> usage: btrfstune [options] device
> 	-S value        enable/disable seeding
> 	-r              enable extended inode refs
> 	-x enable skinny metadata extent refs
This is not the problem that this patch addressed,
you can try this:

# btrfstune /dev/sdb

This will not print out anything though it return 1.

> 
>> Now, the number of arguments are checked before parse options
>> and error msg will show up upon failure.
> 
> No, the arguments should be parsed first. The btrfstune utility does not
> use the same parser helpers like check_argc_exact and actually the bug
> you see could be caused by missing optind = 1 before the while () loop.
> 
> Can you please test if this helps?
> 
> --- a/btrfstune.c
> +++ b/btrfstune.c
> @@ -115,6 +115,7 @@ int main(int argc, char *argv[])
>        int skinny_flag = 0;
>        int ret;
> 
> +       optind = 1;

The default value of optind is 1, though we'd better assign the value.

I think Gui Hecheng s patch is right way to fix the problem, but maybe we can a check after arg passing,
something like:

if (!(seeding_flag + exrefs_flag + skinny_flag))
	fprintf(stderr , "You should assign at least one option for btrfstune");

What is your idea^_^

Thanks,
Wang
>        while(1) {
>                int c = getopt(argc, argv, "S:rx");
>                if (c < 0)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

