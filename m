Return-Path: <SRS0=6XAY=OO=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BC00C04EB9
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:59:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF1F8206B7
	for <linux-btrfs@archiver.kernel.org>; Wed,  5 Dec 2018 14:59:11 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org DF1F8206B7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727889AbeLEO7K (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 5 Dec 2018 09:59:10 -0500
Received: from tartarus.angband.pl ([54.37.238.230]:34080 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727610AbeLEO7K (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Wed, 5 Dec 2018 09:59:10 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1gUYdl-0003Gt-3l; Wed, 05 Dec 2018 15:59:05 +0100
Date:   Wed, 5 Dec 2018 15:59:05 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Nikolay Borisov <nborisov@suse.com>
Cc:     Goldwyn Rodrigues <rgoldwyn@suse.de>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 01/10] btrfs: create a mount option for dax
Message-ID: <20181205145905.xgwjyomiak6r22rs@angband.pl>
References: <20181205122835.19290-1-rgoldwyn@suse.de>
 <20181205122835.19290-2-rgoldwyn@suse.de>
 <4bf87dcb-dbac-c7ab-800c-98e10157f569@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4bf87dcb-dbac-c7ab-800c-98e10157f569@suse.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Wed, Dec 05, 2018 at 02:43:03PM +0200, Nikolay Borisov wrote:
> One question below though .
> 
> > +++ b/fs/btrfs/super.c
> > @@ -739,6 +741,17 @@ int btrfs_parse_options(struct btrfs_fs_info *info, char *options,
> >  		case Opt_user_subvol_rm_allowed:
> >  			btrfs_set_opt(info->mount_opt, USER_SUBVOL_RM_ALLOWED);
> >  			break;
> > +#ifdef CONFIG_FS_DAX
> > +		case Opt_dax:
> > +			if (btrfs_super_num_devices(info->super_copy) > 1) {
> > +				btrfs_info(info,
> > +					   "dax not supported for multi-device btrfs partition\n");
> 
> What prevents supporting dax for multiple devices so long as all devices
> are dax?

As I mentioned in a separate mail, most profiles are either redundant
(RAID0), require hardware support (RAID1, DUP) or are impossible (RAID5,
RAID6).

But, "single" profile multi-device would be useful and actually provide
something other dax-supporting filesystems don't have: combining multiple
devices into one logical piece.

On the other hand, DUP profiles need to be banned.  In particular, the
filesystem you mount might have existing DUP block groups.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ Ivan was a worldly man: born in St. Petersburg, raised in
⢿⡄⠘⠷⠚⠋⠀ Petrograd, lived most of his life in Leningrad, then returned
⠈⠳⣄⠀⠀⠀⠀ to the city of his birth to die.
