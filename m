Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38143 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757677AbaGAPFc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 1 Jul 2014 11:05:32 -0400
Date: Tue, 1 Jul 2014 17:05:29 +0200
From: David Sterba <dsterba@suse.cz>
To: Satoru Takeuchi <takeuchi_satoru@jp.fujitsu.com>
Cc: Wang Shilong <wangsl.fnst@cn.fujitsu.com>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        dsterba@suse.cz, sandeen@redhat.com, rm@romanrm.net,
        koen@dominion.thruhere.net
Subject: Re: [PATCH v6] btrfs: label should not contain return char
Message-ID: <20140701150529.GK1553@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1400519071-5580-1-git-send-email-anand.jain@oracle.com>
 <1400813402-27474-1-git-send-email-anand.jain@oracle.com>
 <53B245AA.6060209@jp.fujitsu.com>
 <53B25931.2030200@cn.fujitsu.com>
 <53B26A87.4080800@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <53B26A87.4080800@jp.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jul 01, 2014 at 05:00:07PM +0900, Satoru Takeuchi wrote:
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -363,7 +363,8 @@ static ssize_t btrfs_label_show(struct kobject *kobj,
>  				struct kobj_attribute *a, char *buf)
>  {
>  	struct btrfs_fs_info *fs_info = to_fs_info(kobj);
> -	return snprintf(buf, PAGE_SIZE, "%s\n", fs_info->super_copy->label);
> +	char *label = fs_info->super_copy->label;
> +	return snprintf(buf, PAGE_SIZE, label[0] ? "%s\n" : "%s", label);

I'd prefer "" instead of the "%s" branch, but does not matter that much,

Reviewed-by: David Sterba <dsterba@suse.cz>
