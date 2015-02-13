Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:35045 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952AbbBMQPf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 13 Feb 2015 11:15:35 -0500
Date: Fri, 13 Feb 2015 17:15:33 +0100
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <Anand.Jain@oracle.com>
Cc: dsterba@suse.cz, linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 22/24] Btrfs: sysfs: don't fail seeding for the sake of
 sysfs kobject issue
Message-ID: <20150213161533.GL8720@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1423439785-10260-1-git-send-email-anand.jain@oracle.com>
 <1423439785-10260-23-git-send-email-anand.jain@oracle.com>
 <20150211184057.GJ28877@twin.jikos.cz>
 <54DC1C7E.6050309@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54DC1C7E.6050309@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Feb 12, 2015 at 11:22:38AM +0800, Anand Jain wrote:
> 
> 
> On 02/12/2015 02:40 AM, David Sterba wrote:
> > On Mon, Feb 09, 2015 at 07:56:23AM +0800, Anand Jain wrote:
> >> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> >> ---
> >>   fs/btrfs/volumes.c | 3 ++-
> >>   1 file changed, 2 insertions(+), 1 deletion(-)
> >>
> >> diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
> >> index 51873ec..1490723 100644
> >> --- a/fs/btrfs/volumes.c
> >> +++ b/fs/btrfs/volumes.c
> >> @@ -2249,7 +2249,8 @@ int btrfs_init_new_device(struct btrfs_root *root, char *device_path)
> >>   						root->fs_info->fsid);
> >>   		if (kobject_rename(&root->fs_info->fs_devices->super_kobj,
> >>   								fsid_buf))
> >> -			goto error_trans;
> >> +			printk(KERN_WARNING\
> >> +			"BTRFS: sysfs: failed to create fsid for sprout\n");
> >
> > You can safely use btrfs_warn here.
> >
> 
> right. I tried to know what to use before, but wasn't sure.

There's already btrfs_error used in the function. The only context where
the message macros are not usable is during mount when fs_info is not
available.

> would you be 
> able to accept it as it is ? OR I can send a new patch to correct this. 
> Just that changing this commit would fail further commits like
>    Btrfs: sysfs: support seed devices in the sysfs layout.

But this patch also needs to apply the same sort of change, please
resend. Thanks.
