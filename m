Return-Path: <SRS0=UEav=BA=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8DCDC433DF
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 20:55:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE9F2068F
	for <linux-btrfs@archiver.kernel.org>; Tue, 21 Jul 2020 20:55:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728960AbgGUUzI (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 21 Jul 2020 16:55:08 -0400
Received: from bang.steev.me.uk ([81.2.120.65]:40651 "EHLO smtp.steev.me.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726029AbgGUUzI (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 21 Jul 2020 16:55:08 -0400
Received: from [2001:8b0:162c:2:b967:df01:f018:57e2]
        by smtp.steev.me.uk with esmtpsa (TLS1.3:TLS_AES_128_GCM_SHA256:128)
        (Exim 4.93.0.4)
        id 1jxzI3-006ypf-EV; Tue, 21 Jul 2020 21:55:07 +0100
Subject: Re: [RFC] btrfs: strategy to perform a rollback at boot time
To:     Goffredo Baroncelli <kreijack@libero.it>,
        linux-btrfs@vger.kernel.org
References: <20200721203340.275921-1-kreijack@libero.it>
From:   Steven Davies <btrfs-list@steev.me.uk>
Message-ID: <1e058a3e-a563-152b-b6df-57fa18b13df8@steev.me.uk>
Date:   Tue, 21 Jul 2020 21:55:07 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721203340.275921-1-kreijack@libero.it>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On 21/07/2020 21:33, Goffredo Baroncelli wrote:
> 
> Hi all,
> 
> this is an RFC to discuss a my idea to allow a simple rollback of the
> root filesystem at boot time.
> 
> The problem that I want to solve is the following: DPKG is very slow on
> a BTRFS filesystem. The reason is that DPKG massively uses
> sync()/fsync() to guarantee that the filesystem is always coherent even
> in case of sudden shutdown.
> 
> The same can be useful even to the RPM Linux based distribution (which however
> suffer less than DPKG).
> 
> A way to avoid the sync()/fsync() calls without loosing the DPKG
> guarantees, is:
> 1) perform a snapshot of the root filesystem (the rollback one)
> 2) upgrade the filesystem without using sync/fsync
> 3) final (global) sync
> 4) destroy the rollback snapshot
> 
> If an unclean shutdown happens between 1) and 4), two subvolume exists:
> the 'main' one and the 'rollback' one (which is the snapshot before the
> update). In this case the system at boot time should mount the "rollback"
> subvolume instead of the "main" one. Otherwise in case of a "clean" boot, the
> "rollback" subvolume doesn't exist and only the "main" one can be
> mounted.
> 
> In [1] I discussed a way to implement the steps 1 to 4. (ok, I missed
> the point 3) ).
> 
> The part that was missed until now, is an automatic way to mount the rollback
> subvolume at boot time when it is present.
> 
> My idea is to allow more 'subvol=' option. In this case BTRFS tries all the
> passed subvolumes until the first succeed. So invoking the kernel as:
> 
>    linux root=UUID=xxxx rootflags=subvol=rollback,subvol=main ro
> 
> First, the kernel tries to mount the 'rollback' subvolume. If the rollback
> subvolume doesn't exist then it mounts the 'main' subvolume.
> 
> Of course after the mount, the system should perform a cleanup of the
> subvolumes: i.e. if a rollback subvolume exists, the system should destroy
> the "main" one (which contains garbage) and rename "rollback" to "main".
> To be more precise:
> 
> 	if test -d "rollback"; then
> 		if test -d "old"; then
> 			btrfs sub del "old"
> 		fi
> 		if test -d "main"; then
> 			mv "main" "old"
> 		fi
> 		mv "rollback" "main"
> 		btrfs sub del "old"
> 	fi
> 
> Comments are welcome

I like this idea. Do we have an easy way of detecting which subvolume 
has been mounted (through sysfs or similar), or would you expect to 
always be testing this based on the existence of certain 
subvolumes/directories?

-- 
Steven Davies
