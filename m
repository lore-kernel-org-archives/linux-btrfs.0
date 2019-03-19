Return-Path: <SRS0=+tZ8=RW=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45963C43381
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 04:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 175D820854
	for <linux-btrfs@archiver.kernel.org>; Tue, 19 Mar 2019 04:47:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfCSErH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 19 Mar 2019 00:47:07 -0400
Received: from mout.gmx.net ([212.227.17.21]:43429 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725934AbfCSErH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 19 Mar 2019 00:47:07 -0400
Received: from [0.0.0.0] ([54.250.245.166]) by mail.gmx.com (mrgmx101
 [212.227.17.174]) with ESMTPSA (Nemesis) id 0MIiHs-1h8JZr2eMa-002Kg7; Tue, 19
 Mar 2019 05:47:00 +0100
Subject: Re: [PATCH 3/3] btrfs: Avoid possible qgroup_rsv_size overflow in
 btrfs_calculate_inode_block_rsv_size
To:     Nikolay Borisov <nborisov@suse.com>, linux-btrfs@vger.kernel.org
References: <20190318154520.4086-1-nborisov@suse.com>
 <20190318154520.4086-4-nborisov@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 mQENBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAG0IlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT6JAVQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVuQENBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAGJATwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <ae22172a-b1df-7608-914a-0edbdb2f4e96@gmx.com>
Date:   Tue, 19 Mar 2019 12:46:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.3
MIME-Version: 1.0
In-Reply-To: <20190318154520.4086-4-nborisov@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:xaASTvws6PehWckZWrMLCGoDcmNBQRvxl6nOSx7XDCmSfb1Qdga
 fxIfjxkpYWFasDd2yip7TAN/+yvPRFk+iV84S7mIv1y4RqALvcI+ZxZE6BV2YleOpkkP6Tb
 R7NZuuLAU+nUozVrUZx4adlfYqb6CtoOwBpjquk0RxNTBkOynVzVBPEtlnhRMFpXSQrh5t1
 LAH3LNBX15854RvQbXyMw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:T0OcFgoueHg=:9/Dcby/8ryItktICIDjMZO
 CLuHebBpeuOSq5lbdy3Ca/OdZjlmytNMVfRN5Ew0QZzzVxei3ss6OXt6npurK8DlnR433GxgD
 ShHQPwXeBJsfqqh0njoil/p0QGK8Ob8cxMU2I2rGAMho6ttVoPiCAuontCl9dFHsyjPP7Fwhn
 Vs60xf0Xpr5bRtzyR30gDKB7Qdm9RDOZiq6IdsnSgc56Zv4UGtShP5a9fZ/KV+hM5J4KDPecE
 fuzSeCAJ2fCgyzqyzXz3Ijo+DkDtDyEkJm1l8a11Ibn+cGvziJnF1/52TzgbEdhdbDf1IbRr8
 ++OKsrRjSUfBOD6MWgsey+vZ6UPdQgs1Rem8lnPRU+gIdiN81vqrUnn0KjDzT36IPg5gps9B3
 j5C2HU3ag8cgxuI0FNv6jpF8Cm6euBKc+gSLuWtZYkubCApW+ceEqn9oFEF26QadHen5TtIfw
 uJgWyL0zbYi79cIsQFEJhP2ChSrAq6Q7khXyhz+vz6kyEGyTGMGa6oaOHBvbwCUKiGJ2/DY7f
 TqO5Wo5D+UpdKTJlAXtxq/R91MMdyRnGww+ePquySSezf0MryxEssjXnQAPielJoyN1TTTT2x
 gUOjdOp5MqnN12xzh3YLaNGmMAmgFHXRD0Fxd7+VLZTiNm0s5D6RN+dExg377EsWrCK8+B1Bm
 ZcfB+Qj++Jv9P4o4orwCA+Gn+VmLTkvTFuoDPUM12oqZ3UDy6zdIhgie9A33ksOCtF7JUZxEn
 tmweaLYaYM/hqvsvaZFpoIfxsCieMUBF31/LbaFCZrrygYKPtt+0p1ZlIcTraZVhoK3oR+q2C
 txsvTv726iIzOa38EFfui0h69CTZtXpeIw73chLBl4y7XtG968NqHg1nEyc3qYqjV4/p8fyDY
 9oXfQJ9gglic2lmhZE7zwr31VbrOQfRHue6km2xpotbjb2oRd+leVja2LKCjyDm/LlimyEp5i
 3/TcdTSkcpg==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2019/3/18 下午11:45, Nikolay Borisov wrote:
> qgroup_rsv_size is calculated as the product of
> outstanding_extent * fs_info->nodesize. The product is calculated with
> 32 bith precision since both variables are defined as u32. Yet
> qgroup_rsv_size expects a 64 bit result.
> 
> Avoid possible multiplication overflow by casting outstanding_extent to
> u64.
> 
> Fixes-coverity-id: 1435101
> ff6bc37eb7f6 ("btrfs: qgroup: Use independent and accurate per inode qgroup rsv")
> 
> Signed-off-by: Nikolay Borisov <nborisov@suse.com>
> ---
>  fs/btrfs/extent-tree.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/btrfs/extent-tree.c b/fs/btrfs/extent-tree.c
> index b085d8215f0e..beddf9eef4a2 100644
> --- a/fs/btrfs/extent-tree.c
> +++ b/fs/btrfs/extent-tree.c
> @@ -6173,7 +6173,7 @@ static void btrfs_calculate_inode_block_rsv_size(struct btrfs_fs_info *fs_info,
>  	 *
>  	 * This is overestimating in most cases.
>  	 */
> -	qgroup_rsv_size = outstanding_extents * fs_info->nodesize;
> +	qgroup_rsv_size = (u64) outstanding_extents * fs_info->nodesize;

I'm a little uncertain about what's the proper way to do a u32 * u32 and
get a u64 in C.

For division we have DIV macro but not for multiple.

Thanks,
Qu

>  
>  	spin_lock(&block_rsv->lock);
>  	block_rsv->size = reserve_size;
> 
