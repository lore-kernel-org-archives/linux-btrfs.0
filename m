Return-Path: <SRS0=cHbd=PD=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.0 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEB37C43444
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:43:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9520D21741
	for <linux-btrfs@archiver.kernel.org>; Wed, 26 Dec 2018 05:43:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbeLZFnY (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Wed, 26 Dec 2018 00:43:24 -0500
Received: from mout.gmx.net ([212.227.17.22]:45595 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725889AbeLZFnY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Wed, 26 Dec 2018 00:43:24 -0500
Received: from [0.0.0.0] ([173.82.105.236]) by mail.gmx.com (mrgmx103
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0M7H2Y-1hXxmc1E6o-00x3bx; Wed, 26
 Dec 2018 06:43:09 +0100
Subject: Re: [PATCH v2] btrfs: add a check for sysfs_create_group
To:     Kangjie Lu <kjlu@umn.edu>
Cc:     pakki001@umn.edu, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20181226053744.74740-1-kjlu@umn.edu>
From:   Su Yue <Damenly_Su@gmx.com>
Message-ID: <a840f129-9626-9b96-be2c-173b3e9371fe@gmx.com>
Date:   Wed, 26 Dec 2018 13:51:16 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.2
MIME-Version: 1.0
In-Reply-To: <20181226053744.74740-1-kjlu@umn.edu>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:lFxkscyVtjggi+zzSLUrNNsRK3Ab5RvLcpx6PxUoBduz9/rhVZL
 7u4Vw3Ka88th18D58WFsTc2ecbX1rhbadBGRRXX9lAW3tM/dHfVDB4rNl3lGPwWjWHPFo7A
 g5mPGzflArZLlgbl/VmqH11MwvbwkNWD9C4rAsegHMbWspJ7MWQvmqLmoO1cfEBY834BvpQ
 hw3TkVo4FIpyUersR6xeA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:gIN2HJk2Vao=:rwMS5Id+bqEsK8qGVp4SlN
 nPFheSL1oozGYchouQEUgTLe3EjJtYr/NR9YHRVhjYooc3QLcKPHPnisvggsHafrlMB3RohIO
 4u7VJVLs7UaTmfw2f1ogxKT8EPhdtRHV+4H/sHcu/21b7aR813iOoBXBGU21J14OGl5X8Fy2o
 edejlBJNNtmFwDDl/ih1Y7WTSRwaQEgoJcBqQ68w524Jqy/hi2HzZTgTSC5f9R1vABP8JhcTE
 34HIkgsUWuw6ObIdV3Y2ByUfpw/Y3/N5aZBTE0lDqBoVXfWeE+PCEHZf9dHsaf8Tt2Ttwy0Zm
 3xiiVjbvsm0Z6AYbAg+WkuSu4YCP8+kRDbPKDbIdoK/FG0Ly3X0vfEM4kkSHr3Ry4RxOsj5rw
 x64xN8+PoYLq6GNyhK0Lc7FrG5IJ8FMNOgUffo0iXruHXiq3pcJypHATrUh9LIlPNdiGhKAaO
 FR0HqVUmKLrAcE7E4cWH9LyGx2SqiaKo4FMRN29t+TAH+YaugWpcUx4jbEN5u4Zp/h7nJ+rCz
 LdQYCLQR+RF8VXa8g+c8piNRtCQtv0cI73JoVB38CoHuRrrMsMIJbuPkfP4WfdfbYC+QPxYmB
 fWc+u3TtxRP1fh0+WyABZlKruN0K02qmQIwDud+vxXw7INUvIBS6fk/MrsV5FsIWAzSIZrZ+x
 E+7r+MTGzhA2na/8519e6Tul9NyY0IV1egC++2Bjj842QaVdYXufKRPNrMe/utpTssgRE9BoS
 tAlDW4ZNle1JGvZaaOkAoArR0EjiTop6sT9WMim9EaUow9Ij3X6m0PXOB+zzFt8kx8lzoHqed
 Bb2ojDkswMxxusz1pmdTGz1fgikCKTrp8eP0fVCji6WVTV6vW5X25J6OfDS3TxDJViEsTUyyu
 x06o0W6R1xck7elb2/LPUiTHbjztDJfadjUsB3tI2V6NjtcugpNpa17+UGh65MFiuEMXXdKWf
 YeYX7P6Hubbg93DWjaQe6W40NcvThXlooorBUBHfk4ESxyesbjzaUlUlrkxvAEfpaHPEuCE4a
 NNvSCoqQ8Irs+p4e4nJCwfhp0WENpp+UBXR4VBIYRZ7uRvD5AAKhMpr2S+uUxra4A22MPNulJ
 ww7nytjai0vNoc=
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 12/26/18 1:37 PM, Kangjie Lu wrote:
> In case sysfs_create_group fails, let's check its return value and
> issues an error message.
> 
> Signed-off-by: Kangjie Lu <kjlu@umn.edu>
> ---
>   fs/btrfs/sysfs.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/fs/btrfs/sysfs.c b/fs/btrfs/sysfs.c
> index 3717c864ba23..24ef416e700b 100644
> --- a/fs/btrfs/sysfs.c
> +++ b/fs/btrfs/sysfs.c
> @@ -889,6 +889,8 @@ void btrfs_sysfs_feature_update(struct btrfs_fs_info *fs_info,
>   	 */
>   	sysfs_remove_group(fsid_kobj, &btrfs_feature_attr_group);
>   	ret = sysfs_create_group(fsid_kobj, &btrfs_feature_attr_group);
> +	if (ret)
> +		btrfs_err(fs_info, "failed to create btrfs_feature_attr_group.\n");

NIT: ".\n" is unnecessary.

---
Su
>   }
>   
>   static int btrfs_init_debugfs(void)
> 
