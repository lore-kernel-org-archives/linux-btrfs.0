Return-Path: <SRS0=/x7k=OG=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32612C43441
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:32:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F396420873
	for <linux-btrfs@archiver.kernel.org>; Tue, 27 Nov 2018 07:32:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F396420873
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729085AbeK0S27 (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 27 Nov 2018 13:28:59 -0500
Received: from mout.gmx.net ([212.227.15.18]:55397 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727796AbeK0S27 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Nov 2018 13:28:59 -0500
Received: from [0.0.0.0] ([210.140.77.29]) by mail.gmx.com (mrgmx001
 [212.227.17.184]) with ESMTPSA (Nemesis) id 0MJjOu-1gQRv449Ke-001EPQ; Tue, 27
 Nov 2018 08:31:55 +0100
Subject: Re: [PATCH 5/5] btrfs-progs: misc-tests/021: Do extra btrfs check
 before mounting
To:     Nikolay Borisov <nborisov@suse.com>, Qu Wenruo <wqu@suse.com>,
        linux-btrfs@vger.kernel.org
References: <20181127023315.28176-1-wqu@suse.com>
 <20181127023315.28176-6-wqu@suse.com>
 <e67f78ca-c039-3ada-8ded-199499a90e12@suse.com>
From:   Qu Wenruo <quwenruo.btrfs@gmx.com>
Openpgp: preference=signencrypt
Autocrypt: addr=quwenruo.btrfs@gmx.com; prefer-encrypt=mutual; keydata=
 xsBNBFnVga8BCACyhFP3ExcTIuB73jDIBA/vSoYcTyysFQzPvez64TUSCv1SgXEByR7fju3o
 8RfaWuHCnkkea5luuTZMqfgTXrun2dqNVYDNOV6RIVrc4YuG20yhC1epnV55fJCThqij0MRL
 1NxPKXIlEdHvN0Kov3CtWA+R1iNN0RCeVun7rmOrrjBK573aWC5sgP7YsBOLK79H3tmUtz6b
 9Imuj0ZyEsa76Xg9PX9Hn2myKj1hfWGS+5og9Va4hrwQC8ipjXik6NKR5GDV+hOZkktU81G5
 gkQtGB9jOAYRs86QG/b7PtIlbd3+pppT0gaS+wvwMs8cuNG+Pu6KO1oC4jgdseFLu7NpABEB
 AAHNIlF1IFdlbnJ1byA8cXV3ZW5ydW8uYnRyZnNAZ214LmNvbT7CwJQEEwEIAD4CGwMFCwkI
 BwIGFQgJCgsCBBYCAwECHgECF4AWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWCnQUJCWYC
 bgAKCRDCPZHzoSX+qAR8B/94VAsSNygx1C6dhb1u1Wp1Jr/lfO7QIOK/nf1PF0VpYjTQ2au8
 ihf/RApTna31sVjBx3jzlmpy+lDoPdXwbI3Czx1PwDbdhAAjdRbvBmwM6cUWyqD+zjVm4RTG
 rFTPi3E7828YJ71Vpda2qghOYdnC45xCcjmHh8FwReLzsV2A6FtXsvd87bq6Iw2axOHVUax2
 FGSbardMsHrya1dC2jF2R6n0uxaIc1bWGweYsq0LXvLcvjWH+zDgzYCUB0cfb+6Ib/ipSCYp
 3i8BevMsTs62MOBmKz7til6Zdz0kkqDdSNOq8LgWGLOwUTqBh71+lqN2XBpTDu1eLZaNbxSI
 ilaVzsBNBFnVga8BCACqU+th4Esy/c8BnvliFAjAfpzhI1wH76FD1MJPmAhA3DnX5JDORcga
 CbPEwhLj1xlwTgpeT+QfDmGJ5B5BlrrQFZVE1fChEjiJvyiSAO4yQPkrPVYTI7Xj34FnscPj
 /IrRUUka68MlHxPtFnAHr25VIuOS41lmYKYNwPNLRz9Ik6DmeTG3WJO2BQRNvXA0pXrJH1fN
 GSsRb+pKEKHKtL1803x71zQxCwLh+zLP1iXHVM5j8gX9zqupigQR/Cel2XPS44zWcDW8r7B0
 q1eW4Jrv0x19p4P923voqn+joIAostyNTUjCeSrUdKth9jcdlam9X2DziA/DHDFfS5eq4fEv
 ABEBAAHCwHwEGAEIACYWIQQt33LlpaVbqJ2qQuHCPZHzoSX+qAUCWdWBrwIbDAUJA8JnAAAK
 CRDCPZHzoSX+qA3xB/4zS8zYh3Cbm3FllKz7+RKBw/ETBibFSKedQkbJzRlZhBc+XRwF61mi
 f0SXSdqKMbM1a98fEg8H5kV6GTo62BzvynVrf/FyT+zWbIVEuuZttMk2gWLIvbmWNyrQnzPl
 mnjK4AEvZGIt1pk+3+N/CMEfAZH5Aqnp0PaoytRZ/1vtMXNgMxlfNnb96giC3KMR6U0E+siA
 4V7biIoyNoaN33t8m5FwEwd2FQDG9dAXWhG13zcm9gnk63BN3wyCQR+X5+jsfBaS4dvNzvQv
 h8Uq/YGjCoV1ofKYh3WKMY8avjq25nlrhzD/Nto9jHp8niwr21K//pXVA81R2qaXqGbql+zo
Message-ID: <dc4053d8-ecdc-4c50-1081-09362ec2f0ab@gmx.com>
Date:   Tue, 27 Nov 2018 15:31:51 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <e67f78ca-c039-3ada-8ded-199499a90e12@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Provags-ID: V03:K1:+q6rvJSooV8JKXwwjDyHqhRQE81WuP4WAAQHZhs2tGlr8gybgV9
 dXrmBmn+adnZ/cLdHEFndaTKopGw4koCkBXgL4yxexzfQcWr8XVA+svY7c3C1+4HMRBVmIh
 iub7+NDAfB0Lxu7rJzQWZImOudN8qhcoKgS27JxNcnQ8BSLaXjxGNLKSSfZ62vH4gbAESQf
 MhdK8AHg0Q2RyewZItoFA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:aD01QnkqWYI=:ZWIOAZaUTXwuxHsRVQIF8n
 qzHcqOjKWxgK/m31Gk2bnyNUCFu4oC61ZfoIaxYkvgo/ARlzq+WTVeu8Qwo2mbgidZP9beJuf
 NyGT4XLcc0Fx8SNLut/umDFm6NpEAAeYgMsJJjMHQFx4dAPwZK4jJ9PUizYxHZZbgQ2wFIRP/
 TjO3i/1AGSNj5z78JFFLetwm5C8BGZlXHWYMh6390EVH+oY6DsFcbCidDzByr9wnlX3NTirck
 qgW4EVuPpbj0e8M4uChghckUiSh8Rx+wuJifW8vofF8oiDj+uwEr9CdKPAfy1xLGysw/eWMNv
 vDCcapXpx/yCnjoyboX35RbltGfGaUAH/5zkltRaKksq6XEzt/BmNfMdadH1FLYXlrhxIUtRg
 c/zMnZAOgdGz3tnVY8yxUNLfiZAEh1lYXEtwJFyaJHaVjcqW6PgnfwWn9t979A8uLop7cjUvi
 w/9FMVoCKtM3i96yXvuCl7bKnmuPv5gGrBhIxBUj/8vPO6n5ULNLP45IfQXDiUL6oXCukjjsR
 y0SUwOuhJ0ixtZ5XxJfBGW5kRjn8t79aowMZFun7cjahsu9KyazTp1wA6Wu5wueGczHM1yJv8
 kKNhCL2yf1sw5w/P8GJTJ1ndwUHzS/CfxUyM1rIoQ97zHwtN0rP+Itt2OInFNJj7a5HfL6T/r
 pjgHTGUaxtOo7zlgFIyQ3Kg1EWdTuAWYX/tj4uDHsYJfvO6HEhilExUZ1EVmjl1YVRxqbec3f
 M/oHhljZ21rtcyYTfZ644jGAJhvQ9ImuzeNVA97k9PklMqA6+c88/3WbFp2pr9aXD+7mGaiA6
 8L1ybzcovM5BP5iD2AcR9r6wL59hKFIsCFpIIx8OUj924YVb3hXyO/2phEmFJOXFsWd4IDLID
 q1qHc39/2IqCW11ithi7Mn7blOAZ72WqgOJWuJVlSFg+Hn83qQcAoivclCU9DV
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org



On 2018/11/27 下午3:29, Nikolay Borisov wrote:
> 
> 
> On 27.11.18 г. 4:33 ч., Qu Wenruo wrote:
>> Test case misc/021 is testing if we could mount a single disk btrfs
>> image recovered from multi disk fs.
>>
>> The problem is, current kernel has extra check for block group, chunk
>> and dev extent.
>> This means any image can't pass btrfs check for chunk tree will not
>> mount.
>>
>> So do extra btrfs check before mount, this will also help us to locate
>> the problem in btrfs-image easier.
>>
>> Signed-off-by: Qu Wenruo <wqu@suse.com>
>> ---
>>  tests/misc-tests/021-image-multi-devices/test.sh | 3 +++
>>  1 file changed, 3 insertions(+)
>>
>> diff --git a/tests/misc-tests/021-image-multi-devices/test.sh b/tests/misc-tests/021-image-multi-devices/test.sh
>> index 5430847f4e2f..26beae6e4b85 100755
>> --- a/tests/misc-tests/021-image-multi-devices/test.sh
>> +++ b/tests/misc-tests/021-image-multi-devices/test.sh
>> @@ -37,6 +37,9 @@ run_check $SUDO_HELPER wipefs -a "$loop2"
>>  
>>  run_check $SUDO_HELPER "$TOP/btrfs-image" -r "$IMAGE" "$loop1"
>>  
>> +# Run check to make sure there is nothing wrong for the recovered image
>> +run_check "$TOP/btrfs" check "$loop1"
> 
> I think this needs to be run_check $SUDO_HELPER "$TOP/btrfs" check "$loop1"

For read-only check, it's OK and I always run the tests using normal
user, no privilege problem.

Thanks,
Qu

>> +
>>  run_check $SUDO_HELPER mount "$loop1" "$TEST_MNT"
>>  new_md5=$(run_check_stdout md5sum "$TEST_MNT/foobar" | cut -d ' ' -f 1)
>>  run_check $SUDO_HELPER umount "$TEST_MNT"
>>
